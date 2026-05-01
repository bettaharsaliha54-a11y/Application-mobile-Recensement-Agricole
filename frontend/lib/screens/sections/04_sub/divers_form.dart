import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/language_provider.dart';
import 'dynamic_crop_table.dart';

class DiversForm extends StatelessWidget {
  const DiversForm({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isAr = lang.isArabic;

    const List<Map<String, String>> cropOptions = [
      {'ar': 'أعشاب و توابل', 'fr': 'Herbes et épices'},
      {
        'ar': 'نباتات تزيينية وعطرية',
        'fr': 'Plantes ornementales, aromatiques',
      },
      {'ar': 'مشاتل فواكه', 'fr': 'Pépinières fruitières'},
      {'ar': 'مشاتل غراسة', 'fr': 'Pépinières maraîchères'},
      {'ar': 'مشاتل غابية', 'fr': 'Pépinières forestières'},
      {'ar': 'مشاتل أخرى', 'fr': 'Autres Pépinières'},
      {'ar': 'محاصيل أخرى', 'fr': 'Autres Cultures'},
    ];

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DynamicCropTable(
            titleAr: 'متنوعة',
            titleFr: 'Divers',
            prefix: 'dv',
            options: cropOptions,
          ),
        ],
      ),
    );
  }
}
