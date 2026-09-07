# MGL EPUB Reader

An EPUB reading engine and reader built with Flutter and ClojureDart. EPUB is only the input format: it is parsed into an **MGL Document**, and reading, bookmarks, search, and notes are located with a stable **ReaderPosition** (`chapterId` + `blockId` + `offset`). WebView is not used as the core renderer.

The current stage covers opening EPUB files, the document model, paginated reading (horizontal / Mongolian vertical), the library, progress, bookmarks, and search. TTS is reserved in the spec and is not implemented yet.

## Architecture

```text
EPUB → Parser → MGL Document → Pagination → Reader UI
                              → Search / Bookmark / Note
```

The Dart layer (`lib/`) handles parsing, pagination, and persistence; ClojureDart (`src/`) handles UI and state.

## Dependencies

- [Clojure CLI](https://clojure.org/guides/install_clojure) (`clj`)
- [Flutter](https://docs.flutter.dev/get-started/install) (Dart SDK `>=3.3.1 <4.0.0`)
- Sibling local packages (see `deps.edn`):

| Path | Purpose |
|------|------|
| `mgl-components` | Shared UI |
| `mongol-virtual-keyboard` | Mongolian virtual keyboard |
| `mongol-ime` | Desktop IME |
| `mgl-ime-core` | IME / FST |
| `mgl-block-editor` | Block note editor (selection export API) |
| `mgl-richtext-editor` | Rich text (`mgl_editor_core`) |

## Getting started

```sh
clj -M:cljd init
clj -M:cljd flutter
```

Target a specific device:

```sh
clj -M:cljd flutter -d macos
```

Dart layer tests:

```sh
flutter test
```

Drift code generation (after changing table schemas; use JIT when native AOT compilation fails):

```sh
dart run build_runner build --delete-conflicting-outputs --force-jit
```

## Layout

```
lib/          Dart engine: EPUB / XHTML / MGL / pagination / search / Drift / Bridge
src/epub_app  ClojureDart app shell (library + reader)
src/epub/core Public ClojureDart operations (`epub.core.*`)
test/         Parsing, document conversion, pagination, positioning
```

After an EPUB is imported, the reading position is stored as `chapterId + blockId + offset`, not as a page number.

The library only stores metadata / path / progress / bookmark / annotation; the original EPUB remains on the file system.
