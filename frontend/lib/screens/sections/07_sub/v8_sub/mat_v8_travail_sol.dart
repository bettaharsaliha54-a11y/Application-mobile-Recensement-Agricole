import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/language_provider.dart';
import '../dynamic_generic_table.dart';

class MatV8TravailSol extends StatelessWidget {
  const MatV8TravailSol({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isAr = lang.isArabic;

    const List<Map<String, String>> matOptions = [
      {'ar': 'محراث سكة', 'fr': 'Charrue à socs'},
      {'ar': 'محراث قرصي', 'fr': 'Charrue à disques'},
      {'ar': 'محراث إزميلي (Chisel)', 'fr': 'Chisel/Cultivateur'},
      {'ar': 'آلة بذر', 'fr': 'Semoir'},
      {'ar': 'آلة نثر الأسمدة', 'fr': 'Epandeur d\'engrais'},
      {'ar': 'آلة رش المبيدات', 'fr': 'Pulvérisateur'},
      {'ar': 'آلة توزيع الأسمدة العضوية', 'fr': 'Epandeur fumier'},
    ];

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: const Column(
        children: [
          DynamicGenericTable(
            titleAr: 'المحارث وآلات تهيئة التربة',
            titleFr: 'Charrues et Travail du sol',
            prefix: 'mt_ts',
            options: matOptions,
            addTextAr: 'إضافة آلة',
            addTextFr: 'Ajouter machine',
          ),
        ],
      ),
    );
  }
}
