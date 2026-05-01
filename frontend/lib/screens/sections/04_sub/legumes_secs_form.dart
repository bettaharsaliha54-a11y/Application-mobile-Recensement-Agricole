import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/language_provider.dart';
import 'dynamic_crop_table.dart';

class LegumesSecsForm extends StatelessWidget {
  const LegumesSecsForm({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isAr = lang.isArabic;

    const List<Map<String, String>> cropOptions = [
      {'ar': 'عدس', 'fr': 'Lentilles'},
      {'ar': 'حمص', 'fr': 'Pois-chiche'},
      {'ar': 'بازلاء جافة', 'fr': 'Pois sec'},
      {'ar': 'فول جاف', 'fr': 'Fève sèche'},
      {'ar': 'حلبة', 'fr': 'Fenugrec'},
      {'ar': 'بقول جافة أخرى', 'fr': 'Autres'},
    ];

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: const SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DynamicCropTable(
              titleAr: 'البقول الجافة',
              titleFr: 'Légumes secs',
              prefix: 'ls',
              options: cropOptions,
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
