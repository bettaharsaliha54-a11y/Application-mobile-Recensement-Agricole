import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/language_provider.dart';
import 'dynamic_animal_table.dart';

class OvinsCaprinsForm extends StatelessWidget {
  const OvinsCaprinsForm({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isAr = lang.isArabic;

    const List<Map<String, String>> animalOptions = [
      {'ar': 'نعاج', 'fr': 'Brebis'},
      {'ar': 'أغنام أخرى', 'fr': 'Autres Ovins'},
      {'ar': 'عنزات', 'fr': 'Chèvres'},
      {'ar': 'ماعز أخرى', 'fr': 'Autres Caprins'},
    ];

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: const Column(
        children: [
          DynamicAnimalTable(
            titleAr: 'الأغنام والماعز',
            titleFr: 'Ovins et Caprins',
            prefix: 'oc',
            options: animalOptions,
          ),
        ],
      ),
    );
  }
}
