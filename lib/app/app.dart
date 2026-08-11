import 'package:deepwidget/core/theme/deep_widget_theme.dart';
import 'package:deepwidget/core/widgets/deep_glass_surface.dart';
import 'package:deepwidget/features/widget_creator/presentation/widget_editor_page.dart';
import 'package:flutter/material.dart';

class DeepWidgetApp extends StatelessWidget {
  const DeepWidgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deep Widget',
      debugShowCheckedModeBanner: false,
      theme: DeepWidgetTheme.dark(),
      darkTheme: DeepWidgetTheme.dark(),
      themeMode: ThemeMode.dark,
      builder: (BuildContext context, Widget? child) {
        return DeepBackdropBlurWarmUp(child: child ?? const SizedBox.shrink());
      },
      home: const WidgetEditorPage(),
    );
  }
}
