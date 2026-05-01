import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/language_provider.dart';
import '../../../providers/questionnaire_provider.dart';

const _green = Color(0xFF2E7D32);

class ExplConcessionForm extends StatelessWidget {
  const ExplConcessionForm({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final prov = context.watch<QuestionnaireProvider>();
    final isAr = lang.isArabic;

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: Column(
        children: [
          _sectionHeader(
            isAr ? 'حالات خاصة (EAI / EAC)' : 'Cas particuliers (EAI / EAC)',
          ),
          _fieldCard([
            _yesNoRow(
              isAr
                  ? 'إذا كانت المستثمرة م.ف.ف أو م.ف.ج، هل يملك عقد امتياز؟'
                  : 'Si EAI ou EAC, possède-t-il un acte de concession?',
              'expl_concession',
              prov,
              isAr,
            ),
            const SizedBox(height: 16),
            _numQuestion(
              isAr
                  ? 'إذا كانت م.ف.ج، ما هو عدد الأعضاء؟'
                  : 'Si EAC, quel est le nombre des membres?',
              'expl_eac_members',
              prov,
            ),
          ]),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: _green.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
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

  Widget _fieldCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(children: children),
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
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(
          width: 90,
          child: Container(
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F4F2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextFormField(
              key: Key(prov.values[key]?.toString() ?? ''),
              textAlign: TextAlign.center,
              initialValue: prov.values[key]?.toString() ?? '',
              keyboardType: TextInputType.number,
              onChanged: (v) => prov.updateValue(key, int.tryParse(v)),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
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

  Widget _yesNoRow(
    String label,
    String key,
    QuestionnaireProvider prov,
    bool isAr,
  ) {
    int val = prov.values[key] ?? 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _btn(isAr ? 'نعم' : 'Oui', 1, val, (n) => prov.updateValue(key, n)),
            const SizedBox(width: 12),
            _btn(isAr ? 'لا' : 'Non', 2, val, (n) => prov.updateValue(key, n)),
          ],
        ),
      ],
    );
  }

  Widget _btn(String t, int v, int cur, Function(int) onS) {
    bool active = v == cur;
    return Expanded(
      child: InkWell(
        onTap: () => onS(v),
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? _green : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: active ? _green : Colors.grey.shade300),
          ),
          child: Text(
            t,
            style: TextStyle(
              color: active ? Colors.white : Colors.black87,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
