import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/language_provider.dart';
import 'dynamic_crop_table.dart';

class FourragesForm extends StatelessWidget {
  const FourragesForm({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isAr = lang.isArabic;

    const List<Map<String, String>> cropOptions = [
      {'ar': 'فصة و برسيم', 'fr': 'Vesce et Vesce-avoine'},
      {'ar': 'ذرة علفية', 'fr': 'Maïs fourrage'},
      {'ar': 'أعلاف أخرى', 'fr': 'Autres fourrages'},
    ];

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: const SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DynamicCropTable(
              titleAr: 'الأعلاف',
              titleFr: 'Fourrages',
              prefix: 'fo',
              options: cropOptions,
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
