import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/config/app_theme.dart';
import 'src/features/polygon/presentation/screens/polygonal_draft.dart';

Future<ui.Image> getPointerImage() async {
  final ByteData data = await rootBundle.load('assets/pointer.png');
  final Uint8List bytes = data.buffer.asUint8List();
  final ui.Codec codec = await ui.instantiateImageCodec(bytes);
  final ui.FrameInfo frameInfo = await codec.getNextFrame();
  return frameInfo.image;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ui.Image pointer = await getPointerImage();
  runApp(
    ProviderScope(
      child: MyApp(pointer),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp(this.pointer, {super.key});
  final ui.Image pointer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Polygonal Draft',
        theme: CustomTheme().theme(),
        home: PolygonalDraft(pointer));
  }
}
