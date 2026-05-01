import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/language_provider.dart';
import '../../providers/questionnaire_provider.dart';
import '08_sub/dynamic_labor_table.dart';

const _green = Color(0xFF2E7D32);

class MainOeuvreFormScreen extends StatelessWidget {
  const MainOeuvreFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final prov = context.watch<QuestionnaireProvider>();
    final isAr = lang.isArabic;

    const List<Map<String, String>> laborOptions = [
      {
        'ar': 'مساعد المستثمر (مع المستثمر الرئيسي)',
        'fr': 'Co-exploitants (y.c. principal)',
      },
      {'ar': 'العمال الفلاحين', 'fr': 'Ouvriers agricoles'},
      {'ar': 'العمال الفلاحين الأجانب', 'fr': 'Ouvriers agricoles étrangers'},
      {'ar': 'فلاح أو مستثمر فردي', 'fr': 'Exploitant individuel'},
      {'ar': 'كبار (أكثر من 15 سنة)', 'fr': 'Adultes (+15 ans)'},
      {'ar': 'أطفال (أقل من 15 سنة)', 'fr': 'Enfants (-15 ans)'},
      {
        'ar': 'عدد الأعضاء الناشطين أو الأسر',
        'fr': 'Nombre d\'actifs ou ménages',
      },
      {
        'ar': 'منها العمال خارج المستثمرة',
        'fr': 'Dont travaillant hors exploitation',
      },
      {'ar': 'بدون عمل', 'fr': 'Sans emploi'},
      {
        'ar': 'منها المستفيدين من الشبكة الاجتماعية',
        'fr': 'Dont bénéficiant du filet social',
      },
    ];

    return Scaffold(
      backgroundColor: AppTheme.surfaceLight,
      body: Directionality(
        textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // X. Main d'oeuvre
              DynamicLaborTable(
                titleAr: 'اليد العاملة في المستثمرة',
                titleFr: 'Main d\'œuvre de l\'exploitation',
                prefix: 'labor',
                options: laborOptions,
                addTextAr: 'إضافة فئة عاملة',
                addTextFr: 'Ajouter une catégorie',
              ),

              const SizedBox(height: 10),

              // XI. Ménage agricole
              _sectionHeader(
                isAr ? 'الأسرة الفلاحية' : 'Ménage agricole',
                isAr,
              ),
              const SizedBox(height: 12),
              _fieldCard([
                _inputRow(
                  isAr
                      ? 'عدد أفراد أسرة رئيس المستثمرة'
                      : 'Nombre de personnes (Chef)',
                  'm157_persons',
                  prov,
                  isAr,
                ),
                const Divider(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _subInput(
                        isAr ? 'كبار (+15 سنة)' : 'Adultes',
                        'm158_m',
                        'm158_f',
                        prov,
                        isAr,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _subInput(
                        isAr ? 'أطفال (-15 سنة)' : 'Enfants',
                        'm159_m',
                        'm159_f',
                        prov,
                        isAr,
                      ),
                    ),
                  ],
                ),
              ]),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
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
              ? const BorderSide(color: _green, width: 5)
              : BorderSide.none,
          left: !isAr
              ? const BorderSide(color: _green, width: 5)
              : BorderSide.none,
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w900,
          color: _green,
        ),
      ),
    );
  }

  Widget _fieldCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _inputRow(
    String label,
    String key,
    QuestionnaireProvider prov,
    bool isAr,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        Container(
          width: 80,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFF0F4F2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            key: Key(prov.values[key]?.toString() ?? ''),
            textAlign: TextAlign.center,
            initialValue: prov.values[key]?.toString() ?? '',
            keyboardType: TextInputType.number,
            onChanged: (v) => prov.updateValue(key, v),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: _green,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 11),
            ),
          ),
        ),
      ],
    );
  }

  Widget _subInput(
    String label,
    String keyM,
    String keyF,
    QuestionnaireProvider prov,
    bool isAr,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: _green,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _smallIn(keyM, isAr ? 'ذكر' : 'Masculin', prov)),
            const SizedBox(width: 4),
            Expanded(child: _smallIn(keyF, isAr ? 'أنثى' : 'Féminin', prov)),
          ],
        ),
      ],
    );
  }

  Widget _smallIn(String key, String hint, QuestionnaireProvider prov) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAF9),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: TextFormField(
        key: Key(prov.values[key]?.toString() ?? ''),
        textAlign: TextAlign.center,
        initialValue: prov.values[key]?.toString() ?? '',
        keyboardType: TextInputType.number,
        onChanged: (v) => prov.updateValue(key, v),
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ),
    );
  }
}
