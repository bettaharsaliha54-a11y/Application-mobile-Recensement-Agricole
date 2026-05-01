import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/language_provider.dart';
import '../dynamic_generic_table.dart';

class BatV7Elevage extends StatelessWidget {
  const BatV7Elevage({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isAr = lang.isArabic;

    const List<Map<String, String>> batOptions = [
      {'ar': 'حظيرة', 'fr': 'Bergerie'},
      {'ar': 'إسطبل', 'fr': 'Étable'},
      {'ar': 'إسطبل الخيول', 'fr': 'Écurie'},
      {'ar': 'مدجنة (مبنى صلب)', 'fr': 'Poulailler (dur)'},
      {'ar': 'مدجنة (بيوت بلاستيكية)', 'fr': 'Poulailler (serre)'},
      {'ar': 'بيوت بلاستيكية نفق', 'fr': 'Serres tunnels'},
      {'ar': 'بيوت متعددة القباب', 'fr': 'Serres multichapelles'},
    ];

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: const Column(
        children: [
          DynamicGenericTable(
            titleAr: 'مباني تربية الحيوانات',
            titleFr: 'Bâtiments d\'élevage',
            prefix: 'bt_el',
            options: batOptions,
            hasThreeCols: true,
            col3Ar: 'المساحة (م²)',
            col3Fr: 'Surface (m²)',
            addTextAr: 'إضافة مبنى',
            addTextFr: 'Ajouter bâtiment',
          ),
        ],
      ),
    );
  }
}
