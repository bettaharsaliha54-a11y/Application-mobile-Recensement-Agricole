import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/language_provider.dart';
import '../../../providers/questionnaire_provider.dart';

const _green = Color(0xFF2E7D32);

class DynamicGenericTable extends StatelessWidget {
  final String titleAr;
  final String titleFr;
  final String prefix;
  final List<Map<String, String>> options;
  final bool hasThreeCols;
  final String? col2Ar;
  final String? col2Fr;
  final String? col3Ar;
  final String? col3Fr;
  final String addTextAr;
  final String addTextFr;

  const DynamicGenericTable({
    super.key,
    required this.titleAr,
    required this.titleFr,
    required this.prefix,
    required this.options,
    this.hasThreeCols = false,
    this.col2Ar,
    this.col2Fr,
    this.col3Ar,
    this.col3Fr,
    required this.addTextAr,
    required this.addTextFr,
  });

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final prov = context.watch<QuestionnaireProvider>();
    final isAr = lang.isArabic;

    int rowCount =
        int.tryParse(prov.values['${prefix}_count']?.toString() ?? '1') ?? 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(isAr ? titleAr : titleFr, isAr),
        const SizedBox(height: 8),
        _tableHeader(isAr),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: rowCount,
          itemBuilder: (context, index) => _row(index, lang, prov, isAr),
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
              isAr ? addTextAr : addTextFr,
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
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _sectionHeader(String title, bool isAr) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: _green.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border(
          right: isAr
              ? const BorderSide(color: _green, width: 4)
              : BorderSide.none,
          left: !isAr
              ? const BorderSide(color: _green, width: 4)
              : BorderSide.none,
        ),
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
          Expanded(
            flex: 2,
            child: _hCell(isAr ? (col2Ar ?? 'العدد') : (col2Fr ?? 'Nombre')),
          ),
          if (hasThreeCols)
            Expanded(
              flex: 2,
              child: _hCell(
                isAr ? (col3Ar ?? 'المساحة') : (col3Fr ?? 'Surface'),
              ),
            ),
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

  Widget _row(
    int index,
    LanguageProvider lang,
    QuestionnaireProvider prov,
    bool isAr,
  ) {
    final typeKey = '${prefix}_${index}_type';
    final v2Key = '${prefix}_${index}_v2';
    final v3Key = '${prefix}_${index}_v3';

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
              v2Key,
              prov.values[v2Key],
              (v) => prov.updateValue(v2Key, v),
            ),
          ),
          if (hasThreeCols)
            Expanded(
              flex: 2,
              child: _input(
                v3Key,
                prov.values[v3Key],
                (v) => prov.updateValue(v3Key, v),
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
            style: const TextStyle(fontSize: 10),
          ),
          items: items.map((e) {
            return DropdownMenuItem(
              value: e['fr'],
              child: Text(
                lang.isArabic ? e['ar']! : e['fr']!,
                style: const TextStyle(
                  fontSize: 10,
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
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
      prov.updateValue('${prefix}_0_v2', null);
      prov.updateValue('${prefix}_0_v3', null);
      return;
    }
    for (int i = index; i < count - 1; i++) {
      prov.updateValue(
        '${prefix}_${i}_type',
        prov.values['${prefix}_${i + 1}_type'],
      );
      prov.updateValue(
        '${prefix}_${i}_v2',
        prov.values['${prefix}_${i + 1}_v2'],
      );
      prov.updateValue(
        '${prefix}_${i}_v3',
        prov.values['${prefix}_${i + 1}_v3'],
      );
    }
    prov.updateValue('${prefix}_${count - 1}_type', null);
    prov.updateValue('${prefix}_${count - 1}_v2', null);
    prov.updateValue('${prefix}_${count - 1}_v3', null);
    prov.updateValue('${prefix}_count', count - 1);
  }
}
