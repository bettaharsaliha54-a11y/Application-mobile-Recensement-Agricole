import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/language_provider.dart';
import 'dynamic_crop_table.dart';

class ArboricultureForm extends StatelessWidget {
  const ArboricultureForm({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isAr = lang.isArabic;

    const List<Map<String, String>> cropOptions = [
      {'ar': 'حمضيات (برتقال، ليمون...)', 'fr': 'Agrumes (orange, citron...)'},
      {'ar': 'مشمش', 'fr': 'Abricot'},
      {'ar': 'خوخ و نكتارين', 'fr': 'Pêche et nectarine'},
      {'ar': 'إجاص', 'fr': 'Poire (Coing)'},
      {'ar': 'تفاح', 'fr': 'Pomme'},
      {'ar': 'لوز', 'fr': 'Amandier'},
      {'ar': 'تين', 'fr': 'Figuier'},
      {'ar': 'عنب', 'fr': 'Vigne'},
      {'ar': 'زيتون مائدة', 'fr': 'Olive de table'},
      {'ar': 'زيتون زيت', 'fr': 'Olive à huile'},
      {'ar': 'نخيل دقلة نور', 'fr': 'Palmier dattier (Deglet Nour)'},
      {'ar': 'نخيل أصناف أخرى', 'fr': 'Palmier dattier (Ghars/autres)'},
      {'ar': 'عنب مائدة', 'fr': 'Raisin de table'},
      {'ar': 'رمان', 'fr': 'Grenade'},
      {'ar': 'أرغان', 'fr': 'Argan'},
      {'ar': 'أخرى', 'fr': 'Autre'},
    ];

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DynamicCropTable(
            titleAr: 'الأشجار المثمرة',
            titleFr: 'Arboriculture',
            prefix: 'ar',
            options: cropOptions,
          ),
        ],
      ),
    );
  }
}
