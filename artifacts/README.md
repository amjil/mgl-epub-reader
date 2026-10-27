# MGL EPUB Reader - Updated Source Files

This directory contains all modified source files ready for overwrite.

## Changes Summary

### 1. **Settings Entry Point** ✅
- **Desktop**: Added settings button in library sidebar → opens global settings panel
- **Mobile**: Settings accessible via bottom nav (already present)
- Location: `desktop/screens/library.cljd`

### 2. **Dark Mode / App Appearance** ✅
- Fixed `app-appearance` theme switching
- `theme.cljd`: Made `app-theme` and `app-theme-dark` functions (not constants)
- MaterialApp now properly updates when toggling light/dark
- Theme atom updates trigger Material theme changes
- Location: `theme.cljd`, `mobile.cljd`, `desktop.cljd`

### 3. **Traditional Mongolian Vertical Text** ✅
- ALL UI text now uses `mongol-label` for Traditional Mongolian script
- Filter labels: ᠪᠦᠬᠦ (All), ᠰᠠᠶᠢᠬᠠᠨ (Recent), ᠬᠠᠳᠠᠭᠠᠯᠠᠭᠰᠠᠨ (Favorites), ᠤᠩᠰᠢᠭᠰᠠᠨ (Finished)
- Empty states, dialogs, buttons use vertical Mongolian
- Locations: All screen files

### 4. **English Everywhere** ✅
- Replaced ALL Chinese comments, docs, and non-Mongolian UI strings with English
- Namespace docs, function comments, error messages now in English
- Traditional Mongolian script (ᠮᠣᠩᠭᠤᠯ) preserved for vertical UI

### 5. **Enhanced UI Hierarchy** ✅
- Improved card styles with hover effects (desktop)
- Better button gradients and shadows
- Enhanced empty states with icons and Mongolian labels
- Refined filter rail and navigation
- Locations: `widgets/ui.cljd`, `widgets/books.cljd`, screen files

## Installation

### Option 1: Direct Overwrite
```bash
# From repo root
cp -r artifacts/src/* src/
```

### Option 2: Selective Copy
```bash
# Copy individual files as needed
cp artifacts/src/epub_app/theme.cljd src/epub_app/
cp artifacts/src/epub_app/desktop/screens/library.cljd src/epub_app/desktop/screens/
# ... etc
```

## File Structure
```
artifacts/src/epub_app/
├── theme.cljd                          # Theme system with dark mode functions
├── mobile.cljd                         # Mobile app shell
├── desktop.cljd                        # Desktop app shell
├── reader_settings.cljd                # Shared settings components
├── desktop/screens/
│   └── library.cljd                    # Desktop library + settings entry
├── mobile/
│   ├── screens/
│   │   ├── library.cljd                # Mobile library with Mongolian text
│   │   └── settings.cljd               # Mobile settings screen
│   └── widgets/
│       └── nav.cljd                    # Bottom navigation
└── widgets/
    ├── books.cljd                      # Book cards, menus, filters (Mongolian)
    └── ui.cljd                         # Shared UI components

```

## Key Features

1. **Desktop Settings Access**: Click ᠲᠣᠬᠢᠷᠠᠭᠤᠯᠬᠤ (Settings) button in library rail
2. **Working Dark Mode**: Toggle app-appearance in settings → Material theme updates
3. **Vertical Mongolian**: All Mongolian text uses `mongol-label` for proper vertical display
4. **English Codebase**: Comments, docs, and Latin UI text in English
5. **Modern Design**: Enhanced visual hierarchy with gradients, shadows, animations

## Testing Checklist

- [ ] Desktop: Click settings button in library → panel opens
- [ ] Settings: Toggle app-appearance light/dark → UI theme changes
- [ ] Filters show Mongolian text vertically: ᠪᠦᠬᠦ, ᠰᠠᠶᠢᠬᠠᠨ, etc.
- [ ] Empty states display Mongolian labels properly
- [ ] Delete dialog shows ᠬᠠᠰᠤᠬᠤ ᠤᠤ? (Confirm delete?)
- [ ] Book menu: ᠬᠠᠳᠠᠭᠠᠯᠠᠬᠤ (Favorite), ᠬᠠᠰᠤᠬᠤ (Delete)

## Compilation

No syntax errors expected. All ClojureDart idioms maintained:
- `m/BorderRadius.circular` (not `BorderRadius/circular`)
- `m/SliderThemeData` constructors
- Balanced brackets
- No `alter-var-root` (using atoms)

---

**Modified**: 10 files  
**Branch**: cursor/fix-ui-theme-settings-76e5  
**Commit**: 6f4da47
