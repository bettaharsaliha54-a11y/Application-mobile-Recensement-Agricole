import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/language_provider.dart';
import '../../../providers/questionnaire_provider.dart';

const _green = Color(0xFF2E7D32);

class DynamicAnimalTable extends StatelessWidget {
  final String titleAr;
  final String titleFr;
  final String prefix;
  final List<Map<String, String>> options;
  final bool hasTwoColumns; // For poultry (Chair/Ponte)
  final String? col1Ar;
  final String? col1Fr;
  final String? col2Ar;
  final String? col2Fr;

  const DynamicAnimalTable({
    super.key,
    required this.titleAr,
    required this.titleFr,
    required this.prefix,
    required this.options,
    this.hasTwoColumns = false,
    this.col1Ar,
    this.col1Fr,
    this.col2Ar,
    this.col2Fr,
  });

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final prov = context.watch<QuestionnaireProvider>();
    final isAr = lang.isArabic;

    // Get number of rows or default to 1
    int rowCount =
        int.tryParse(prov.values['${prefix}_count']?.toString() ?? '1') ?? 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(isAr ? titleAr : titleFr),
        const SizedBox(height: 8),
        _tableHeader(isAr),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: rowCount,
          itemBuilder: (context, index) => _animalRow(index, lang, prov, isAr),
        ),
        const SizedBox(height: 12),
        Center(
          child: TextButton.icon(
            onPressed: () {
              prov.updateValue('${prefix}_count', rowCount + 1);
            },
            icon: const Icon(
              Icons.add_circle_outline,
              color: Colors.white,
              size: 20,
            ),
            label: Text(
              isAr ? 'إضافة صنف' : 'Ajouter une espèce',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 13,
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: _green,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _sectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: _green.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: const Border(right: BorderSide(color: _green, width: 4)),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w900,
          color: _green,
        ),
      ),
    );
  }

  Widget _tableHeader(bool isAr) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: _green.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(flex: 3, child: _hCell(isAr ? 'الصنف' : 'Espèce')),
          if (hasTwoColumns) ...[
            Expanded(
              flex: 2,
              child: _hCell(isAr ? (col1Ar ?? 'لحم') : (col1Fr ?? 'Chair')),
            ),
            Expanded(
              flex: 2,
              child: _hCell(isAr ? (col2Ar ?? 'بيض') : (col2Fr ?? 'Ponte')),
            ),
          ] else
            Expanded(flex: 2, child: _hCell(isAr ? 'العدد' : 'Nombre')),
          Expanded(flex: 2, child: _hCell(isAr ? 'إجراءات' : 'Actions')),
        ],
      ),
    );
  }

  Widget _hCell(String t) => Text(
    t,
    textAlign: TextAlign.center,
    style: const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w900,
      color: _green,
    ),
  );

  Widget _animalRow(
    int index,
    LanguageProvider lang,
    QuestionnaireProvider prov,
    bool isAr,
  ) {
    final typeKey = '${prefix}_${index}_type';
    final val1Key = '${prefix}_${index}_v1';
    final val2Key = '${prefix}_${index}_v2';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: _dropdown(
              prov.values[typeKey],
              options,
              (v) => prov.updateValue(typeKey, v),
              lang,
            ),
          ),
          Expanded(
            flex: 2,
            child: _input(
              val1Key,
              prov.values[val1Key],
              (v) => prov.updateValue(val1Key, v),
            ),
          ),
          if (hasTwoColumns)
            Expanded(
              flex: 2,
              child: _input(
                val2Key,
                prov.values[val2Key],
                (v) => prov.updateValue(val2Key, v),
              ),
            ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _actionBtn(
                  icon: Icons.edit_outlined,
                  color: Colors.blue,
                  onTap: () {},
                ),
                const SizedBox(width: 4),
                _actionBtn(
                  icon: Icons.delete_outline_rounded,
                  color: Colors.redAccent,
                  onTap: () => _deleteRow(index, prov),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropdown(
    dynamic val,
    List<Map<String, String>> items,
    Function(String?) fn,
    LanguageProvider lang,
  ) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAF9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _green.withValues(alpha: 0.15)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: val?.toString(),
          isExpanded: true,
          hint: Text(
            lang.isArabic ? 'اختر' : 'Choisir',
            style: const TextStyle(fontSize: 11),
          ),
          items: items.map((e) {
            return DropdownMenuItem(
              value: e['fr'],
              child: Text(
                lang.isArabic ? e['ar']! : e['fr']!,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }).toList(),
          onChanged: fn,
        ),
      ),
    );
  }

  Widget _input(String stateKey, dynamic val, Function(String) fn) {
    return Container(
      height: 38,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        key: Key(stateKey),
        textAlign: TextAlign.center,
        initialValue: val?.toString() ?? '',
        keyboardType: TextInputType.number,
        onChanged: fn,
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 10),
        ),
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: _green,
        ),
      ),
    );
  }

  Widget _actionBtn({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }

  void _deleteRow(int index, QuestionnaireProvider prov) {
    int count =
        int.tryParse(prov.values['${prefix}_count']?.toString() ?? '1') ?? 1;
    if (count <= 1) {
      prov.updateValue('${prefix}_0_type', null);
      prov.updateValue('${prefix}_0_v1', null);
      prov.updateValue('${prefix}_0_v2', null);
      return;
    }
    for (int i = index; i < count - 1; i++) {
      prov.updateValue(
        '${prefix}_${i}_type',
        prov.values['${prefix}_${i + 1}_type'],
      );
      prov.updateValue(
        '${prefix}_${i}_v1',
        prov.values['${prefix}_${i + 1}_v1'],
      );
      prov.updateValue(
        '${prefix}_${i}_v2',
        prov.values['${prefix}_${i + 1}_v2'],
      );
    }
    prov.updateValue('${prefix}_${count - 1}_type', null);
    prov.updateValue('${prefix}_${count - 1}_v1', null);
    prov.updateValue('${prefix}_${count - 1}_v2', null);
    prov.updateValue('${prefix}_count', count - 1);
  }
}
