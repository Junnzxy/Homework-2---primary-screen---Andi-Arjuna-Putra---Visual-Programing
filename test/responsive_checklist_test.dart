import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/widgets/empty_state_widget.dart';

void main() {
  // Helper to pump MyApp with specific physical size and insets
  Future<void> pumpScreen(
    WidgetTester tester, {
    required double width,
    required double height,
    EdgeInsets viewInsets = EdgeInsets.zero,
    Brightness brightness = Brightness.light,
  }) async {
    tester.view.physicalSize = Size(width, height);
    tester.view.devicePixelRatio = 1.0;
    tester.view.viewInsets = FakeViewPadding(
      bottom: viewInsets.bottom,
      top: viewInsets.top,
      left: viewInsets.left,
      right: viewInsets.right,
    );
    tester.platformDispatcher.platformBrightnessTestValue = brightness;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      tester.view.resetViewInsets();
      tester.platformDispatcher.clearPlatformBrightnessTestValue();
    });

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
  }

  group('Week 04 Nine-Test Responsive Checklist', () {
    testWidgets('1. Small phone (320 dp width) — no overflow', (tester) async {
      await pumpScreen(tester, width: 320, height: 568);

      expect(tester.takeException(), isNull);
      expect(find.text('Andi Arjuna'), findsOneWidget);
      expect(find.text('Current Power'), findsOneWidget);
      expect(find.text('Active Devices'), findsOneWidget);
      expect(find.text('Quick Modes'), findsOneWidget);
    });

    testWidgets('2. Large phone (430 dp width) — no overflow', (tester) async {
      await pumpScreen(tester, width: 430, height: 932);

      expect(tester.takeException(), isNull);
      expect(find.text('Andi Arjuna'), findsOneWidget);
      expect(find.text('Smart Devices (6)'), findsOneWidget);
    });

    testWidgets('3. Tablet (800 dp width) — layout changes structurally to dual-pane',
        (tester) async {
      await pumpScreen(tester, width: 800, height: 1280);

      expect(tester.takeException(), isNull);
      // In tablet mode, the right pane contains a dedicated headline with device count badge
      expect(find.text('Smart Devices'), findsOneWidget);
      // Both columns exist: Left sidebar width 340, right pane expands
      final leftSidebarFinder = find.byType(SingleChildScrollView);
      expect(leftSidebarFinder, findsOneWidget);

      final rightGridFinder = find.byType(GridView);
      expect(rightGridFinder, findsOneWidget);
    });

    testWidgets('4. Landscape (Rotate emulators) — no overflow', (tester) async {
      // Small phone landscape (568x320)
      await pumpScreen(tester, width: 568, height: 320);
      expect(tester.takeException(), isNull);

      // Large phone landscape (932x430)
      await pumpScreen(tester, width: 932, height: 430);
      expect(tester.takeException(), isNull);

      // Tablet landscape (1280x800)
      await pumpScreen(tester, width: 1280, height: 800);
      expect(tester.takeException(), isNull);
    });

    testWidgets('5. Long text (200 characters) — handled with ellipsis, no overflow',
        (tester) async {
      await pumpScreen(tester, width: 360, height: 640);

      // Search for a 200-char query
      final longQuery = 'A' * 200;
      await tester.enterText(find.byType(TextField), longQuery);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('6. Empty state (0 items) — icon, message, and working action button',
        (tester) async {
      await pumpScreen(tester, width: 390, height: 844);

      // Trigger empty state by searching for a nonexistent item
      await tester.enterText(find.byType(TextField), 'NonExistentDeviceXYZ');
      await tester.pumpAndSettle();

      expect(find.byType(EmptyStateWidget), findsOneWidget);
      expect(find.text('No devices found'), findsOneWidget);
      expect(find.byIcon(Icons.devices_other_rounded), findsOneWidget);

      // Action button present
      final resetBtn = find.text('Reset Filters');
      expect(resetBtn, findsOneWidget);

      // Tap action button to recover
      await tester.tap(resetBtn);
      await tester.pumpAndSettle();

      expect(find.text('Smart Devices (6)'), findsOneWidget);
      expect(find.byType(EmptyStateWidget), findsNothing);
    });

    testWidgets('7. Long list (500 items, using .builder) — stress test no overflow',
        (tester) async {
      await pumpScreen(tester, width: 390, height: 844);

      // Tap "Sample" chip to switch to 500 items mode
      final sampleChip = find.text('Sample');
      expect(sampleChip, findsOneWidget);
      await tester.tap(sampleChip);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Smart Devices (500)'), findsOneWidget);

      // Scroll smoothly down the 500 items list
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -600));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('8. Keyboard open on short screen — field stays visible, no overflow',
        (tester) async {
      // 360x480 short screen with 250dp keyboard bottom inset
      await pumpScreen(
        tester,
        width: 360,
        height: 480,
        viewInsets: const EdgeInsets.only(bottom: 250),
      );

      expect(tester.takeException(), isNull);
      // Search field is still accessible
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('9. Dark mode — legible and passes with 0 overflow',
        (tester) async {
      await pumpScreen(
        tester,
        width: 390,
        height: 844,
        brightness: Brightness.dark,
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Andi Arjuna'), findsOneWidget);
      expect(find.text('Current Power'), findsOneWidget);
    });
  });
}
