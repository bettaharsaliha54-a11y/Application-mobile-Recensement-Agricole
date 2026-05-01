import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/language_provider.dart';
import '../../../providers/questionnaire_provider.dart';

const _green = Color(0xFF2E7D32);

class BatimentsV7Form extends StatelessWidget {
  const BatimentsV7Form({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final prov = context.watch<QuestionnaireProvider>();
    final isAr = lang.isArabic;

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            _headerNote(
              isAr
                  ? 'استغلال المباني الفلاحية بطريقة:'
                  : 'Mode d\'exploitation des bâtiments:',
            ),
            const SizedBox(height: 8),
            _modeSelection(context, prov),
            const SizedBox(height: 16),
            _tableHeader(isAr, isAr ? 'المساحة (م²)' : 'Surface (m²)'),
            _subTitle(isAr ? 'المباني السكنية' : 'Bâtiments d\'habitation'),
            _batRow(lang, 'مبان سكنية', 'Habitation', 'bat_habit', prov),
            const SizedBox(height: 12),
            _subTitle(isAr ? 'مباني تربية الحيوانات' : 'Bâtiments d\'élevage'),
            _batRow(lang, 'حظيرة', 'Bergerie', 'bat_bergerie', prov),
            _batRow(lang, 'إسطبل', 'Étable', 'bat_etable', prov),
            _batRow(lang, 'إسطبل الخيول', 'Écurie', 'bat_ecurie', prov),
            _batRow(
              lang,
              'مدجنة (مبنى صلب)',
              'Poulailler (dur)',
              'bat_poulailler_dur',
              prov,
            ),
            _batRow(
              lang,
              'مدجنة (بيوت بلاستيكية)',
              'Poulailler (serre)',
              'bat_poulailler_serre',
              prov,
            ),
            _batRow(
              lang,
              'بيوت بلاستيكية نفق',
              'Serres tunnels',
              'bat_serre_tunnel',
              prov,
            ),
            _batRow(
              lang,
              'بيوت متعددة القباب',
              'Serres multichapelles',
              'bat_serre_multi',
              prov,
            ),
            const SizedBox(height: 12),
            _subTitle(
              isAr ? 'مباني التخزين والتحويل' : 'Stockage et Transformation',
            ),
            _batRow(lang, 'مباني التخزين', 'Stockage', 'bat_stockage', prov),
            _batRow(
              lang,
              'تخزين المنتجات',
              'Produits agric.',
              'bat_stockage_prod',
              prov,
            ),
            _batRow(
              lang,
              'تخزين العتاد',
              'Réserve matériel',
              'bat_remisage_mat',
              prov,
            ),
            _batRow(lang, 'أقبية (Caves)', 'Caves', 'bat_caves', prov),
            _batRow(lang, 'وحدة التوضيب', 'Unité condit.', 'bat_condit', prov),
            _batRow(lang, 'وحدة التحويل', 'Unité transf.', 'bat_transf', prov),
            _batRow(
              lang,
              'مركز جمع الحليب',
              'Centre collecte lait',
              'bat_collecte_lait',
              prov,
            ),
            _batRow(lang, 'مبان أخرى', 'Autres bâtiments', 'bat_autres', prov),
            const SizedBox(height: 12),
            _subTitle(isAr ? 'غرفة التبريد' : 'Chambre froide'),
            _tableHeader(isAr, isAr ? 'السعة (م³)' : 'Capacité (m³)'),
            _batRow(lang, 'غرفة التبريد', 'Chambre froide', 'bat_froid', prov),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _modeSelection(BuildContext context, QuestionnaireProvider prov) {
    bool isAr = Provider.of<LanguageProvider>(context, listen: false).isArabic;
    int current = prov.values['bat_mode_exploitation'] ?? 1;
    return Row(
      children: [
        _modeBtn(isAr ? 'فردية - 1' : 'Individuel', 1, current, prov),
        const SizedBox(width: 12),
        _modeBtn(isAr ? 'جماعية - 2' : 'Collectif', 2, current, prov),
      ],
    );
  }

  Widget _modeBtn(
    String label,
    int val,
    int current,
    QuestionnaireProvider prov,
  ) {
    bool selected = current == val;
    return Expanded(
      child: InkWell(
        onTap: () => prov.updateValue('bat_mode_exploitation', val),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: selected ? _green : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: selected ? _green : Colors.grey.shade300),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _subTitle(String title) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
    margin: const EdgeInsets.only(top: 8, bottom: 4),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w900,
        color: _green,
        decoration: TextDecoration.underline,
      ),
    ),
  );

  Widget _headerNote(String text) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: _green.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: _green.withValues(alpha: 0.2)),
    ),
    child: Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _green,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _tableHeader(bool isAr, String col3) => Container(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
    decoration: BoxDecoration(
      color: _green.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            isAr ? 'نوع المبنى' : 'Type',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: _green,
            ),
          ),
        ),
        Expanded(
          child: Text(
            isAr ? 'العدد' : 'Nombre',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: _green,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            col3,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: _green,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _batRow(
    LanguageProvider lang,
    String ar,
    String fr,
    String key,
    QuestionnaireProvider prov,
  ) => Container(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
    ),
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            lang.t(ar, fr),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2C3E50),
            ),
          ),
        ),
        Expanded(
          child: _inputBox(
            prov.values['${key}_nb'],
            (v) => prov.updateValue('${key}_nb', int.tryParse(v)),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _inputBox(
            prov.values['${key}_surf'],
            (v) => prov.updateValue('${key}_surf', double.tryParse(v)),
          ),
        ),
      ],
    ),
  );

  Widget _inputBox(dynamic val, Function(String) fn) => Container(
    height: 38,
    decoration: BoxDecoration(
      color: const Color(0xFFF0F4F2),
      borderRadius: BorderRadius.circular(8),
    ),
    child: TextFormField(
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
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: _green,
      ),
    ),
  );
}
