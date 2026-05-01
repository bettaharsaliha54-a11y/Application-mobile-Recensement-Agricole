import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/language_provider.dart';
import '../../../providers/questionnaire_provider.dart';

const _green = Color(0xFF2E7D32);

class DynamicCropTable extends StatelessWidget {
  final String titleAr;
  final String titleFr;
  final String prefix;
  final List<Map<String, String>> options;
  final bool hasIrrigated;
  final bool hasIntercalary;

  const DynamicCropTable({
    super.key,
    required this.titleAr,
    required this.titleFr,
    required this.prefix,
    required this.options,
    this.hasIrrigated = true,
    this.hasIntercalary = true,
  });

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final prov = context.watch<QuestionnaireProvider>();
    final isAr = lang.isArabic;

    // Get current row count from provider, default to 1
    int rowCount =
        int.tryParse(prov.values['${prefix}_count']?.toString() ?? '1') ?? 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(isAr ? titleAr : titleFr),
        _tableHeader(isAr),
        for (int i = 0; i < rowCount; i++) _cropRow(i, lang, prov, isAr),

        const SizedBox(height: 12),
        // Add Button
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
              isAr ? 'إضافة محصول' : 'Ajouter un محصول',
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
      ],
    );
  }

  Widget _sectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      margin: const EdgeInsets.only(bottom: 8),
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
          Expanded(flex: 3, child: _hCell(isAr ? 'النوع' : 'Type')),
          Expanded(flex: 2, child: _hCell(isAr ? 'بعلي (Ha)' : 'Sec')),
          if (hasIrrigated)
            Expanded(flex: 2, child: _hCell(isAr ? 'مسقي' : 'Irr.')),
          if (hasIntercalary)
            Expanded(flex: 2, child: _hCell(isAr ? 'بيني' : 'Int.')),
          // Actions Column
          Expanded(flex: 2, child: _hCell(isAr ? 'إجراءات' : 'Actions')),
        ],
      ),
    );
  }

  Widget _hCell(String t) => Text(
    t,
    textAlign: TextAlign.center,
    style: const TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w900,
      color: _green,
    ),
  );

  Widget _cropRow(
    int index,
    LanguageProvider lang,
    QuestionnaireProvider prov,
    bool isAr,
  ) {
    final typeKey = '${prefix}_${index}_type';
    final secKey = '${prefix}_${index}_sec';
    final irrKey = '${prefix}_${index}_irr';
    final intKey = '${prefix}_${index}_int';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        children: [
          // Dropdown for Type
          Expanded(
            flex: 3,
            child: _dropdown(
              prov.values[typeKey],
              options,
              (v) => prov.updateValue(typeKey, v),
              lang,
            ),
          ),
          // Sec
          Expanded(
            flex: 2,
            child: _input(
              secKey,
              prov.values[secKey],
              (v) => prov.updateValue(secKey, v),
            ),
          ),
          // Irr
          if (hasIrrigated)
            Expanded(
              flex: 2,
              child: _input(
                irrKey,
                prov.values[irrKey],
                (v) => prov.updateValue(irrKey, v),
              ),
            ),
          // Int
          if (hasIntercalary)
            Expanded(
              flex: 2,
              child: _input(
                intKey,
                prov.values[intKey],
                (v) => prov.updateValue(intKey, v),
              ),
            ),

          // Actions: Edit and Delete
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Edit Button (Icon for space)
                _actionBtn(
                  icon: Icons.edit_outlined,
                  color: Colors.blue,
                  onTap: () {
                    // Already editable in-place, but we can show a toast or highlight
                  },
                ),
                const SizedBox(width: 4),
                // Delete Button
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
      // Clear data but keep the row
      prov.updateValue('${prefix}_0_type', null);
      prov.updateValue('${prefix}_0_sec', null);
      prov.updateValue('${prefix}_0_irr', null);
      prov.updateValue('${prefix}_0_int', null);
      return;
    }

    // Shift data
    for (int i = index; i < count - 1; i++) {
      prov.updateValue(
        '${prefix}_${i}_type',
        prov.values['${prefix}_${i + 1}_type'],
      );
      prov.updateValue(
        '${prefix}_${i}_sec',
        prov.values['${prefix}_${i + 1}_sec'],
      );
      prov.updateValue(
        '${prefix}_${i}_irr',
        prov.values['${prefix}_${i + 1}_irr'],
      );
      prov.updateValue(
        '${prefix}_${i}_int',
        prov.values['${prefix}_${i + 1}_int'],
      );
    }

    // Clear last row
    prov.updateValue('${prefix}_${count - 1}_type', null);
    prov.updateValue('${prefix}_${count - 1}_sec', null);
    prov.updateValue('${prefix}_${count - 1}_irr', null);
    prov.updateValue('${prefix}_${count - 1}_int', null);

    // Update count
    prov.updateValue('${prefix}_count', count - 1);
  }

  Widget _dropdown(
    dynamic val,
    List<Map<String, String>> items,
    Function(String?) fn,
    LanguageProvider lang,
  ) {
    return Container(
      height: 36,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.any((e) => e['fr'] == val) ? val : null,
          isExpanded: true,
          iconSize: 18,
          iconEnabledColor: _green,
          hint: Text(
            lang.isArabic ? 'اختر' : 'Choisir',
            style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
          ),
          items: items.map((e) {
            return DropdownMenuItem<String>(
              value: e['fr'], // Always use FR as internal key
              child: Text(
                lang.isArabic ? e['ar']! : e['fr']!,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
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
      height: 36,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextFormField(
        key: Key(stateKey),
        textAlign: TextAlign.center,
        initialValue: val?.toString() ?? '',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: fn,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }
}
