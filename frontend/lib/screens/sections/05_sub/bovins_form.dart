import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/language_provider.dart';
import 'dynamic_animal_table.dart';

class BovinsForm extends StatelessWidget {
  const BovinsForm({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isAr = lang.isArabic;

    const List<Map<String, String>> animalOptions = [
      {'ar': 'أبقار حلوب مطورة (BLM)', 'fr': 'Bovins BLM'},
      {'ar': 'أبقار حلوب محسنة (BLA)', 'fr': 'Bovins BLA'},
      {'ar': 'أبقار حلوب محلية (BLL)', 'fr': 'Bovins BLL'},
      {'ar': 'أبقار أخرى', 'fr': 'Autres Bovins'},
    ];

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: const Column(
        children: [
          DynamicAnimalTable(
            titleAr: 'الأبقار',
            titleFr: 'Bovins',
            prefix: 'bv',
            options: animalOptions,
          ),
        ],
      ),
    );
  }
}
