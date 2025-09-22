/// A powerful and flexible image widget for Flutter applications.
///
/// Imago provides a unified interface for displaying various types of images
/// including network images, local assets (SVG and PNG), and file images.
/// It includes built-in caching, error handling, and customizable placeholders.
library imago;

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Enum representing different types of images that Imago can handle.
enum ImageType {
  /// Network image loaded from URL
  networkImage,

  /// Local SVG asset
  localSvg,

  /// Local image asset (PNG, JPG, etc.)
  localImage,

  /// File from device storage
  file
}

/// A powerful and flexible image widget that supports multiple image types.
///
/// Imago provides a unified interface for displaying:
/// - Network images with caching
/// - Local SVG assets
/// - Local image assets
/// - File images from device storage
///
/// Features:
/// - Built-in caching for network images
/// - Customizable placeholders and error widgets
/// - Support for different image types
/// - Border radius support
/// - Loading and error state handling
/// - Progress indicators
/// - Hero animations support
class Imago extends StatelessWidget {
  /// Creates an Imago widget with the specified parameters.
  const Imago(
    this.url, {
    super.key,
    this.hero,
    this.sizeServer,
    this.isScale = false,
    this.fit,
    this.width,
    this.height,
    this.placeholder,
    this.httpHeaders,
    this.imageBuilder,
    this.progressIndicatorBuilder,
    this.errorWidget,
    this.fadeOutDuration = const Duration(milliseconds: 1000),
    this.fadeOutCurve = Curves.easeOut,
    this.fadeInDuration = const Duration(milliseconds: 500),
    this.fadeInCurve = Curves.easeIn,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.matchTextDirection = false,
    this.useOldImageOnUrlChange = false,
    this.color,
    this.filterQuality = FilterQuality.low,
    this.colorBlendMode,
    this.placeholderFadeInDuration,
    this.memCacheWidth,
    this.memCacheHeight,
    this.cacheKey,
    this.maxWidthDiskCache,
    this.maxHeightDiskCache,
    this.isShowAppBar = true,
    this.type = ImageType.networkImage,
    this.shrinkOnError = false,
    this.shrinkOnLoading = false,
    this.borderRadius = BorderRadius.zero,
    this.placeholderBuilder,
    this.showProgressIndicator = false,
  });

  /// Factory constructor for creating an Imago widget with local SVG assets.
  ///
  /// Automatically handles asset path resolution for SVG files.
  /// If the provided [url] doesn't start with 'assets', it will be prefixed
  /// with 'assets/svg/' and suffixed with '.svg'.
  factory Imago.localSvg(
    String? url, {
    /// Size will override width and height
    double? size,
    double? width = 24.0,
    double? height = 24.0,
    BoxFit fit = BoxFit.contain,
    BorderRadiusGeometry borderRadius = BorderRadius.zero,
    Color? color,
    bool? shrinkOnError,
  }) {
    return Imago(
      (url != null)
          ? (url.startsWith('assets') ? url : 'assets/svg/$url.svg')
          : null,
      width: size ?? width,
      height: size ?? height,
      fit: fit,
      type: ImageType.localSvg,
      borderRadius: borderRadius,
      color: color,
      shrinkOnError: shrinkOnError ?? false,
    );
  }

  /// Factory constructor for creating an Imago widget with file images.
  ///
  /// Displays images from device file system.
  factory Imago.file(
    String? url, {
    /// Size will override width and height
    double? size,
    double? width,
    double? height,
    BoxFit? fit,
    BorderRadiusGeometry borderRadius = BorderRadius.zero,
    bool? shrinkOnError,
  }) {
    return Imago(
      url,
      width: size ?? width,
      height: size ?? height,
      fit: fit,
      type: ImageType.file,
      borderRadius: borderRadius,
      shrinkOnError: shrinkOnError ?? false,
    );
  }

  /// Factory constructor for creating an Imago widget with local image assets.
  ///
  /// Automatically handles asset path resolution for image files.
  /// If the provided [url] doesn't start with 'assets', it will be prefixed
  /// with 'assets/images/' and suffixed with '.png'.
  factory Imago.localImage(
    String? url, {
    /// Size will override width and height
    double? size,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    BorderRadiusGeometry borderRadius = BorderRadius.zero,
    Color? color,
    bool? shrinkOnError,
  }) {
    return Imago(
      (url != null)
          ? (url.startsWith('assets') ? url : 'assets/images/$url.png')
          : null,
      width: size ?? width,
      height: size ?? height,
      fit: fit,
      type: ImageType.localImage,
      borderRadius: borderRadius,
      color: color,
      shrinkOnError: shrinkOnError ?? false,
    );
  }

  /// Factory method that handles remote image with local fallback.
  ///
  /// Automatically shows remote image if available, otherwise shows local fallback.
  /// This is useful for handling cases where network images might fail to load.
  factory Imago.of({
    String? remoteUrl,
    String? localFallback,
    ImageType localFallbackType = ImageType.localImage,
    double? size,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    BorderRadiusGeometry borderRadius = BorderRadius.zero,
    Color? color,
    bool? shrinkOnError,
    bool? shrinkOnLoading,
    WidgetBuilder? placeholderBuilder,
    bool showProgressIndicator = false,
  }) {
    return Imago(
      remoteUrl,
      width: size ?? width,
      height: size ?? height,
      fit: fit,
      type: ImageType.networkImage,
      borderRadius: borderRadius,
      color: color,
      shrinkOnError: shrinkOnError ?? false,
      shrinkOnLoading: shrinkOnLoading ?? false,
      placeholderBuilder: placeholderBuilder ??
          (context) {
            if (localFallback != null) {
              // Handle path resolution based on type
              String? resolvedPath = localFallback;
              if (localFallbackType == ImageType.localSvg &&
                  !localFallback.startsWith('assets')) {
                resolvedPath = 'assets/svg/$localFallback.svg';
              } else if (localFallbackType == ImageType.localImage &&
                  !localFallback.startsWith('assets')) {
                resolvedPath = 'assets/images/$localFallback.png';
              }

              return Imago(
                resolvedPath,
                width: size ?? width,
                height: size ?? height,
                fit: fit,
                type: localFallbackType,
                borderRadius: borderRadius,
                color: color,
                shrinkOnError: shrinkOnError ?? false,
              );
            }
            return Container(
              width: size ?? width,
              height: size ?? height,
              color: Colors.grey.shade200,
              padding: const EdgeInsets.all(16),
              child: const Icon(Icons.image),
            );
          },
      showProgressIndicator: showProgressIndicator,
    );
  }

  /// The URL or path of the image to display.
  final String? url;

  /// How the image should be inscribed into the available space.
  final BoxFit? fit;

  /// The width of the image.
  final double? width;

  /// The height of the image.
  final double? height;

  /// Placeholder image path to show while loading.
  final String? placeholder;

  /// Server size information (currently unused).
  final Size? sizeServer;

  /// Whether the image should be scalable.
  final bool isScale;

  /// Optional builder for customizing the image widget.
  final ImageWidgetBuilder? imageBuilder;

  /// Builder for progress indicator during loading.
  final ProgressIndicatorBuilder? progressIndicatorBuilder;

  /// Builder for error widget when image fails to load.
  final LoadingErrorWidgetBuilder? errorWidget;

  /// Duration for placeholder fade in animation.
  final Duration? placeholderFadeInDuration;

  /// Duration for fade out animation.
  final Duration? fadeOutDuration;

  /// Curve for fade out animation.
  final Curve fadeOutCurve;

  /// Duration for fade in animation.
  final Duration fadeInDuration;

  /// Curve for fade in animation.
  final Curve fadeInCurve;

  /// How to align the image within its bounds.
  final Alignment alignment;

  /// How to paint any portions of the layout bounds not covered by the image.
  final ImageRepeat repeat;

  /// Whether to match the text direction when painting the image.
  final bool matchTextDirection;

  /// Whether to show app bar (currently unused).
  final bool? isShowAppBar;

  /// HTTP headers for network requests.
  final Map<String, String>? httpHeaders;

  /// Whether to use old image when URL changes.
  final bool useOldImageOnUrlChange;

  /// Color to blend with the image.
  final Color? color;

  /// Blend mode for color blending.
  final BlendMode? colorBlendMode;

  /// Quality of the image filter.
  final FilterQuality filterQuality;

  /// Maximum width for memory cache.
  final int? memCacheWidth;

  /// Maximum height for memory cache.
  final int? memCacheHeight;

  /// Maximum width for disk cache.
  final int? maxWidthDiskCache;

  /// Maximum height for disk cache.
  final int? maxHeightDiskCache;

  /// Cache key for the image.
  final String? cacheKey;

  /// Hero tag for hero animations.
  final String? hero;

  /// Type of image to display.
  final ImageType type;

  /// Whether to shrink widget on error.
  final bool shrinkOnError;

  /// Whether to shrink widget while loading.
  final bool shrinkOnLoading;

  /// Custom placeholder builder.
  final WidgetBuilder? placeholderBuilder;

  /// Border radius for the image container.
  final BorderRadiusGeometry borderRadius;

  /// Whether to show progress indicator during loading.
  final bool showProgressIndicator;

  /// Checks if an asset file exists in the bundle.
  ///
  /// This method attempts to load the asset and returns true if it exists,
  /// false otherwise. Note that this is an asynchronous operation.
  static Future<bool> assetExists(String assetPath) async {
    try {
      await DefaultAssetBundle.of(WidgetsBinding.instance.rootElement!)
          .load(assetPath);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Synchronously checks if an asset file exists by attempting to create
  /// an Image.asset widget and catching any errors.
  ///
  /// This is a synchronous alternative to [assetExists] but may not be
  /// as reliable in all cases.
  static bool assetExistsSync(String assetPath) {
    try {
      // This will throw an exception if the asset doesn't exist
      Image.asset(assetPath);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Default placeholder widget when no custom placeholder is provided.
  Widget get _placeholderWidget => ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          width: width,
          height: height,
          color: Colors.grey.shade200,
          child: Icon(
            Icons.image_outlined,
            size: (width != null && height != null)
                ? (width! < height! ? width! * 0.4 : height! * 0.4)
                : 48,
            color: Colors.grey.shade400,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    String imageUrl = url ?? '';

    if (imageUrl.isEmpty) {
      return placeholderBuilder?.call(context) ?? _placeholderWidget;
    }

    if (type == ImageType.localSvg) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: SvgPicture.asset(
          imageUrl,
          fit: fit ?? BoxFit.contain,
          colorFilter: color != null
              ? ColorFilter.mode(color!, colorBlendMode ?? BlendMode.srcIn)
              : null,
          width: width,
          height: height,
          placeholderBuilder: (context) {
            if (shrinkOnError) return const SizedBox.shrink();
            return _placeholderWidget;
          },
        ),
      );
    } else if (type == ImageType.localImage) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: Image.asset(
          imageUrl,
          fit: fit ?? BoxFit.contain,
          width: width,
          filterQuality: filterQuality,
          height: height,
          errorBuilder: (context, error, stackTrace) {
            if (shrinkOnError) return const SizedBox.shrink();
            return _placeholderWidget;
          },
        ),
      );
    } else if (type == ImageType.file) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: Image.file(
          File(imageUrl),
          fit: BoxFit.cover,
          height: height,
          width: width,
          errorBuilder: (context, error, stackTrace) {
            if (shrinkOnError) return const SizedBox.shrink();
            return _placeholderWidget;
          },
        ),
      );
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: height,
        width: width,
        fit: fit,
        placeholder: !showProgressIndicator
            ? (context, url) {
                return shrinkOnLoading
                    ? const SizedBox.shrink()
                    : _placeholderWidget;
              }
            : null,
        errorWidget: errorWidget ??
            (context, url, error) {
              return _placeholderWidget;
            },
        httpHeaders: httpHeaders,
        imageBuilder: imageBuilder,
        progressIndicatorBuilder: showProgressIndicator
            ? (progressIndicatorBuilder ??
                (context, url, downloadProgress) {
                  return Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        value: downloadProgress.progress,
                        strokeWidth: 2.0,
                      ),
                    ),
                  );
                })
            : null,
        fadeOutDuration: fadeOutDuration,
        fadeOutCurve: fadeOutCurve,
        fadeInDuration: fadeInDuration,
        fadeInCurve: fadeInCurve,
        alignment: alignment,
        repeat: repeat,
        matchTextDirection: matchTextDirection,
        useOldImageOnUrlChange: useOldImageOnUrlChange,
        color: color,
        filterQuality: filterQuality,
        colorBlendMode: colorBlendMode,
        placeholderFadeInDuration: placeholderFadeInDuration,
        memCacheWidth: memCacheWidth,
        memCacheHeight: memCacheHeight,
        cacheKey: cacheKey,
        maxWidthDiskCache: maxWidthDiskCache,
        maxHeightDiskCache: maxHeightDiskCache,
      ),
    );
  }
}
