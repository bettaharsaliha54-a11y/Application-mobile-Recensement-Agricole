import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/language_provider.dart';
import 'dynamic_land_status_table.dart';

class ExplStatutTerresForm extends StatelessWidget {
  const ExplStatutTerresForm({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isAr = lang.isArabic;

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: DynamicLandStatusTable(
          titleAr: 'الوضع القانوني للأراضي',
          titleFr: 'Statut juridique des terres',
          prefix: 'land_statut',
        ),
      ),
    );
  }
}
