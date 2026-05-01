import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/language_provider.dart';
import 'dynamic_crop_table.dart';

class MaraichageForm extends StatelessWidget {
  const MaraichageForm({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isAr = lang.isArabic;

    const List<Map<String, String>> cropOptions = [
      {'ar': 'بطاطا', 'fr': 'Pomme de terre'},
      {'ar': 'بصل جاف وأخضر', 'fr': 'Oignon sec et vert'},
      {'ar': 'ثوم', 'fr': 'Ail'},
      {'ar': 'طماطم', 'fr': 'Tomate'},
      {'ar': 'فلفل', 'fr': 'Piment'},
      {'ar': 'فلفل حلو (طازج ومجفف)', 'fr': 'Poivron (frais et séché)'},
      {'ar': 'جزر', 'fr': 'Carotte'},
      {'ar': 'كوسة', 'fr': 'Courgette'},
      {'ar': 'لفت', 'fr': 'Navet'},
      {'ar': 'خيار', 'fr': 'Concombre'},
      {'ar': 'قرنبيط وكرنب', 'fr': 'Chou et Chou-fleur'},
      {'ar': 'خرشف', 'fr': 'Artichaut'},
      {'ar': 'شمندر', 'fr': 'Betterave'},
      {'ar': 'فاصوليا خضراء', 'fr': 'Haricot vert'},
      {'ar': 'بازلاء', 'fr': 'Petit pois'},
      {'ar': 'خس', 'fr': 'Salade (Laitue)'},
      {'ar': 'بقدونس', 'fr': 'Persil'},
      {'ar': 'خضروات أخرى', 'fr': 'Autres'},
    ];

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: const SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DynamicCropTable(
              titleAr: 'الخضروات',
              titleFr: 'Maraîchage',
              prefix: 'mr',
              options: cropOptions,
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
