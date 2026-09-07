import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

/// Unified EPUB input. Reader core must not care where bytes come from.
abstract class EpubSource {
  Future<List<int>> read();
}

class BytesEpubSource implements EpubSource {
  BytesEpubSource(this.bytes);

  final List<int> bytes;

  @override
  Future<List<int>> read() async => bytes;
}

class FileEpubSource implements EpubSource {
  FileEpubSource(this.path);

  final String path;

  @override
  Future<List<int>> read() => File(path).readAsBytes();
}

class AssetEpubSource implements EpubSource {
  AssetEpubSource(this.assetPath);

  final String assetPath;

  @override
  Future<List<int>> read() async {
    final data = await rootBundle.load(assetPath);
    return data.buffer.asUint8List();
  }
}

class NetworkEpubSource implements EpubSource {
  NetworkEpubSource(this.url, {http.Client? client}) : _client = client;

  final String url;
  final http.Client? _client;

  @override
  Future<List<int>> read() async {
    final client = _client ?? http.Client();
    final owned = _client == null;
    try {
      final response = await client.get(Uri.parse(url));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw HttpException(
          'HTTP ${response.statusCode} fetching EPUB from $url',
          uri: Uri.parse(url),
        );
      }
      return response.bodyBytes;
    } finally {
      if (owned) client.close();
    }
  }
}
