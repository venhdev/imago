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
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.opacity,
    this.centerSlice,
    this.gaplessPlayback = false,
    this.isAntiAlias = false,
    this.cacheWidth,
    this.cacheHeight,
    this.scale = 1.0,
    this.clipBehavior = Clip.antiAlias,
    this.clipper,
    this.bundle,
    this.package,
    this.allowDrawingOutsideViewBox = false,
    this.theme,
    this.colorMapper,
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
    bool? shrinkOnLoading,
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
      shrinkOnLoading: shrinkOnLoading ?? false,
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
    bool? shrinkOnLoading,
  }) {
    return Imago(
      url,
      width: size ?? width,
      height: size ?? height,
      fit: fit,
      type: ImageType.file,
      borderRadius: borderRadius,
      shrinkOnError: shrinkOnError ?? false,
      shrinkOnLoading: shrinkOnLoading ?? false,
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
    bool? shrinkOnLoading,
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
      shrinkOnLoading: shrinkOnLoading ?? false,
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

  /// Semantic label for accessibility.
  final String? semanticLabel;

  /// Whether to exclude this image from semantics.
  final bool excludeFromSemantics;

  /// Opacity animation for the image.
  final Animation<double>? opacity;

  /// Center slice for nine-patch images.
  final Rect? centerSlice;

  /// Whether to use gapless playback for animated images.
  final bool gaplessPlayback;

  /// Whether to use anti-aliasing.
  final bool isAntiAlias;

  /// Cache width for the image.
  final int? cacheWidth;

  /// Cache height for the image.
  final int? cacheHeight;

  /// Scale factor for the image.
  final double scale;

  /// Clip behavior for the container.
  final Clip clipBehavior;

  /// Custom clipper for the container.
  final CustomClipper<RRect>? clipper;

  /// Asset bundle to load assets from.
  final AssetBundle? bundle;

  /// Package name for assets.
  final String? package;

  /// Whether to allow drawing outside view box for SVG.
  final bool allowDrawingOutsideViewBox;

  /// SVG theme for styling.
  final SvgTheme? theme;

  /// Color mapper for SVG.
  final ColorMapper? colorMapper;

  /// Default placeholder widget when no custom placeholder is provided.
  Widget get _placeholderWidget => ClipRRect(
        borderRadius: borderRadius,
        clipper: clipper,
        clipBehavior: clipBehavior,
        child: Container(
          width: width,
          height: height,
          color: Colors.grey.shade200,
          alignment: Alignment.center,
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
        clipper: clipper,
        clipBehavior: clipBehavior,
        child: SvgPicture.asset(
          imageUrl,
          fit: fit ?? BoxFit.contain,
          colorFilter: color != null
              ? ColorFilter.mode(color!, colorBlendMode ?? BlendMode.srcIn)
              : null,
          width: width,
          height: height,
          bundle: bundle,
          package: package,
          matchTextDirection: matchTextDirection,
          allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
          placeholderBuilder: (context) {
            if (shrinkOnError) return const SizedBox.shrink();
            return _placeholderWidget;
          },
          semanticsLabel: semanticLabel,
          excludeFromSemantics: excludeFromSemantics,
          clipBehavior: clipBehavior,
          theme: theme,
          colorMapper: colorMapper,
        ),
      );
    } else if (type == ImageType.localImage) {
      return ClipRRect(
        borderRadius: borderRadius,
        clipper: clipper,
        clipBehavior: clipBehavior,
        child: Image.asset(
          imageUrl,
          fit: fit ?? BoxFit.contain,
          width: width,
          filterQuality: filterQuality,
          height: height,
          scale: scale,
          bundle: bundle,
          package: package,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (opacity != null) {
              return FadeTransition(
                opacity: opacity!,
                child: child,
              );
            }
            return child;
          },
          errorBuilder: (context, error, stackTrace) {
            if (shrinkOnError) return const SizedBox.shrink();
            return _placeholderWidget;
          },
          semanticLabel: semanticLabel,
          excludeFromSemantics: excludeFromSemantics,
          color: color,
          colorBlendMode: colorBlendMode,
          alignment: alignment,
          repeat: repeat,
          centerSlice: centerSlice,
          matchTextDirection: matchTextDirection,
          gaplessPlayback: gaplessPlayback,
          isAntiAlias: isAntiAlias,
          cacheWidth: cacheWidth,
          cacheHeight: cacheHeight,
        ),
      );
    } else if (type == ImageType.file) {
      return ClipRRect(
        borderRadius: borderRadius,
        clipper: clipper,
        clipBehavior: clipBehavior,
        child: Image.file(
          File(imageUrl),
          fit: fit ?? BoxFit.cover,
          height: height,
          width: width,
          scale: scale,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (opacity != null) {
              return FadeTransition(
                opacity: opacity!,
                child: child,
              );
            }
            return child;
          },
          errorBuilder: (context, error, stackTrace) {
            if (shrinkOnError) return const SizedBox.shrink();
            return _placeholderWidget;
          },
          semanticLabel: semanticLabel,
          excludeFromSemantics: excludeFromSemantics,
          color: color,
          colorBlendMode: colorBlendMode,
          alignment: alignment,
          repeat: repeat,
          centerSlice: centerSlice,
          matchTextDirection: matchTextDirection,
          gaplessPlayback: gaplessPlayback,
          isAntiAlias: isAntiAlias,
          filterQuality: filterQuality,
          cacheWidth: cacheWidth,
          cacheHeight: cacheHeight,
        ),
      );
    }

    return ClipRRect(
      borderRadius: borderRadius,
      clipper: clipper,
      clipBehavior: clipBehavior,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: height,
        width: width,
        fit: fit,
        scale: scale,
        placeholder: !showProgressIndicator
            ? (context, url) {
                return shrinkOnLoading
                    ? const SizedBox.shrink()
                    : _placeholderWidget;
              }
            : null,
        errorWidget: errorWidget ??
            (context, url, error) {
              return shrinkOnError
                  ? const SizedBox.shrink()
                  : _placeholderWidget;
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
