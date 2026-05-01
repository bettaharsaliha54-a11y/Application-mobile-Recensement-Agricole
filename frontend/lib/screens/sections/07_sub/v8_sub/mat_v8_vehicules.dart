import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/language_provider.dart';
import '../dynamic_generic_table.dart';

class MatV8Vehicules extends StatelessWidget {
  const MatV8Vehicules({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isAr = lang.isArabic;

    const List<Map<String, String>> matOptions = [
      {'ar': 'شاحنة', 'fr': 'Camion'},
      {'ar': 'مركبة نفعية', 'fr': 'Véhicule utilitaire'},
      {'ar': 'مقطورة', 'fr': 'Remorque'},
      {'ar': 'صهريج مجرور', 'fr': 'Citerne tractée'},
      {'ar': 'صهريج محمول', 'fr': 'Citerne portée'},
    ];

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: const Column(
        children: [
          DynamicGenericTable(
            titleAr: 'المركبات والمقطورات',
            titleFr: 'Véhicules et Remorques',
            prefix: 'mt_vh',
            options: matOptions,
            addTextAr: 'إضافة مركبة',
            addTextFr: 'Ajouter véhicule',
          ),
        ],
      ),
    );
  }
}
