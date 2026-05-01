import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/language_provider.dart';
import '../../../providers/questionnaire_provider.dart';

const _green = Color(0xFF2E7D32);

class ExplVocReseauxForm extends StatelessWidget {
  const ExplVocReseauxForm({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final prov = context.watch<QuestionnaireProvider>();
    final d = prov.values;
    final isAr = lang.isArabic;

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: Column(
        children: [
          _sectionHeader(
            isAr ? 'نشاط المستثمرة ووصولها' : 'Vocation & Accessibilité',
          ),
          _fieldCard([
            _dropdownRow<int>(
              isAr ? 'نشاط المستثمرة' : 'Vocation de l\'exploitation',
              {
                1: isAr ? 'نباتية' : 'Végétale',
                2: isAr ? 'تربية الحيوانات' : 'Animale',
                3: isAr ? 'مختلطة' : 'Mixte',
              },
              d['expl_voc_id'],
              (v) => prov.updateValue('expl_voc_id', v),
            ),
            if (d['expl_voc_id'] == 2 || d['expl_voc_id'] == 3)
              _dropdownRow<int>(
                isAr ? 'إذا كان النشاط تربية حيوانات' : 'Si vocation animale',
                {
                  1: isAr ? 'لديه أرض' : 'Avec terre',
                  2: isAr ? 'بدون أرض' : 'Sans terre',
                },
                d['expl_anim_land_id'],
                (v) => prov.updateValue('expl_anim_land_id', v),
              ),
            _dropdownRow<int>(
              isAr ? 'إمكانية الوصول إلى المستثمرة' : 'Accessibilité',
              {
                1: isAr ? 'طريق وطني' : 'Route nationale',
                2: isAr ? 'طريق ولائي' : 'Chemin de wilaya',
                3: isAr ? 'طريق بلدي' : 'Route communale',
                4: isAr ? 'مسار ريفي' : 'Piste rurale',
                5: isAr ? 'مسار فلاحي' : 'Piste agricole',
                6: isAr ? 'مدخل' : 'Accès',
              },
              d['expl_access_id'],
              (v) => prov.updateValue('expl_access_id', v),
            ),
          ]),
          const SizedBox(height: 16),
          _sectionHeader(isAr ? 'الشبكات والاتصال' : 'Réseaux & Connexion'),
          _fieldCard([
            _yesNoRow(
              isAr
                  ? 'هل المستثمرة متصلة بشبكة الكهرباء؟'
                  : 'Connectée au réseau électrique?',
              'expl_elec',
              prov,
              isAr,
            ),
            const Divider(height: 12),
            _yesNoRow(
              isAr
                  ? 'هل المستثمرة متصلة بشبكة الهاتف؟'
                  : 'Connectée au réseau téléphonique?',
              'expl_tel',
              prov,
              isAr,
            ),
            if (prov.values['expl_tel'] == 1)
              _dropdownRow<int>(
                isAr ? 'نوع الهاتف' : 'Type de téléphone',
                {1: isAr ? 'نقال' : 'Mobile', 2: isAr ? 'هاتف ثابت' : 'Fixe'},
                d['expl_tel_type_id'],
                (v) => prov.updateValue('expl_tel_type_id', v),
              ),
            const Divider(height: 12),
            _yesNoRow(
              isAr
                  ? 'هل المستثمرة متصلة بشبكة الإنترنت؟'
                  : 'Connectée au réseau internet?',
              'expl_net',
              prov,
              isAr,
            ),
            if (prov.values['expl_net'] == 1)
              _yesNoRow(
                isAr
                    ? 'هل تستخدم الإنترنت لأغراض فلاحية؟'
                    : 'Internet pour besoins agricoles?',
                'expl_net_agri',
                prov,
                isAr,
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

  Widget _dropdownRow<T>(
    String label,
    Map<T, String> items,
    T? val,
    Function(T?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 4,
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4F2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<T>(
                  value: items.containsKey(val) ? val : null,
                  isExpanded: true,
                  iconSize: 20,
                  iconEnabledColor: _green,
                  items: items.entries
                      .map(
                        (e) => DropdownMenuItem<T>(
                          value: e.key,
                          child: Text(
                            e.value,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: onChanged,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _yesNoRow(
    String label,
    String key,
    QuestionnaireProvider prov,
    bool isAr,
  ) {
    int val = prov.values[key] ?? 0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
          _btn(isAr ? 'نعم' : 'Oui', 1, val, (n) => prov.updateValue(key, n)),
          const SizedBox(width: 8),
          _btn(isAr ? 'لا' : 'Non', 2, val, (n) => prov.updateValue(key, n)),
        ],
      ),
    );
  }

  Widget _btn(String t, int v, int cur, Function(int) onS) {
    bool active = v == cur;
    return InkWell(
      onTap: () => onS(v),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: active ? _green : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: active ? _green : Colors.grey.shade300),
        ),
        child: Text(
          t,
          style: TextStyle(
            color: active ? Colors.white : Colors.black87,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
