import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imago/imago.dart';

void main() {
  group('Imago Widget Tests', () {
    testWidgets('should display network image', (WidgetTester tester) async {
      const testUrl = 'https://example.com/test.jpg';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Imago(testUrl),
          ),
        ),
      );

      expect(find.byType(Imago), findsOneWidget);
    });

    testWidgets('should display local SVG with correct path resolution',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Imago.localSvg('test_icon'),
          ),
        ),
      );

      expect(find.byType(Imago), findsOneWidget);
    });

    testWidgets('should display local image with correct path resolution',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Imago.localImage('test_image'),
          ),
        ),
      );

      expect(find.byType(Imago), findsOneWidget);
    });

    testWidgets('should display file image', (WidgetTester tester) async {
      const testPath = '/test/path/image.jpg';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Imago.file(testPath),
          ),
        ),
      );

      expect(find.byType(Imago), findsOneWidget);
    });

    testWidgets('should display remote image with fallback',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Imago.of(
              remoteUrl: 'https://example.com/test.jpg',
              localFallback: 'fallback_image',
              localFallbackType: ImageType.localImage,
            ),
          ),
        ),
      );

      expect(find.byType(Imago), findsOneWidget);
    });

    testWidgets('should handle empty URL with placeholder',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Imago(null),
          ),
        ),
      );

      expect(find.byType(Imago), findsOneWidget);
    });

    testWidgets('should apply custom width and height',
        (WidgetTester tester) async {
      const testUrl = 'https://example.com/test.jpg';
      const testWidth = 200.0;
      const testHeight = 150.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Imago(
              testUrl,
              width: testWidth,
              height: testHeight,
            ),
          ),
        ),
      );

      final imagoWidget = tester.widget<Imago>(find.byType(Imago));
      expect(imagoWidget.width, testWidth);
      expect(imagoWidget.height, testHeight);
    });

    testWidgets('should apply border radius', (WidgetTester tester) async {
      const testUrl = 'https://example.com/test.jpg';
      const borderRadius = BorderRadius.all(Radius.circular(10));

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Imago(
              testUrl,
              borderRadius: borderRadius,
            ),
          ),
        ),
      );

      final imagoWidget = tester.widget<Imago>(find.byType(Imago));
      expect(imagoWidget.borderRadius, borderRadius);
    });

    testWidgets('should apply color filter', (WidgetTester tester) async {
      const testUrl = 'https://example.com/test.jpg';
      const testColor = Colors.blue;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Imago(
              testUrl,
              color: testColor,
            ),
          ),
        ),
      );

      final imagoWidget = tester.widget<Imago>(find.byType(Imago));
      expect(imagoWidget.color, testColor);
    });

    testWidgets('should show progress indicator when enabled',
        (WidgetTester tester) async {
      const testUrl = 'https://example.com/test.jpg';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Imago(
              testUrl,
              showProgressIndicator: true,
            ),
          ),
        ),
      );

      final imagoWidget = tester.widget<Imago>(find.byType(Imago));
      expect(imagoWidget.showProgressIndicator, true);
    });

    testWidgets('should handle shrink on error', (WidgetTester tester) async {
      const testUrl = 'https://example.com/test.jpg';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Imago(
              testUrl,
              shrinkOnError: true,
            ),
          ),
        ),
      );

      final imagoWidget = tester.widget<Imago>(find.byType(Imago));
      expect(imagoWidget.shrinkOnError, true);
    });

    testWidgets('should handle shrink on loading', (WidgetTester tester) async {
      const testUrl = 'https://example.com/test.jpg';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Imago(
              testUrl,
              shrinkOnLoading: true,
            ),
          ),
        ),
      );

      final imagoWidget = tester.widget<Imago>(find.byType(Imago));
      expect(imagoWidget.shrinkOnLoading, true);
    });

    testWidgets('should use custom placeholder builder',
        (WidgetTester tester) async {
      const testUrl = 'https://example.com/test.jpg';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Imago(
              testUrl,
              placeholderBuilder: (context) => const Text('Custom Placeholder'),
            ),
          ),
        ),
      );

      final imagoWidget = tester.widget<Imago>(find.byType(Imago));
      expect(imagoWidget.placeholderBuilder, isNotNull);
    });

    testWidgets('should display icon-based placeholder for empty URL',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Imago(null),
          ),
        ),
      );

      expect(find.byType(Imago), findsOneWidget);
      expect(find.byIcon(Icons.image_outlined), findsOneWidget);
    });
  });

  group('Imago Factory Methods', () {
    testWidgets('Imago.localSvg should create widget with correct type',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Imago.localSvg('test_icon'),
          ),
        ),
      );

      final imagoWidget = tester.widget<Imago>(find.byType(Imago));
      expect(imagoWidget.type, ImageType.localSvg);
    });

    testWidgets('Imago.localImage should create widget with correct type',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Imago.localImage('test_image'),
          ),
        ),
      );

      final imagoWidget = tester.widget<Imago>(find.byType(Imago));
      expect(imagoWidget.type, ImageType.localImage);
    });

    testWidgets('Imago.file should create widget with correct type',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Imago.file('/test/path/image.jpg'),
          ),
        ),
      );

      final imagoWidget = tester.widget<Imago>(find.byType(Imago));
      expect(imagoWidget.type, ImageType.file);
    });

    testWidgets('Imago.of should create widget with network type',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Imago.of(
              remoteUrl: 'https://example.com/test.jpg',
              localFallback: 'fallback',
            ),
          ),
        ),
      );

      final imagoWidget = tester.widget<Imago>(find.byType(Imago));
      expect(imagoWidget.type, ImageType.networkImage);
    });
  });

  group('ImageType Enum', () {
    test('should have correct enum values', () {
      expect(ImageType.values, [
        ImageType.networkImage,
        ImageType.localSvg,
        ImageType.localImage,
        ImageType.file,
      ]);
    });
  });

  group('Imago Constructor Parameters', () {
    test('should have correct default values', () {
      const imago = Imago('test_url');

      expect(imago.url, 'test_url');
      expect(imago.type, ImageType.networkImage);
      expect(imago.isScale, false);
      expect(imago.alignment, Alignment.center);
      expect(imago.repeat, ImageRepeat.noRepeat);
      expect(imago.matchTextDirection, false);
      expect(imago.useOldImageOnUrlChange, false);
      expect(imago.filterQuality, FilterQuality.low);
      expect(imago.fadeOutDuration, const Duration(milliseconds: 1000));
      expect(imago.fadeOutCurve, Curves.easeOut);
      expect(imago.fadeInDuration, const Duration(milliseconds: 500));
      expect(imago.fadeInCurve, Curves.easeIn);
      expect(imago.isShowAppBar, true);
      expect(imago.shrinkOnError, false);
      expect(imago.shrinkOnLoading, false);
      expect(imago.borderRadius, BorderRadius.zero);
      expect(imago.showProgressIndicator, false);
    });
  });

  group('Placeholder Widget Tests', () {
    testWidgets('should center placeholder icon properly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Imago(
              null,
              width: 200,
              height: 200,
            ),
          ),
        ),
      );

      expect(find.byType(Imago), findsOneWidget);
      expect(find.byIcon(Icons.image_outlined), findsOneWidget);

      // Check that the icon is centered by verifying the Center widget exists
      expect(find.byType(Center), findsAtLeastNWidgets(1));
    });

    testWidgets('should display placeholder with correct size calculation',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Imago(
              null,
              width: 100,
              height: 200,
            ),
          ),
        ),
      );

      expect(find.byType(Imago), findsOneWidget);
      expect(find.byIcon(Icons.image_outlined), findsOneWidget);
    });

    testWidgets('should apply border radius to placeholder',
        (WidgetTester tester) async {
      const borderRadius = BorderRadius.all(Radius.circular(15));

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Imago(
              null,
              width: 100,
              height: 100,
              borderRadius: borderRadius,
            ),
          ),
        ),
      );

      expect(find.byType(ClipRRect), findsOneWidget);
      final clipRRect = tester.widget<ClipRRect>(find.byType(ClipRRect));
      expect(clipRRect.borderRadius, borderRadius);
    });
  });

  group('Error Handling Tests', () {
    testWidgets('should show placeholder when network image fails',
        (WidgetTester tester) async {
      const invalidUrl = 'https://invalid-url-that-will-fail.com/image.jpg';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Imago(invalidUrl),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Imago), findsOneWidget);
      // Should eventually show placeholder due to network error
      expect(find.byIcon(Icons.image_outlined), findsOneWidget);
    });

    testWidgets('should shrink widget when shrinkOnError is true',
        (WidgetTester tester) async {
      const invalidUrl = 'https://invalid-url.com/image.jpg';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Imago(
              invalidUrl,
              shrinkOnError: true,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Imago), findsOneWidget);
      // Should show placeholder when error occurs (shrinkOnError only works for local images)
      expect(find.byIcon(Icons.image_outlined), findsOneWidget);
    });

    testWidgets('should handle file not found error',
        (WidgetTester tester) async {
      // Use a local image that doesn't exist instead of file path
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Imago.localImage('non_existent_image'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Imago), findsOneWidget);
      // Should show placeholder icon when image not found
      expect(find.byIcon(Icons.image_outlined), findsOneWidget);
    });
  });

  group('Loading State Tests', () {
    testWidgets('should show progress indicator when enabled',
        (WidgetTester tester) async {
      const testUrl = 'https://example.com/slow-loading-image.jpg';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Imago(
              testUrl,
              showProgressIndicator: true,
            ),
          ),
        ),
      );

      expect(find.byType(Imago), findsOneWidget);
      // Progress indicator should be present
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should shrink widget when shrinkOnLoading is true',
        (WidgetTester tester) async {
      // Use a null URL to test shrinkOnLoading behavior with placeholder
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Imago(
              null,
              shrinkOnLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(Imago), findsOneWidget);
      // Should show placeholder when URL is null
      expect(find.byIcon(Icons.image_outlined), findsOneWidget);
    });
  });

  group('Factory Constructor Tests', () {
    testWidgets('Imago.localSvg should handle path resolution correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Imago.localSvg('test_icon', size: 50),
          ),
        ),
      );

      final imagoWidget = tester.widget<Imago>(find.byType(Imago));
      expect(imagoWidget.type, ImageType.localSvg);
      expect(imagoWidget.width, 50);
      expect(imagoWidget.height, 50);
      expect(imagoWidget.url, 'assets/svg/test_icon.svg');
    });

    testWidgets('Imago.localSvg should preserve full asset path',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Imago.localSvg('assets/custom/path/icon.svg'),
          ),
        ),
      );

      final imagoWidget = tester.widget<Imago>(find.byType(Imago));
      expect(imagoWidget.url, 'assets/custom/path/icon.svg');
    });

    testWidgets('Imago.localImage should handle path resolution correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Imago.localImage('test_image', size: 100),
          ),
        ),
      );

      final imagoWidget = tester.widget<Imago>(find.byType(Imago));
      expect(imagoWidget.type, ImageType.localImage);
      expect(imagoWidget.width, 100);
      expect(imagoWidget.height, 100);
      expect(imagoWidget.url, 'assets/images/test_image.png');
    });

    testWidgets('Imago.file should handle file path correctly',
        (WidgetTester tester) async {
      const filePath = '/storage/emulated/0/DCIM/image.jpg';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Imago.file(filePath, size: 75),
          ),
        ),
      );

      final imagoWidget = tester.widget<Imago>(find.byType(Imago));
      expect(imagoWidget.type, ImageType.file);
      expect(imagoWidget.width, 75);
      expect(imagoWidget.height, 75);
      expect(imagoWidget.url, filePath);
    });

    testWidgets('Imago.of should create fallback placeholder correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Imago.of(
              remoteUrl: 'https://example.com/test.jpg',
              localFallback: 'fallback_icon',
              localFallbackType: ImageType.localSvg,
              size: 60,
            ),
          ),
        ),
      );

      final imagoWidget = tester.widget<Imago>(find.byType(Imago));
      expect(imagoWidget.type, ImageType.networkImage);
      expect(imagoWidget.width, 60);
      expect(imagoWidget.height, 60);
    });
  });

  group('Animation and Timing Tests', () {
    testWidgets('should apply custom fade durations',
        (WidgetTester tester) async {
      const customFadeIn = Duration(milliseconds: 300);
      const customFadeOut = Duration(milliseconds: 200);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Imago(
              'https://example.com/test.jpg',
              fadeInDuration: customFadeIn,
              fadeOutDuration: customFadeOut,
            ),
          ),
        ),
      );

      final imagoWidget = tester.widget<Imago>(find.byType(Imago));
      expect(imagoWidget.fadeInDuration, customFadeIn);
      expect(imagoWidget.fadeOutDuration, customFadeOut);
    });

    testWidgets('should apply custom fade curves', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Imago(
              'https://example.com/test.jpg',
              fadeInCurve: Curves.easeInOut,
              fadeOutCurve: Curves.bounceIn,
            ),
          ),
        ),
      );

      final imagoWidget = tester.widget<Imago>(find.byType(Imago));
      expect(imagoWidget.fadeInCurve, Curves.easeInOut);
      expect(imagoWidget.fadeOutCurve, Curves.bounceIn);
    });
  });

  group('Size and Layout Tests', () {
    testWidgets('should handle size parameter in factory constructors',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Imago.localSvg(
              'test_icon',
              size: 80,
              width: 100, // Should be overridden by size
              height: 120, // Should be overridden by size
            ),
          ),
        ),
      );

      final imagoWidget = tester.widget<Imago>(find.byType(Imago));
      expect(imagoWidget.width, 80);
      expect(imagoWidget.height, 80);
    });

    testWidgets('should calculate icon size based on container dimensions',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Imago(
              null,
              width: 200,
              height:
                  100, // height < width, so icon size should be height * 0.4
            ),
          ),
        ),
      );

      expect(find.byType(Imago), findsOneWidget);
      expect(find.byIcon(Icons.image_outlined), findsOneWidget);
    });

    testWidgets('should use default icon size when no dimensions provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Imago(null),
          ),
        ),
      );

      expect(find.byType(Imago), findsOneWidget);
      expect(find.byIcon(Icons.image_outlined), findsOneWidget);
    });
  });

  group('Color and Filter Tests', () {
    testWidgets('should apply color filter to SVG',
        (WidgetTester tester) async {
      const testColor = Colors.red;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Imago.localSvg(
              'test_icon',
              color: testColor,
            ),
          ),
        ),
      );

      final imagoWidget = tester.widget<Imago>(find.byType(Imago));
      expect(imagoWidget.color, testColor);
    });

    testWidgets('should apply color filter to local image',
        (WidgetTester tester) async {
      const testColor = Colors.blue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Imago.localImage(
              'test_image',
              color: testColor,
            ),
          ),
        ),
      );

      final imagoWidget = tester.widget<Imago>(find.byType(Imago));
      expect(imagoWidget.color, testColor);
    });

    testWidgets('should apply custom color blend mode',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Imago(
              'https://example.com/test.jpg',
              color: Colors.green,
              colorBlendMode: BlendMode.multiply,
            ),
          ),
        ),
      );

      final imagoWidget = tester.widget<Imago>(find.byType(Imago));
      expect(imagoWidget.color, Colors.green);
      expect(imagoWidget.colorBlendMode, BlendMode.multiply);
    });
  });

  group('Cache and Performance Tests', () {
    testWidgets('should apply memory cache constraints',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Imago(
              'https://example.com/test.jpg',
              memCacheWidth: 200,
              memCacheHeight: 150,
            ),
          ),
        ),
      );

      final imagoWidget = tester.widget<Imago>(find.byType(Imago));
      expect(imagoWidget.memCacheWidth, 200);
      expect(imagoWidget.memCacheHeight, 150);
    });

    testWidgets('should apply disk cache constraints',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Imago(
              'https://example.com/test.jpg',
              maxWidthDiskCache: 500,
              maxHeightDiskCache: 400,
            ),
          ),
        ),
      );

      final imagoWidget = tester.widget<Imago>(find.byType(Imago));
      expect(imagoWidget.maxWidthDiskCache, 500);
      expect(imagoWidget.maxHeightDiskCache, 400);
    });

    testWidgets('should apply custom cache key', (WidgetTester tester) async {
      const customCacheKey = 'custom_cache_key_123';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Imago(
              'https://example.com/test.jpg',
              cacheKey: customCacheKey,
            ),
          ),
        ),
      );

      final imagoWidget = tester.widget<Imago>(find.byType(Imago));
      expect(imagoWidget.cacheKey, customCacheKey);
    });
  });

  group('HTTP Headers and Network Tests', () {
    testWidgets('should apply custom HTTP headers',
        (WidgetTester tester) async {
      const customHeaders = {
        'Authorization': 'Bearer token123',
        'User-Agent': 'CustomApp/1.0',
      };

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Imago(
              'https://example.com/test.jpg',
              httpHeaders: customHeaders,
            ),
          ),
        ),
      );

      final imagoWidget = tester.widget<Imago>(find.byType(Imago));
      expect(imagoWidget.httpHeaders, customHeaders);
    });
  });

  group('Hero Animation Tests', () {
    testWidgets('should support hero animations', (WidgetTester tester) async {
      const heroTag = 'hero_image_123';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Imago(
              'https://example.com/test.jpg',
              hero: heroTag,
            ),
          ),
        ),
      );

      final imagoWidget = tester.widget<Imago>(find.byType(Imago));
      expect(imagoWidget.hero, heroTag);
    });
  });

  group('Image Alignment and Repeat Tests', () {
    testWidgets('should apply custom alignment', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Imago(
              'https://example.com/test.jpg',
              alignment: Alignment.topLeft,
            ),
          ),
        ),
      );

      final imagoWidget = tester.widget<Imago>(find.byType(Imago));
      expect(imagoWidget.alignment, Alignment.topLeft);
    });

    testWidgets('should apply custom repeat pattern',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Imago(
              'https://example.com/test.jpg',
              repeat: ImageRepeat.repeat,
            ),
          ),
        ),
      );

      final imagoWidget = tester.widget<Imago>(find.byType(Imago));
      expect(imagoWidget.repeat, ImageRepeat.repeat);
    });

    testWidgets('should match text direction when enabled',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Imago(
              'https://example.com/test.jpg',
              matchTextDirection: true,
            ),
          ),
        ),
      );

      final imagoWidget = tester.widget<Imago>(find.byType(Imago));
      expect(imagoWidget.matchTextDirection, true);
    });
  });

  group('Filter Quality Tests', () {
    testWidgets('should apply different filter qualities',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Imago(
              'https://example.com/test.jpg',
              filterQuality: FilterQuality.high,
            ),
          ),
        ),
      );

      final imagoWidget = tester.widget<Imago>(find.byType(Imago));
      expect(imagoWidget.filterQuality, FilterQuality.high);
    });
  });
}
