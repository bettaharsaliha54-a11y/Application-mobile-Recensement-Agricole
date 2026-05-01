import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/language_provider.dart';
import '../dynamic_generic_table.dart';

class MatV8Divers extends StatelessWidget {
  const MatV8Divers({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isAr = lang.isArabic;

    const List<Map<String, String>> matOptions = [
      {'ar': 'مضخة ثابتة', 'fr': 'Motopompe fixe'},
      {'ar': 'مضخة متنقلة', 'fr': 'Motopompe mobile'},
      {'ar': 'مجموعة توليد كهرباء', 'fr': 'Groupe électrogène'},
      {'ar': 'معدات متنوعة أخرى', 'fr': 'Autres matériels'},
    ];

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: const Column(
        children: [
          DynamicGenericTable(
            titleAr: 'معدات أخرى',
            titleFr: 'Autres matériels',
            prefix: 'mt_dv',
            options: matOptions,
            addTextAr: 'إضافة معدات',
            addTextFr: 'Ajouter matériel',
          ),
        ],
      ),
    );
  }
}
