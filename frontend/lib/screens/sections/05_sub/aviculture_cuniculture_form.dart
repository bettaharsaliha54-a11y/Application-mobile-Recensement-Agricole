import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/language_provider.dart';
import 'dynamic_animal_table.dart';

class AvicultureCunicultureForm extends StatelessWidget {
  const AvicultureCunicultureForm({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isAr = lang.isArabic;

    const List<Map<String, String>> rabbitOptions = [
      {'ar': 'أرانب (إناث)', 'fr': 'Lapines'},
      {'ar': 'أرانب أخرى', 'fr': 'Autres Lapins'},
    ];

    const List<Map<String, String>> poultryOptions = [
      {'ar': 'دجاج', 'fr': 'Poules'},
      {'ar': 'ديك رومي', 'fr': 'Dindes'},
      {'ar': 'دواجن أخرى', 'fr': 'Autres Volailles'},
    ];

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: Column(
        children: [
          DynamicAnimalTable(
            titleAr: 'تربية الأرانب',
            titleFr: 'Cuniculture',
            prefix: 'cn',
            options: rabbitOptions,
          ),
          const SizedBox(height: 10),
          DynamicAnimalTable(
            titleAr: 'تربية الدواجن',
            titleFr: 'Aviculture',
            prefix: 'av',
            options: poultryOptions,
            hasTwoColumns: true,
            col1Ar: 'لحم',
            col1Fr: 'Chair',
            col2Ar: 'بيض',
            col2Fr: 'Ponte',
          ),
        ],
      ),
    );
  }
}
