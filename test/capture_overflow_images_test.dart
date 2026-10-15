import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    Directory('docs/week04').createSync(recursive: true);
  });

  testWidgets('Capture Error 1: Horizontal RenderFlex Overflow', (tester) async {
    FlutterError.onError = (details) {};
    final key = GlobalKey();

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: RepaintBoundary(
              key: key,
              child: Container(
                width: 340,
                height: 120,
                color: Colors.white,
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Error 1: Horizontal RenderFlex Overflow',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const CircleAvatar(radius: 16, child: Icon(Icons.ac_unit, size: 16)),
                        const SizedBox(width: 8),
                        Text(
                          'Super Long Living Room Climate Master Control Unit ' * 3,
                          style: const TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        Switch(value: true, onChanged: (_) {}),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    await tester.runAsync(() async {
      final boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage();
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      File('docs/week04/overflow-1.png').writeAsBytesSync(byteData!.buffer.asUint8List());
    });
  });

  testWidgets('Capture Error 2: Vertical RenderFlex Overflow on Short Viewport', (tester) async {
    FlutterError.onError = (details) {};
    final key = GlobalKey();

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: RepaintBoundary(
              key: key,
              child: Container(
                width: 320,
                height: 180, // Constrained height
                color: Colors.white,
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Error 2: Vertical RenderFlex Overflow',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
                    const SizedBox(height: 8),
                    Container(height: 50, color: Colors.green.shade100, child: const Center(child: Text('Power Metric Card'))),
                    const SizedBox(height: 8),
                    Container(height: 50, color: Colors.blue.shade100, child: const Center(child: Text('Active Devices Card'))),
                    const SizedBox(height: 8),
                    Container(height: 50, color: Colors.orange.shade100, child: const Center(child: Text('Quick Mode Selector'))),
                    const SizedBox(height: 8),
                    Container(height: 50, color: Colors.purple.shade100, child: const Center(child: Text('Room Category Tabs'))),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    await tester.runAsync(() async {
      final boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage();
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      File('docs/week04/overflow-2.png').writeAsBytesSync(byteData!.buffer.asUint8List());
    });
  });

  testWidgets('Capture Error 3: Unbounded Viewport Exception Banner', (tester) async {
    FlutterError.onError = (details) {};
    final key = GlobalKey();

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: RepaintBoundary(
              key: key,
              child: Container(
                width: 340,
                height: 180,
                color: const Color(0xFF2B0B0B),
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.error_outline, color: Colors.redAccent, size: 24),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Error 3: Unbounded Height Viewport',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Vertical viewport was given unbounded height.\n'
                      'A ListView/GridView was placed directly inside a Column without Expanded or height bounds.',
                      style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.4),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 10,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Colors.yellow,
                            Colors.black,
                            Colors.yellow,
                            Colors.black,
                            Colors.yellow,
                            Colors.black,
                            Colors.yellow,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    await tester.runAsync(() async {
      final boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage();
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      File('docs/week04/overflow-3.png').writeAsBytesSync(byteData!.buffer.asUint8List());
    });
  });
}
