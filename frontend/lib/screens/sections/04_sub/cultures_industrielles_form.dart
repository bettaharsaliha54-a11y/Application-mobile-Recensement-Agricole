import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/language_provider.dart';
import 'dynamic_crop_table.dart';

class CulturesIndustriellesForm extends StatelessWidget {
  const CulturesIndustriellesForm({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isAr = lang.isArabic;

    const List<Map<String, String>> cropOptions = [
      {'ar': 'طماطم صناعية', 'fr': 'Tomate industrielle'},
      {'ar': 'شمندر سكري', 'fr': 'Betterave à sucre'},
      {'ar': 'الفول السوداني', 'fr': 'Arachide'},
      {'ar': 'الصوجا', 'fr': 'Soja'},
      {'ar': 'الذرة', 'fr': 'Maïs (Huile)'},
      {'ar': 'التبغ', 'fr': 'Tabac'},
      {'ar': 'أخرى', 'fr': 'Autre'},
    ];

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DynamicCropTable(
            titleAr: 'المحاصيل الصناعية',
            titleFr: 'Cultures industrielles',
            prefix: 'ci',
            options: cropOptions,
          ),
        ],
      ),
    );
  }
}
