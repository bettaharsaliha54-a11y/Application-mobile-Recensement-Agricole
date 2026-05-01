import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/language_provider.dart';
import '../../../providers/questionnaire_provider.dart';

const _green = Color(0xFF2E7D32);

class DynamicLandStatusTable extends StatelessWidget {
  final String titleAr;
  final String titleFr;
  final String prefix;

  const DynamicLandStatusTable({
    super.key,
    required this.titleAr,
    required this.titleFr,
    required this.prefix,
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
        _tableHeader(isAr),
        for (int i = 0; i < rowCount; i++) _landRow(i, lang, prov, isAr),

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
              isAr ? 'إضافة وضع قانوني' : 'Ajouter un statut juridique',
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

  Widget _sectionHeader(String title, bool isAr) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      margin: const EdgeInsets.only(bottom: 8),
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
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: _green.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(flex: 3, child: _hText(isAr ? 'الاستغلال' : 'Mode')),
          Expanded(flex: 3, child: _hText(isAr ? 'أصل الأرض' : 'Origine')),
          Expanded(flex: 2, child: _hText(isAr ? 'قانوني' : 'Jurid.')),
          Expanded(flex: 1, child: _hText('Ha')),
          Expanded(flex: 1, child: _hText('Are')),
          Expanded(flex: 1, child: _hText('')),
        ],
      ),
    );
  }

  Widget _hText(String t) => Text(
    t,
    textAlign: TextAlign.center,
    style: const TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w900,
      color: _green,
    ),
  );

  Widget _landRow(
    int index,
    LanguageProvider lang,
    QuestionnaireProvider prov,
    bool isAr,
  ) {
    final modeKey = '${prefix}_${index}_mode';
    final origKey = '${prefix}_${index}_orig';
    final jurKey = '${prefix}_${index}_jur';
    final haKey = '${prefix}_${index}_ha';
    final areKey = '${prefix}_${index}_are';

    final modeOptions = isAr
        ? [
            {'ar': '1- APFA « استصلاح »', 'fr': '1- APFA'},
            {'ar': '2- م ت ج « Ex EAC »', 'fr': '2- Ex EAC'},
            {'ar': '3- م ت ف « Ex EAI »', 'fr': '3- Ex EAI'},
            {'ar': '4- إ أ ف « Ex GCA »', 'fr': '4- Ex GCA'},
            {'ar': '5- م خ ث م ص « Ex CDARS »', 'fr': '5- Ex CDARS'},
            {'ar': '6- Concession CIM 108', 'fr': '6- Concession CIM'},
            {'ar': '7- Nouvelle concession ONTA', 'fr': '7- Nouvelle ONTA'},
            {'ar': '8- Nouvelle concession OCAS', 'fr': '8- Nouvelle OCAS'},
            {'ar': '9- استغلال بدون سند', 'fr': '9- Sans titre'},
            {'ar': '10- مزرعة نموذجية', 'fr': '10- Ferme pilote'},
            {
              'ar': '11- مؤسسة عمومية (EPA/EPIC)',
              'fr': '11- Public (EPA/EPIC)',
            },
            {'ar': '12- حق الانتفاع في الغابات', 'fr': '12- Usage forêts'},
            {'ar': '13- غير معروف', 'fr': '13- Inconnu'},
          ]
        : [
            {'ar': '1- APFA', 'fr': '1- APFA'},
            {'ar': '2- Ex EAC', 'fr': '2- Ex EAC'},
            {'ar': '3- Ex EAI', 'fr': '3- Ex EAI'},
            {'ar': '4- Ex GCA', 'fr': '4- Ex GCA'},
            {'ar': '5- Ex CDARS', 'fr': '5- Ex CDARS'},
            {'ar': '6- Concession CIM', 'fr': '6- Concession CIM'},
            {'ar': '7- Nouvelle ONTA', 'fr': '7- Nouvelle ONTA'},
            {'ar': '8- Nouvelle OCAS', 'fr': '8- Nouvelle OCAS'},
            {'ar': '9- Sans titre', 'fr': '9- Sans titre'},
            {'ar': '10- Ferme pilote', 'fr': '10- Ferme pilote'},
            {'ar': '11- Public (EPA/EPIC)', 'fr': '11- Public (EPA/EPIC)'},
            {'ar': '12- Usage forêts', 'fr': '12- Usage forêts'},
            {'ar': '13- Inconnu', 'fr': '13- Inconnu'},
          ];

    final originOptions = isAr
        ? [
            {'ar': '1- ملك شخصي موثق', 'fr': '1- Privé titré'},
            {'ar': '2- ملك شخصي غير موثق', 'fr': '2- Privé non titré'},
            {'ar': '3- ملك مشترك موثق', 'fr': '3- Indivision titré'},
            {'ar': '4- ملك مشترك غير موثق', 'fr': '4- Indivision non titré'},
            {'ar': '5- ملكية عامة للدولة', 'fr': '5- Domaine public'},
            {'ar': '6- ملكية خاصة للدولة', 'fr': '6- Domaine privé'},
            {'ar': '7- وقف خاص', 'fr': '7- Wakf privé'},
            {'ar': '8- وقف عام', 'fr': '8- Wakf public'},
            {'ar': '9- مجهول', 'fr': '9- Inconnu'},
          ]
        : [
            {'ar': '1- Privé titré', 'fr': '1- Privé titré'},
            {'ar': '2- Privé non titré', 'fr': '2- Privé non titré'},
            {'ar': '3- Indivision titré', 'fr': '3- Indivision titré'},
            {'ar': '4- Indivision non titré', 'fr': '4- Indivision non titré'},
            {'ar': '5- Domaine public', 'fr': '5- Domaine public'},
            {'ar': '6- Domaine privé', 'fr': '6- Domaine privé'},
            {'ar': '7- Wakf privé', 'fr': '7- Wakf privé'},
            {'ar': '8- Wakf public', 'fr': '8- Wakf public'},
            {'ar': '9- Inconnu', 'fr': '9- Inconnu'},
          ];

    final jurOptions = isAr
        ? [
            {'ar': '1- ملك', 'fr': '1- Propriété'},
            {'ar': '2- استئجار', 'fr': '2- Location'},
            {'ar': '3- مزارعة', 'fr': '3- Métayage'},
            {'ar': '4- حيازة', 'fr': '4- Possession'},
            {'ar': '5- بدون سند', 'fr': '5- Sans titre'},
          ]
        : [
            {'ar': '1- Propriété', 'fr': '1- Propriété'},
            {'ar': '2- Location', 'fr': '2- Location'},
            {'ar': '3- Métayage', 'fr': '3- Métayage'},
            {'ar': '4- Possession', 'fr': '4- Possession'},
            {'ar': '5- Sans titre', 'fr': '5- Sans titre'},
          ];

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
              prov.values[modeKey],
              modeOptions,
              (v) => prov.updateValue(modeKey, v),
              lang,
            ),
          ),
          Expanded(
            flex: 3,
            child: _dropdown(
              prov.values[origKey],
              originOptions,
              (v) => prov.updateValue(origKey, v),
              lang,
            ),
          ),
          Expanded(
            flex: 2,
            child: _dropdown(
              prov.values[jurKey],
              jurOptions,
              (v) => prov.updateValue(jurKey, v),
              lang,
            ),
          ),
          Expanded(
            flex: 1,
            child: _input(
              haKey,
              prov.values[haKey],
              (v) => prov.updateValue(haKey, v),
              isNum: true,
            ),
          ),
          Expanded(
            flex: 1,
            child: _input(
              areKey,
              prov.values[areKey],
              (v) => prov.updateValue(areKey, v),
              isNum: true,
            ),
          ),

          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
      prov.updateValue('${prefix}_0_mode', null);
      prov.updateValue('${prefix}_0_orig', null);
      prov.updateValue('${prefix}_0_jur', null);
      prov.updateValue('${prefix}_0_ha', null);
      prov.updateValue('${prefix}_0_are', null);
      return;
    }
    for (int i = index; i < count - 1; i++) {
      prov.updateValue(
        '${prefix}_${i}_mode',
        prov.values['${prefix}_${i + 1}_mode'],
      );
      prov.updateValue(
        '${prefix}_${i}_orig',
        prov.values['${prefix}_${i + 1}_orig'],
      );
      prov.updateValue(
        '${prefix}_${i}_jur',
        prov.values['${prefix}_${i + 1}_jur'],
      );
      prov.updateValue(
        '${prefix}_${i}_ha',
        prov.values['${prefix}_${i + 1}_ha'],
      );
      prov.updateValue(
        '${prefix}_${i}_are',
        prov.values['${prefix}_${i + 1}_are'],
      );
    }
    prov.updateValue('${prefix}_${count - 1}_mode', null);
    prov.updateValue('${prefix}_${count - 1}_orig', null);
    prov.updateValue('${prefix}_${count - 1}_jur', null);
    prov.updateValue('${prefix}_${count - 1}_ha', null);
    prov.updateValue('${prefix}_${count - 1}_are', null);
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
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.any((e) => e['fr'] == val) ? val : null,
          isExpanded: true,
          iconSize: 16,
          iconEnabledColor: _green,
          hint: Text(
            lang.isArabic ? 'اختر' : 'Choisir',
            style: const TextStyle(fontSize: 8),
          ),
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e['fr'], // Always use FR as internal value
                  child: Text(
                    lang.isArabic ? e['ar']! : e['fr']!,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: fn,
        ),
      ),
    );
  }

  Widget _input(String stateKey, dynamic val, Function(String) fn, {bool isNum = false}) {
    return Container(
      height: 36,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextFormField(
        key: Key(stateKey),
        textAlign: TextAlign.center,
        initialValue: val?.toString() ?? '',
        keyboardType: isNum ? TextInputType.number : TextInputType.text,
        onChanged: fn,
        style: const TextStyle(
          fontSize: 10,
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
