# Imago

A powerful and flexible image widget for Flutter applications with support for network images, local assets, and file images.

[![pub package](https://img.shields.io/pub/v/imago.svg)](https://pub.dev/packages/imago)
[![pub points](https://img.shields.io/pub/points/imago.svg)](https://pub.dev/packages/imago/score)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub last commit](https://img.shields.io/github/last-commit/venhdev/imago.svg)](https://github.com/venhdev/imago)
[![GitHub release](https://img.shields.io/github/v/release/venhdev/imago.svg)](https://github.com/venhdev/imago/releases)
[![GitHub code size](https://img.shields.io/github/languages/code-size/venhdev/imago.svg)](https://github.com/venhdev/imago)
[![GitHub top language](https://img.shields.io/github/languages/top/venhdev/imago.svg)](https://github.com/venhdev/imago)
[![GitHub Actions](https://img.shields.io/github/actions/workflow/status/venhdev/imago/publish.yml?branch=main)](https://github.com/venhdev/imago/actions)
[![Coverage](https://img.shields.io/badge/coverage-100%25-brightgreen.svg)](https://codecov.io/gh/venhdev/imago)
[![Made with ❤️](https://img.shields.io/badge/Made%20with-❤️-red.svg)](https://github.com/venhdev/imago)

## Features

- 🖼️ **Multiple Image Types**: Support for network images, local SVG assets, local image assets, and file images
- 🚀 **Built-in Caching**: Automatic caching for network images using `cached_network_image`
- 🎨 **Customizable Placeholders**: Custom placeholder widgets and error handling
- 🛡️ **Error Handling**: Graceful error handling with customizable error widgets

## Assets Structure

Place your assets in these directories for automatic path resolution:

- **SVG files**: `assets/svg/` (e.g., `assets/svg/icons/icon.svg`)
- **Image files**: `assets/images/` (e.g., `assets/images/logos/logo.png`)
- **Default placeholder**: `assets/images/placeholders/placeholder.png` (optional - uses icon fallback if not found)

Imago automatically resolves paths:
- `Imago.localSvg('icons/icon')` → `assets/svg/icons/icon.svg`
- `Imago.localImage('logos/logo')` → `assets/images/logos/logo.png`

### Factory Methods

#### `Imago.of()` - Remote with Fallback
```dart
Imago.of(
  remoteUrl: 'https://example.com/image.jpg',
  localFallback: 'placeholder',
  localFallbackType: ImageType.localImage,
  width: 200,
  height: 200,
)
```

#### `Imago.localSvg()` - SVG Assets
```dart
Imago.localSvg(
  'icon_name',
  size: 24,
  color: Colors.blue,
)
```

#### `Imago.localImage()` - Image Assets
```dart
Imago.localImage(
  'image_name',
  width: 100,
  height: 100,
  fit: BoxFit.cover,
)
```

#### `Imago.file()` - File Images
```dart
Imago.file(
  '/path/to/image.jpg',
  width: 200,
  height: 200,
)
```

### Customization Options

```dart
Imago(
  'https://example.com/image.jpg',
  width: 200,
  height: 200,
  fit: BoxFit.cover,
  borderRadius: BorderRadius.circular(10),
  color: Colors.blue,
  colorBlendMode: BlendMode.overlay,
  placeholder: 'assets/images/placeholders/placeholder.png',
  showProgressIndicator: true,
  shrinkOnError: false,
  shrinkOnLoading: false,
  fadeInDuration: Duration(milliseconds: 500),
  fadeOutDuration: Duration(milliseconds: 1000),
  httpHeaders: {'Authorization': 'Bearer token'},
  cacheKey: 'unique_cache_key',
  memCacheWidth: 300,
  memCacheHeight: 300,
)
```


### Default Placeholder

Imago now uses an icon-based placeholder by default (`Icons.image_outlined`) instead of requiring a placeholder image asset. This provides:

## API Reference

### Imago Constructor

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `url` | `String?` | - | The URL or path of the image |
| `width` | `double?` | - | Width of the image |
| `height` | `double?` | - | Height of the image |
| `fit` | `BoxFit?` | - | How the image should be inscribed |
| `type` | `ImageType` | `ImageType.networkImage` | Type of image |
| `borderRadius` | `BorderRadiusGeometry` | `BorderRadius.zero` | Border radius |
| `color` | `Color?` | - | Color to blend with image |
| `placeholder` | `String?` | - | Placeholder image path |
| `showProgressIndicator` | `bool` | `false` | Show progress indicator |
| `shrinkOnError` | `bool` | `false` | Shrink widget on error |
| `shrinkOnLoading` | `bool` | `false` | Shrink widget while loading |
| `hero` | `String?` | - | Hero tag for animations |
| `httpHeaders` | `Map<String, String>?` | - | HTTP headers for network requests |
| `fadeInDuration` | `Duration` | `Duration(milliseconds: 500)` | Fade in animation duration |
| `fadeOutDuration` | `Duration` | `Duration(milliseconds: 1000)` | Fade out animation duration |
| `memCacheWidth` | `int?` | - | Maximum width for memory cache |
| `memCacheHeight` | `int?` | - | Maximum height for memory cache |
| `cacheKey` | `String?` | - | Cache key for the image |

### ImageType Enum

- `ImageType.networkImage` - Network image loaded from URL
- `ImageType.localSvg` - Local SVG asset
- `ImageType.localImage` - Local image asset (PNG, JPG, etc.)
- `ImageType.file` - File from device storage

## Dependencies

- `cached_network_image: ^3.3.1` - For network image caching
- `flutter_svg: ^2.0.10+1` - For SVG support

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you encounter any issues or have questions, please file an issue on the [GitHub repository](https://github.com/venhdev/imago/issues).
