import 'package:xml/xml.dart';

import '../model/book.dart';
import 'epub_exception.dart';
import 'epub_path.dart';

class EpubPackage {
  EpubPackage({
    required this.version,
    required this.opfPath,
    required this.metadata,
    required this.manifest,
    required this.spine,
    this.ncxId,
  });

  final String version;
  final String opfPath;
  final EpubMetadata metadata;
  final Map<String, EpubManifestItem> manifest;
  final List<EpubSpineItem> spine;
  final String? ncxId;

  bool get isEpub3 => version.startsWith('3');

  EpubManifestItem? itemById(String id) => manifest[id];

  EpubManifestItem? itemByHref(String href) {
    final wanted = stripFragment(href);
    for (final item in manifest.values) {
      if (item.href == wanted) return item;
    }
    return null;
  }

  EpubManifestItem? get navItem {
    for (final item in manifest.values) {
      if (item.isNav) return item;
    }
    return null;
  }

  EpubManifestItem? get ncxItem {
    if (ncxId != null && manifest.containsKey(ncxId)) {
      return manifest[ncxId];
    }
    for (final item in manifest.values) {
      if (item.isNcx) return item;
    }
    return null;
  }

  factory EpubPackage.parse(String opfXml, String opfPath) {
    try {
      final doc = XmlDocument.parse(opfXml);
      final package = firstDescendant(doc, 'package');
      if (package == null) {
        throw EpubPackageException('OPF missing package element');
      }
      final version = attr(package, 'version') ?? '2.0';
      final metadata = _parseMetadata(package);
      final manifestEl = firstDescendant(package, 'manifest');
      if (manifestEl == null) {
        throw EpubManifestException('OPF missing manifest');
      }
      final manifest = <String, EpubManifestItem>{};
      for (final item in descendantsByLocal(manifestEl, 'item')) {
        final id = attr(item, 'id');
        final href = attr(item, 'href');
        final media = attr(item, 'media-type') ?? attr(item, 'mediaType') ?? '';
        if (id == null || href == null) continue;
        final props = <String>{};
        final raw = attr(item, 'properties');
        if (raw != null && raw.trim().isNotEmpty) {
          props.addAll(raw.trim().split(RegExp(r'\s+')));
        }
        manifest[id] = EpubManifestItem(
          id: id,
          href: stripFragment(href),
          mediaType: media,
          properties: props,
        );
      }
      if (manifest.isEmpty) {
        throw EpubManifestException('OPF manifest is empty');
      }

      final coverFromMeta = _coverId(package);
      var resolvedMetadata = metadata;
      if (resolvedMetadata.cover == null) {
        final coverHref = _coverHref(manifest, coverFromMeta);
        resolvedMetadata = EpubMetadata(
          identifier: metadata.identifier,
          title: metadata.title,
          authors: metadata.authors,
          language: metadata.language,
          publisher: metadata.publisher,
          description: metadata.description,
          date: metadata.date,
          cover: coverHref,
        );
      }

      final spineEl = firstDescendant(package, 'spine');
      if (spineEl == null) {
        throw EpubSpineException('OPF missing spine');
      }
      final ncxId = attr(spineEl, 'toc');
      final spine = <EpubSpineItem>[];
      for (final itemref in descendantsByLocal(spineEl, 'itemref')) {
        final idref = attr(itemref, 'idref');
        if (idref == null) continue;
        if (!manifest.containsKey(idref)) {
          throw EpubSpineException('spine idref "$idref" not in manifest');
        }
        final linear = (attr(itemref, 'linear') ?? 'yes') != 'no';
        spine.add(EpubSpineItem(idref: idref, linear: linear));
      }
      if (spine.isEmpty) {
        throw EpubSpineException('OPF spine is empty');
      }

      return EpubPackage(
        version: version,
        opfPath: opfPath,
        metadata: resolvedMetadata,
        manifest: manifest,
        spine: spine,
        ncxId: ncxId,
      );
    } on EpubException {
      rethrow;
    } catch (e) {
      throw EpubPackageException('Invalid OPF', e);
    }
  }
}

EpubMetadata _parseMetadata(XmlElement package) {
  final meta = firstDescendant(package, 'metadata');
  if (meta == null) {
    return const EpubMetadata();
  }
  String? dc(String name) => textOf(firstDescendant(meta, name));
  final authors = descendantsByLocal(meta, 'creator')
      .map(textOf)
      .where((s) => s.isNotEmpty)
      .toList();
  var identifier = dc('identifier');
  if (identifier != null && identifier.isEmpty) identifier = null;
  var title = dc('title');
  if (title != null && title.isEmpty) title = null;
  var language = dc('language');
  if (language != null && language.isEmpty) language = null;
  var publisher = dc('publisher');
  if (publisher != null && publisher.isEmpty) publisher = null;
  var description = dc('description');
  if (description != null && description.isEmpty) description = null;

  return EpubMetadata(
    identifier: identifier,
    title: title,
    authors: authors,
    language: language,
    publisher: publisher,
    description: description,
    date: tryParseDate(dc('date')),
    cover: null,
  );
}

String? _coverId(XmlElement package) {
  final meta = firstDescendant(package, 'metadata');
  if (meta == null) return null;
  for (final el in descendantsByLocal(meta, 'meta')) {
    final name = attr(el, 'name');
    if (name == 'cover') return attr(el, 'content');
    final property = attr(el, 'property');
    if (property == 'cover-image') {
      return attr(el, 'content') ?? textOf(el);
    }
  }
  return null;
}

String? _coverHref(Map<String, EpubManifestItem> manifest, String? coverId) {
  if (coverId != null && manifest.containsKey(coverId)) {
    return manifest[coverId]!.href;
  }
  for (final item in manifest.values) {
    if (item.isCoverImage) return item.href;
  }
  return null;
}
