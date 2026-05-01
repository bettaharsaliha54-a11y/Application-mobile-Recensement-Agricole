import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/language_provider.dart';
import '../../providers/questionnaire_provider.dart';
import '03_sub/dynamic_superficie_table.dart';
import '03_sub/organisation_moyens_form.dart';

class SuperficiesFormScreen extends StatelessWidget {
  const SuperficiesFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final prov = context.watch<QuestionnaireProvider>();
    final isAr = lang.isArabic;

    const List<Map<String, String>> labourables = [
      {'ar': 'المحاصيل العشبية', 'fr': 'Cultures herbacées'},
      {'ar': 'أراضي مستريحة (بور)', 'fr': 'Terres au repos (jachères)'},
    ];

    const List<Map<String, String>> permanentes = [
      {'ar': 'محاصيل دائمة (مغروسات)', 'fr': 'Cultures pérennes'},
    ];

    const List<Map<String, String>> prairies = [
      {'ar': 'مروج طبيعية', 'fr': 'Prairies naturelles'},
      {'ar': 'المراعي', 'fr': 'Pacages et parcours'},
    ];

    const List<Map<String, String>> otherSurfaces = [
      {'ar': 'مساحات غير منتجة', 'fr': 'Surfaces improductives'},
      {'ar': 'أراضي الغابات', 'fr': 'Terres forestières'},
    ];

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Terres Labourables
            _blackTitle(isAr ? '1. الأراضي المحروثة' : '1. Terres labourables'),
            DynamicSuperficieTable(
              titleAr: 'توزيع الأراضي المحروثة',
              titleFr: 'Distribution des terres labourables',
              prefix: 'sup_lab',
              options: labourables,
              addTextAr: 'إضافة صنف',
              addTextFr: 'Ajouter',
            ),
            const SizedBox(height: 24),

            // 2. Cultures Permanentes
            _blackTitle(
              isAr ? '2. المحاصيل الدائمة' : '2. Cultures permanentes',
            ),
            DynamicSuperficieTable(
              titleAr: 'توزيع مساحة المحاصيل الدائمة',
              titleFr: 'Distribution des cultures permanentes',
              prefix: 'sup_perm',
              options: permanentes,
              addTextAr: 'إضافة صنف',
              addTextFr: 'Ajouter',
            ),
            const SizedBox(height: 24),

            // 3. Prairies et Parcours
            _blackTitle(
              isAr ? '3. المروج و المراعي' : '3. Prairies et parcours',
            ),
            DynamicSuperficieTable(
              titleAr: 'توزيع المروج و المراعي',
              titleFr: 'Distribution des prairies et parcours',
              prefix: 'sup_prairie',
              options: prairies,
              addTextAr: 'إضافة صنف',
              addTextFr: 'Ajouter',
            ),
            const SizedBox(height: 24),

            // 4. Surfaces Improductives et Forestières
            _blackTitle(isAr ? '4. مساحات أخرى' : '4. Autres surfaces'),
            DynamicSuperficieTable(
              titleAr: 'مساحات غير منتجة و الغابات',
              titleFr: 'Surfaces improductives et forêts',
              prefix: 'sup_other',
              options: otherSurfaces,
              addTextAr: 'إضافة صنف',
              addTextFr: 'Ajouter',
            ),
            const SizedBox(height: 32),

            // 5. Résultats de Superficie (Totals)
            _blackTitle(
              isAr
                  ? '5. النتائج الإجمالية للمساحة'
                  : '5. Résultats de superficie',
            ),
            _totalsSection(prov, isAr),
            const SizedBox(height: 32),

            // Organization and Means sections (6-9)
            const OrganisationMoyensForm(),

            const SizedBox(height: 100),
          ],
        ),
      ),
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

  Widget _totalsSection(QuestionnaireProvider prov, bool isAr) {
    return Container(
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
      child: Column(
        children: [
          _totalRow(
            isAr
                ? '51. المساحة الفلاحية المستخدمة (SAU)'
                : '51. Superficie agricole utile (SAU)',
            's51_sau',
            prov,
          ),
          const Divider(height: 24),
          _totalRow(
            isAr
                ? '54. المساحة الفلاحية الإجمالية (SAT)'
                : '54. Superficie agricole totale (SAT)',
            's54_sat',
            prov,
          ),
          const Divider(height: 24),
          _totalRow(
            isAr ? '56. المساحة الإجمالية (ST)' : '56. Surface totale (ST)',
            's56_st',
            prov,
          ),
        ],
      ),
    );
  }

  Widget _totalRow(String label, String key, QuestionnaireProvider prov) {
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
        Container(
          width: 120,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFF0F4F2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.2)),
          ),
          child: TextFormField(
            key: Key(prov.values[key]?.toString() ?? ''),
            textAlign: TextAlign.center,
            initialValue: prov.values[key]?.toString() ?? '',
            keyboardType: TextInputType.number,
            onChanged: (v) => prov.updateValue(key, v),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: Color(0xFF2E7D32),
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
              hintText: 'Ha',
              hintStyle: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}
