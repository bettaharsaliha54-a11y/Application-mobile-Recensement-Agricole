import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/language_provider.dart';
import '../dynamic_generic_table.dart';

class BatV7Stockage extends StatelessWidget {
  const BatV7Stockage({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isAr = lang.isArabic;

    const List<Map<String, String>> batOptions = [
      {'ar': 'مستودعات', 'fr': 'Hangar/Entrepôt'},
      {'ar': 'أقبية', 'fr': 'Caves'},
      {'ar': 'غرف تبريد', 'fr': 'Chambres froides'},
      {'ar': 'صوامع', 'fr': 'Silos'},
      {'ar': 'أخرى', 'fr': 'Autres'},
    ];

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: const Column(
        children: [
          DynamicGenericTable(
            titleAr: 'مباني التخزين والتحويل',
            titleFr: 'Stockage et Transformation',
            prefix: 'bt_st',
            options: batOptions,
            hasThreeCols: true,
            col3Ar: 'السعة/الحجم',
            col3Fr: 'Capacité',
            addTextAr: 'إضافة مبنى',
            addTextFr: 'Ajouter bâtiment',
          ),
        ],
      ),
    );
  }
}
