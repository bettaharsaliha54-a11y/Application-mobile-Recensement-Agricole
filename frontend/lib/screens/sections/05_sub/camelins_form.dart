import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/language_provider.dart';
import 'dynamic_animal_table.dart';

class CamelinsForm extends StatelessWidget {
  const CamelinsForm({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isAr = lang.isArabic;

    const List<Map<String, String>> animalOptions = [
      {'ar': 'نوق', 'fr': 'Chamelles'},
      {'ar': 'إبل أخرى', 'fr': 'Autres Camélins'},
    ];

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: const Column(
        children: [
          DynamicAnimalTable(
            titleAr: 'الإبل',
            titleFr: 'Camélins',
            prefix: 'cm',
            options: animalOptions,
          ),
        ],
      ),
    );
  }
}
