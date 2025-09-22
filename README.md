# Imago

A powerful and flexible image widget for Flutter applications with support for network images, local assets, and file images.

[![pub package](https://img.shields.io/pub/v/imago.svg)](https://pub.dev/packages/imago)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Features

- 🖼️ **Multiple Image Types**: Support for network images, local SVG assets, local image assets, and file images
- 🚀 **Built-in Caching**: Automatic caching for network images using `cached_network_image`
- 🎨 **Customizable Placeholders**: Custom placeholder widgets and error handling
- 🛡️ **Error Handling**: Graceful error handling with customizable error widgets

## Getting Started

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  imago: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic Usage

```dart
import 'package:imago/imago.dart';

// Network image
Imago('https://example.com/image.jpg')

// Local SVG
Imago.localSvg('icon_name')

// Local image
Imago.localImage('image_name')

// File image
Imago.file('/path/to/image.jpg')
```

### Advanced Usage

```dart
// Network image with fallback
Imago.of(
  remoteUrl: 'https://example.com/image.jpg',
  localFallback: 'placeholder',
  localFallbackType: ImageType.localImage,
  width: 200,
  height: 200,
  borderRadius: BorderRadius.circular(10),
  showProgressIndicator: true,
)

// Custom placeholder
Imago(
  'https://example.com/image.jpg',
  width: 100,
  height: 100,
  placeholderBuilder: (context) => Container(
    color: Colors.grey[300],
    child: Icon(Icons.image),
  ),
  errorWidget: (context, url, error) => Container(
    color: Colors.red[100],
    child: Icon(Icons.error),
  ),
)

// SVG with custom styling
Imago.localSvg(
  'icon_name',
  size: 24,
  color: Colors.blue,
  borderRadius: BorderRadius.circular(4),
)
```

### Image Types

#### Network Images
```dart
Imago('https://example.com/image.jpg')
```

#### Local SVG Assets
```dart
// Automatically resolves to 'assets/svg/icon.svg'
Imago.localSvg('icon')

// Or use full path
Imago.localSvg('assets/svg/custom/icon.svg')
```

#### Local Image Assets
```dart
// Automatically resolves to 'assets/images/image.png'
Imago.localImage('image')

// Or use full path
Imago.localImage('assets/images/custom/image.png')
```

#### File Images
```dart
Imago.file('/storage/emulated/0/Download/image.jpg')
```

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

### Asset Existence Checking

```dart
// Check if asset exists (async)
bool exists = await Imago.assetExists('assets/images/placeholders/placeholder.png');

// Check if asset exists (sync)
bool exists = Imago.assetExistsSync('assets/images/placeholders/placeholder.png');

// Use with conditional logic
if (Imago.assetExistsSync('assets/images/custom/placeholder.png')) {
  Imago('https://example.com/image.jpg', placeholder: 'assets/images/custom/placeholder.png')
} else {
  // Uses default icon-based placeholder
  Imago('https://example.com/image.jpg')
}
```

### Default Placeholder

Imago now uses an icon-based placeholder by default (`Icons.image_outlined`) instead of requiring a placeholder image asset. This provides:

- **No asset dependency** - No need to include placeholder images
- **Consistent appearance** - Uses Material Design icons
- **Responsive sizing** - Icon scales with container size
- **Better performance** - No asset loading required

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

### ImageType Enum

- `ImageType.networkImage` - Network image loaded from URL
- `ImageType.localSvg` - Local SVG asset
- `ImageType.localImage` - Local image asset (PNG, JPG, etc.)
- `ImageType.file` - File from device storage

## Dependencies

- `cached_network_image: ^3.3.1` - For network image caching
- `flutter_svg: ^2.0.10+1` - For SVG support

## Requirements

- Flutter >= 3.0.0
- Dart >= 3.0.0

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you encounter any issues or have questions, please file an issue on the [GitHub repository](https://github.com/your-username/imago/issues).
