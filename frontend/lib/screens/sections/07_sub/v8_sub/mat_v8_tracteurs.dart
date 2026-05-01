import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/language_provider.dart';
import '../dynamic_generic_table.dart';

class MatV8Tracteurs extends StatelessWidget {
  const MatV8Tracteurs({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isAr = lang.isArabic;

    const List<Map<String, String>> matOptions = [
      {'ar': 'جرار ذو عجلات <= 45 CV', 'fr': 'Tracteur roues <= 45 CV'},
      {'ar': 'جرار ذو عجلات 45-65 CV', 'fr': 'Tracteur roues 45-65 CV'},
      {'ar': 'جرار ذو عجلات > 65 CV', 'fr': 'Tracteur roues > 65 CV'},
      {'ar': 'جرار ذو سلاسل <= 80 CV', 'fr': 'Tracteur chenilles <= 80 CV'},
      {'ar': 'جرار ذو سلاسل > 80 CV', 'fr': 'Tracteur chenilles > 80 CV'},
      {'ar': 'جرار صغير (Motoculteur)', 'fr': 'Motoculteur'},
    ];

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: const Column(
        children: [
          DynamicGenericTable(
            titleAr: 'الجرارات',
            titleFr: 'Tracteurs',
            prefix: 'mt_tr',
            options: matOptions,
            addTextAr: 'إضافة جرار',
            addTextFr: 'Ajouter tracteur',
          ),
        ],
      ),
    );
  }
}
