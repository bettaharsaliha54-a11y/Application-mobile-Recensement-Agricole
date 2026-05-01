import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/language_provider.dart';
import '../../providers/questionnaire_provider.dart';

const _green = Color(0xFF2E7D32);

class IntrantsFinancementFormScreen extends StatelessWidget {
  const IntrantsFinancementFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final prov = context.watch<QuestionnaireProvider>();
    final isAr = lang.isArabic;
    final d = prov.values;

    return Scaffold(
      backgroundColor: AppTheme.surfaceLight,
      body: Directionality(
        textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Utilisation d'intrants
              _sectionHeader(
                isAr ? 'استخدام المدخلات' : 'Utilisation d\'intrants',
                isAr,
              ),
              const SizedBox(height: 12),
              _fieldCard([
                _gridCheckboxes([
                  _checkItem(
                    'sem_select',
                    isAr ? 'بذور مختارة' : 'Semences sélectionnées',
                    prov,
                  ),
                  _checkItem(
                    'sem_certif',
                    isAr ? 'بذور معتمدة' : 'Semences certifiées',
                    prov,
                  ),
                  _checkItem(
                    'sem_ferme',
                    isAr ? 'بذور المزرعة' : 'Semences de ferme',
                    prov,
                  ),
                  _checkItem('bio', isAr ? 'بيولوجية' : 'Bio', prov),
                  _checkItem(
                    'eng_azot',
                    isAr ? 'أسمدة آزوتية' : 'Engrais azotés',
                    prov,
                  ),
                  _checkItem(
                    'eng_phosph',
                    isAr ? 'أسمدة فوسفاتية' : 'Engrais phosphatés',
                    prov,
                  ),
                  _checkItem(
                    'eng_miner',
                    isAr ? 'أسمدة معدنية أخرى' : 'Autres engrais minéraux',
                    prov,
                  ),
                  _checkItem(
                    'fum_org',
                    isAr ? 'سماد عضوي' : 'Fumure organique',
                    prov,
                  ),
                  _checkItem(
                    'phyto',
                    isAr ? 'مبيدات' : 'Phytosanitaires',
                    prov,
                  ),
                ]),
              ]),

              const SizedBox(height: 24),

              // XIII. Financement
              _sectionHeader(
                isAr
                    ? 'تمويل النشاط الفلاحي والتأمينات'
                    : 'Financement & Assurances',
                isAr,
              ),
              const SizedBox(height: 12),

              _fieldCard([
                _subTitle(isAr ? 'التمويل' : 'Financement'),
                _checkItem(
                  'fin_propres',
                  isAr ? 'موارد ذاتية' : 'Propres ressources',
                  prov,
                ),
                _checkItem(
                  'fin_banque',
                  isAr ? 'قرض بنكي' : 'Crédit bancaire',
                  prov,
                ),
                if (d['fin_banque'] == true)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: _gridCheckboxes([
                      _checkItem('cr_rfig', 'RFIG / الرفيق', prov),
                      _checkItem('cr_etta', 'Ettahadi / التحدي', prov),
                      _checkItem('cr_class', 'Classique / الكلاسيكي', prov),
                      _checkItem('cr_leas', 'Leasing / تأجير', prov),
                    ], cols: 2),
                  ),
                _checkItem(
                  'fin_public',
                  isAr ? 'دعم عمومي' : 'Soutien public',
                  prov,
                ),
                if (d['fin_public'] == true)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: _gridCheckboxes([
                      _checkItem(
                        'sup_cult',
                        isAr ? 'محاصيل' : 'Cultures',
                        prov,
                      ),
                      _checkItem('sup_mat', isAr ? 'عتاد' : 'Matériel', prov),
                      _checkItem('sup_fin', isAr ? 'مالي' : 'Financière', prov),
                    ], cols: 2),
                  ),
                _checkItem(
                  'fin_tiers',
                  isAr ? 'استلاف من الغير' : 'Emprunt à un tiers',
                  prov,
                ),
              ]),

              const SizedBox(height: 16),

              _fieldCard([
                _subTitle(isAr ? 'التأمين الفلاحي' : 'Assurance agricole'),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        isAr
                            ? 'هل متعاقد مع تأمين فلاحي؟'
                            : 'Avez-vous une assurance?',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _yesNoSwitch('has_assurance', prov),
                  ],
                ),
                if (d['has_assurance'] == true) ...[
                  const SizedBox(height: 16),
                  _inputRow(
                    isAr ? 'مع أي شركة؟' : 'Quelle compagnie?',
                    'assur_comp',
                    prov,
                    isAr,
                  ),
                  const SizedBox(height: 16),
                  _subTitle(isAr ? 'نوع التأمين' : 'Type d\'assurance'),
                  _gridCheckboxes([
                    _checkItem('as_terre', isAr ? 'الأرض' : 'Terre', prov),
                    _checkItem('as_pers', isAr ? 'العمال' : 'Personnel', prov),
                    _checkItem('as_cult', isAr ? 'المحاصيل' : 'Cultures', prov),
                    _checkItem('as_bat', isAr ? 'المباني' : 'Bâtiments', prov),
                    _checkItem('as_mat', isAr ? 'العتاد' : 'Matériels', prov),
                    _checkItem('as_chep', isAr ? 'المواشي' : 'Cheptel', prov),
                  ], cols: 2),
                ],
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

  Widget _subTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 10),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _gridCheckboxes(List<Widget> items, {int cols = 1}) {
    return Wrap(
      spacing: 10,
      runSpacing: 5,
      children: items
          .map(
            (e) =>
                SizedBox(width: cols == 1 ? double.infinity : (150), child: e),
          )
          .toList(),
    );
  }

  Widget _checkItem(String key, String label, QuestionnaireProvider prov) {
    final bool val = prov.values[key] == true;
    return InkWell(
      onTap: () => prov.updateValue(key, !val),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: val ? _green : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: val ? _green : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: val
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 10),
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
          ],
        ),
      ),
    );
  }

  Widget _yesNoSwitch(String key, QuestionnaireProvider prov) {
    final bool val = prov.values[key] == true;
    return Switch(
      value: val,
      onChanged: (v) => prov.updateValue(key, v),
      activeColor: _green,
    );
  }

  Widget _inputRow(
    String label,
    String key,
    QuestionnaireProvider prov,
    bool isAr,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: TextFormField(
            key: Key(prov.values[key]?.toString() ?? ''),
            initialValue: prov.values[key]?.toString() ?? '',
            onChanged: (v) => prov.updateValue(key, v),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: _green,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}
