import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/language_provider.dart';
import 'dynamic_animal_table.dart';

class ApicultureForm extends StatelessWidget {
  const ApicultureForm({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isAr = lang.isArabic;

    const List<Map<String, String>> rucheOptions = [
      {'ar': 'خلايا عصرية', 'fr': 'Ruches modernes'},
      {'ar': 'خلايا تقليدية', 'fr': 'Ruches traditionnelles'},
    ];

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: const Column(
        children: [
          DynamicAnimalTable(
            titleAr: 'تربية النحل',
            titleFr: 'Apiculture',
            prefix: 'ap',
            options: rucheOptions,
          ),
        ],
      ),
    );
  }
}
