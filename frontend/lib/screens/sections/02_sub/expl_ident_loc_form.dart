import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/language_provider.dart';
import '../../../providers/questionnaire_provider.dart';
import '../../../core/database/database_helper.dart';

const _green = Color(0xFF2E7D32);

class ExplIdentLocForm extends StatefulWidget {
  const ExplIdentLocForm({super.key});

  @override
  State<ExplIdentLocForm> createState() => _ExplIdentLocFormState();
}

class _ExplIdentLocFormState extends State<ExplIdentLocForm> {
  List<Map<String, dynamic>> _wilayas = [];

  @override
  void initState() {
    super.initState();
    _loadWilayas();
  }

  Future<void> _loadWilayas() async {
    final list = await DatabaseHelper.instance.readAllWilayas();
    setState(() => _wilayas = list);
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final prov = context.watch<QuestionnaireProvider>();
    final d = prov.values;
    final isAr = lang.isArabic;

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _blackTitle(isAr ? '1. صاحب المستثمرة' : '1. Propriétaire'),
          _card([
            _inputRow(
              isAr ? 'اسم المستثمر' : 'Nom de l\'exploitant',
              d['owner_name'] ?? '',
              (v) => prov.updateValue('owner_name', v),
              isAr,
            ),
          ]),
          const SizedBox(height: 20),

          _blackTitle(
            isAr ? '2. تحديد الهوية والموقع' : '2. Identification & Site',
          ),
          _card([
            _inputRow(
              isAr ? 'اسم المستثمرة' : 'Nom de l\'exploitation',
              d['nom_exploitation_ar'] ?? '',
              (v) => prov.updateValue('nom_exploitation_ar', v),
              isAr,
            ),
            const Divider(height: 24),
            _dropdownRow<int>(
              isAr ? 'الولاية' : 'Wilaya',
              _wilayas
                  .map(
                    (w) => DropdownMenuItem(
                      value: w['id'] as int,
                      child: Text(
                        isAr ? w['nom_ar'] : w['nom_fr'],
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              d['wilaya_id'],
              (v) => prov.updateValue('wilaya_id', v),
              isAr,
            ),
            const Divider(height: 24),
            _inputRow(
              isAr ? 'المكان المسمى / الدوار' : 'Lieu-dit / District',
              d['lieu_dit'] ?? '',
              (v) => prov.updateValue('lieu_dit', v),
              isAr,
            ),
          ]),
          const SizedBox(height: 20),

          _blackTitle(isAr ? '3. الإحداثيات الجغرافية' : '3. Coordonnées GPS'),
          _card([
            Row(
              children: [
                Expanded(
                  child: _inputRow(
                    'X (Lat)',
                    d['latitude']?.toString() ?? '',
                    (v) => prov.updateValue('latitude', double.tryParse(v)),
                    isAr,
                    isNum: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _inputRow(
                    'Y (Lon)',
                    d['longitude']?.toString() ?? '',
                    (v) => prov.updateValue('longitude', double.tryParse(v)),
                    isAr,
                    isNum: true,
                  ),
                ),
              ],
            ),
          ]),
          const SizedBox(height: 20),

          _blackTitle(isAr ? '4. النشاط والقانون' : '4. Activité & Statut'),
          _card([
            _dropdownRow<int>(
              isAr ? 'الوضع القانوني' : 'Statut Juridique',
              (isAr
                      ? ['شخص طبيعي', 'شركة مدنية', 'EAI', 'EAC', 'أخرى']
                      : ['Physique', 'Société', 'EAI', 'EAC', 'Autre'])
                  .asMap()
                  .entries
                  .map(
                    (e) => DropdownMenuItem(
                      value: e.key + 1,
                      child: Text(
                        e.value,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              d['statut_juridique_id'],
              (v) => prov.updateValue('statut_juridique_id', v),
              isAr,
            ),
            const Divider(height: 24),
            _dropdownRow<int>(
              isAr ? 'النشاط الرئيسي' : 'Activité Principale',
              (isAr
                      ? ['نباتي', 'حيواني', 'مختلط']
                      : ['Végétale', 'Animale', 'Mixte'])
                  .asMap()
                  .entries
                  .map(
                    (e) => DropdownMenuItem(
                      value: e.key + 1,
                      child: Text(
                        e.value,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              d['activite_exploitation_id'],
              (v) => prov.updateValue('activite_exploitation_id', v),
              isAr,
            ),
          ]),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _blackTitle(String t) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        t,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w900,
          color: Colors.black,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _card(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _inputRow(
    String label,
    String val,
    Function(String) onChanged,
    bool isAr, {
    bool isNum = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 45,
          decoration: BoxDecoration(
            color: const Color(0xFFF0F4F2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            key: Key(label),
            initialValue: val,
            keyboardType: isNum
                ? const TextInputType.numberWithOptions(decimal: true)
                : TextInputType.text,
            onChanged: onChanged,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: _green,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dropdownRow<T>(
    String label,
    List<DropdownMenuItem<T>> items,
    T? val,
    Function(T?) onC,
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
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 45,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F4F2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: val,
              items: items,
              onChanged: onC,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: _green),
            ),
          ),
        ),
      ],
    );
  }
}
