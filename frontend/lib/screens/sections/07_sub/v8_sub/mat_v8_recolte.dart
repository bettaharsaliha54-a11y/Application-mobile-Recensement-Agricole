import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/language_provider.dart';
import '../dynamic_generic_table.dart';

class MatV8Recolte extends StatelessWidget {
  const MatV8Recolte({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isAr = lang.isArabic;

    const List<Map<String, String>> matOptions = [
      {'ar': 'حصادة دارسة التلال', 'fr': 'Moissonneuse batteuse colline'},
      {'ar': 'حصادة دارسة عادية', 'fr': 'Moissonneuse batteuse plaine'},
      {'ar': 'حصادة علف', 'fr': 'Ensileuse'},
      {'ar': 'آلة حش', 'fr': 'Faucheuse'},
      {'ar': 'آلة ربط', 'fr': 'Bottteleuse/Presse'},
      {'ar': 'آلة غرس/قلع البطاطا', 'fr': 'Planteuse/Arracheuse PDT'},
      {'ar': 'معدات جني أخرى', 'fr': 'Autres matériels de récolte'},
    ];

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: const Column(
        children: [
          DynamicGenericTable(
            titleAr: 'آلات الحصاد والدرس',
            titleFr: 'Moissonneuses et Récolte',
            prefix: 'mt_rc',
            options: matOptions,
            addTextAr: 'إضافة آلة',
            addTextFr: 'Ajouter machine',
          ),
        ],
      ),
    );
  }
}
