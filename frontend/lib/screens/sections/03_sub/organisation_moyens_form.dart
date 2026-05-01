import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/language_provider.dart';
import '../../../providers/questionnaire_provider.dart';

const _green = Color(0xFF2E7D32);

class OrganisationMoyensForm extends StatelessWidget {
  const OrganisationMoyensForm({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final prov = context.watch<QuestionnaireProvider>();
    final isAr = lang.isArabic;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 6. Organisation
        _blackTitle(
          isAr ? '6. تنظيم المستثمرة' : "6. Organisation de l'exploitation",
        ),
        _cardContainer(
          child: Column(
            children: [
              _yesNoQuestion(
                '57. ' +
                    (isAr
                        ? 'هل المستثمرة مكونة من قطعة واحدة؟'
                        : "L'exploitation est-elle d'un seul bloc?"),
                's57_un_bloc',
                prov,
                isAr,
              ),
              const Divider(height: 24),
              _numQuestion(
                '58. ' +
                    (isAr
                        ? 'إذا كان لا، ما هو عدد القطع؟'
                        : 'Si non, quel est le nombre de blocs?'),
                's58_nb_blocs',
                prov,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // 7. Occupants
        _blackTitle(isAr ? '7. السكان و الأسر' : '7. Occupants et ménages'),
        _cardContainer(
          child: Column(
            children: [
              _yesNoQuestion(
                '59. ' +
                    (isAr
                        ? 'هل هناك سكان غير شرعيين في المستثمرة؟'
                        : 'Existe-t-il des indus occupants?'),
                's59_indus',
                prov,
                isAr,
              ),
              const Divider(height: 24),
              _numQuestion(
                '60. ' +
                    (isAr
                        ? 'إذا كان نعم، ما هو عدد الأسر؟'
                        : 'Si oui, quel est le nombre de ménages?'),
                's60_nb_menages',
                prov,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // 8. Espaces
        _blackTitle(isAr ? '8. المساحات المشغولة' : '8. Espaces occupés'),
        _cardContainer(
          child: Column(
            children: [
              _surfaceInput(
                '61. ' +
                    (isAr
                        ? 'المساحة المبنية المشغولة'
                        : 'Surface bâtie occupée'),
                's61_batie',
                'm²',
                prov,
              ),
              const Divider(height: 24),
              _surfaceInput(
                '62. ' +
                    (isAr
                        ? 'المساحة غير المبنية المشغولة'
                        : 'Surface non bâtie occupée'),
                's62_non_batie',
                'Are',
                prov,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // 9. Energie
        _blackTitle(isAr ? '9. مصادر الطاقة' : "9. Sources d'énergie"),
        _cardContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '63. ' +
                    (isAr
                        ? 'ما هي مصادر الطاقة المستخدمة في المستثمرة؟'
                        : "Quelles sont les sources d'énergie utilisées?"),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _energyChip(
                    prov,
                    isAr ? 'الشبكة الكهربائية' : 'Réseau électrique',
                    'energy_grid',
                  ),
                  _energyChip(
                    prov,
                    isAr ? 'مولد كهرباء' : 'Groupe électrogène',
                    'energy_generator',
                  ),
                  _energyChip(
                    prov,
                    isAr ? 'الطاقة الشمسية' : 'Energie solaire',
                    'energy_solar',
                  ),
                  _energyChip(
                    prov,
                    isAr ? 'طاقة الرياح' : 'Energie éolienne',
                    'energy_wind',
                  ),
                  _energyChip(
                    prov,
                    isAr ? 'مصادر أخرى' : 'Autres sources',
                    'energy_other',
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _blackTitle(String t) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        t,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w900,
          color: Colors.black,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _cardContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _yesNoQuestion(
    String label,
    String key,
    QuestionnaireProvider prov,
    bool isAr,
  ) {
    int val = prov.values[key] ?? 0;
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(width: 8),
        _choiceBtn(
          isAr ? 'نعم' : 'Oui',
          1,
          val,
          (v) => prov.updateValue(key, v),
        ),
        const SizedBox(width: 8),
        _choiceBtn(
          isAr ? 'لا' : 'Non',
          2,
          val,
          (v) => prov.updateValue(key, v),
        ),
      ],
    );
  }

  Widget _choiceBtn(String lbl, int val, int current, Function(int) onSelect) {
    bool active = val == current;
    return InkWell(
      onTap: () => onSelect(val),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? _green : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: active ? _green : Colors.grey.shade300),
        ),
        child: Text(
          lbl,
          style: TextStyle(
            color: active ? Colors.white : Colors.black87,
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  Widget _numQuestion(String label, String key, QuestionnaireProvider prov) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(
          width: 80,
          child: Container(
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F4F2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextFormField(
              textAlign: TextAlign.center,
              initialValue: prov.values[key]?.toString() ?? '',
              keyboardType: TextInputType.number,
              onChanged: (v) => prov.updateValue(key, int.tryParse(v)),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: _green,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _surfaceInput(
    String label,
    String key,
    String unit,
    QuestionnaireProvider prov,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 100,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFFF0F4F2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  textAlign: TextAlign.center,
                  initialValue: prov.values[key]?.toString() ?? '',
                  keyboardType: TextInputType.number,
                  onChanged: (v) => prov.updateValue(key, double.tryParse(v)),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: _green,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8, left: 8),
                child: Text(
                  unit,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _energyChip(QuestionnaireProvider prov, String label, String key) {
    bool active = prov.values[key] == true;
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          color: active ? Colors.white : Colors.black87,
        ),
      ),
      selected: active,
      onSelected: (v) => prov.updateValue(key, v),
      selectedColor: _green,
      checkmarkColor: Colors.white,
      backgroundColor: Colors.grey.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: active ? _green : Colors.grey.shade300),
      ),
    );
  }
}
