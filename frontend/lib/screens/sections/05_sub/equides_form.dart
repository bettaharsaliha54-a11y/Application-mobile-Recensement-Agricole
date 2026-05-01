import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/language_provider.dart';
import 'dynamic_animal_table.dart';

class EquidesForm extends StatelessWidget {
  const EquidesForm({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isAr = lang.isArabic;

    const List<Map<String, String>> animalOptions = [
      {'ar': 'فرس', 'fr': 'Juments'},
      {'ar': 'خيول أخرى', 'fr': 'Autres Equidés'},
      {'ar': 'بغال', 'fr': 'Mulets'},
      {'ar': 'حمير', 'fr': 'Anes'},
    ];

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: const Column(
        children: [
          DynamicAnimalTable(
            titleAr: 'الخيل والبغال والحمير',
            titleFr: 'Équidés',
            prefix: 'eq',
            options: animalOptions,
          ),
        ],
      ),
    );
  }
}
