import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/language_provider.dart';
import 'dynamic_crop_table.dart';

class GrandesCulturesForm extends StatelessWidget {
  const GrandesCulturesForm({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isAr = lang.isArabic;

    const List<Map<String, String>> cropOptions = [
      {'ar': 'قمح صلب', 'fr': 'Blé dur'},
      {'ar': 'قمح لين', 'fr': 'Blé tendre'},
      {'ar': 'شعير', 'fr': 'Orge'},
      {'ar': 'خرطال', 'fr': 'Avoine'},
      {'ar': 'ذرة رفيعة', 'fr': 'Sorgho'},
      {'ar': 'ذرة حبوب', 'fr': 'Maïs grain'},
      {'ar': 'حبوب أخرى', 'fr': 'Autres céréales'},
    ];

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: const SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DynamicCropTable(
              titleAr: 'المحاصيل الكبرى',
              titleFr: 'Grandes cultures',
              prefix: 'gc',
              options: cropOptions,
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
