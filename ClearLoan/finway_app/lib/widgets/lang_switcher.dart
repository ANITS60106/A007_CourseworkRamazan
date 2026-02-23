import 'package:flutter/material.dart';
import '../services/app_settings.dart';
import '../services/i18n.dart';

class LangSwitcher extends StatelessWidget {
  const LangSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppSettings.language,
      builder: (context, lang, _) {
        return SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'ru', label: Text('RU')),
            ButtonSegment(value: 'ky', label: Text('KG')),
            ButtonSegment(value: 'en', label: Text('EN')),
          ],
          selected: {lang},
          showSelectedIcon: false,
          onSelectionChanged: (set) {
            if (set.isEmpty) return;
            AppSettings.language.value = set.first;
          },
          style: ButtonStyle(
            visualDensity: VisualDensity.compact,
            padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
            textStyle: const MaterialStatePropertyAll(TextStyle(fontWeight: FontWeight.w700)),
          ),
        );
      },
    );
  }
}
