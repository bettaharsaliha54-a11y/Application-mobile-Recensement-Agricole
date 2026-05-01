import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/language_provider.dart';
import 'dynamic_crop_table.dart';

class ArbresEparsForm extends StatelessWidget {
  const ArbresEparsForm({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isAr = lang.isArabic;

    const List<Map<String, String>> cropOptions = [
      {'ar': 'أشجار الزيتون', 'fr': 'Oliviers'},
      {'ar': 'أشجار ذات نواة وبدون', 'fr': 'Noyaux-Pépins'},
      {'ar': 'أشجار الرمان', 'fr': 'Grenadiers'},
      {'ar': 'أشجار السفرجل', 'fr': 'Cognassiers'},
      {'ar': 'أشجار الخروب', 'fr': 'Caroubier'},
      {'ar': 'أشجار أخرى', 'fr': 'Autres'},
    ];

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DynamicCropTable(
            titleAr: 'الأشجار المتفرقة',
            titleFr: 'Arbres épars',
            prefix: 'ep',
            options: cropOptions,
            hasIrrigated: false,
            hasIntercalary: false,
          ),
        ],
      ),
    );
  }
}
