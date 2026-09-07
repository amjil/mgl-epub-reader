/// EPUB / reader exceptions. A single chapter failure must not crash the book.
class EpubException implements Exception {
  EpubException(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  String toString() =>
      cause == null ? 'EpubException: $message' : 'EpubException: $message ($cause)';
}

class EpubInvalidArchiveException extends EpubException {
  EpubInvalidArchiveException(super.message, [super.cause]);
}

class EpubContainerException extends EpubException {
  EpubContainerException(super.message, [super.cause]);
}

class EpubPackageException extends EpubException {
  EpubPackageException(super.message, [super.cause]);
}

class EpubManifestException extends EpubException {
  EpubManifestException(super.message, [super.cause]);
}

class EpubSpineException extends EpubException {
  EpubSpineException(super.message, [super.cause]);
}

class EpubXhtmlException extends EpubException {
  EpubXhtmlException(super.message, [super.cause]);
}

class EpubResourceException extends EpubException {
  EpubResourceException(super.message, [super.cause]);
}

class EpubPaginationException extends EpubException {
  EpubPaginationException(super.message, [super.cause]);
}
