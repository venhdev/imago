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

  group('Asset Existence Checking', () {
    test('assetExistsSync should return false for non-existent asset', () {
      const nonExistentAsset = 'assets/non_existent.png';
      expect(Imago.assetExistsSync(nonExistentAsset), isFalse);
    });

    test('assetExists should return false for non-existent asset', () async {
      const nonExistentAsset = 'assets/non_existent.png';
      final exists = await Imago.assetExists(nonExistentAsset);
      expect(exists, isFalse);
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
}
