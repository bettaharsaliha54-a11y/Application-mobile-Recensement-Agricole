import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/language_provider.dart';
import '../dynamic_generic_table.dart';

class BatV7Habitation extends StatelessWidget {
  const BatV7Habitation({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isAr = lang.isArabic;

    const List<Map<String, String>> batOptions = [
      {'ar': 'سكن المستغل', 'fr': 'Logement exploitant'},
      {'ar': 'سكن العمال', 'fr': 'Logement ouvriers'},
      {'ar': 'مباني أخرى', 'fr': 'Autres bâtiments'},
    ];

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: const Column(
        children: [
          DynamicGenericTable(
            titleAr: 'المباني والمنشآت',
            titleFr: 'Bâtiments d\'habitation',
            prefix: 'bt_hb',
            options: batOptions,
            hasThreeCols: true,
            col3Ar: 'المساحة',
            col3Fr: 'Surface',
            addTextAr: 'إضافة مبنى',
            addTextFr: 'Ajouter bâtiment',
          ),
        ],
      ),
    );
  }
}
