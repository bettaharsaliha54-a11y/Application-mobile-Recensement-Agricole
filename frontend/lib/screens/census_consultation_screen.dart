import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../core/theme/app_theme.dart';

class CensusConsultationScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  final String date;
  final VoidCallback? onConfirm;
  final VoidCallback? onBackToStart;

  const CensusConsultationScreen({
    super.key,
    required this.data,
    required this.date,
    this.onConfirm,
    this.onBackToStart,
  });

  @override
  Widget build(BuildContext context) {
    final isAr = context.watch<LanguageProvider>().isArabic;
    final green = const Color(0xFF2E7D32);

    return Scaffold(
      backgroundColor: AppTheme.surfaceLight,
      appBar: AppBar(
        title: Text(
          isAr ? 'مراجعة بيانات الاستبيان' : 'Révision du Questionnaire',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: green,
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoCard(isAr, green),
              const SizedBox(height: 20),

              _sectionHeader(
                isAr
                    ? '1. هوية المستغل والمستثمرة'
                    : '1. Identité & Exploitation',
                green,
              ),
              _dataCard([
                _row(
                  isAr ? 'الاسم' : 'Nom',
                  isAr
                      ? (data['nom_ar'] ?? data['nom_fr'])
                      : (data['nom_fr'] ?? data['nom_ar']),
                ),
                _row(
                  isAr ? 'اللقب' : 'Prénom',
                  isAr
                      ? (data['prenom_ar'] ?? data['prenom_fr'])
                      : (data['prenom_fr'] ?? data['prenom_ar']),
                ),
                _row(isAr ? 'رقم التعريف الوطني' : 'NIN', data['nin']),
                _row(
                  isAr ? 'اسم المستثمرة' : 'Nom exploitation',
                  isAr
                      ? (data['nom_exploitation_ar'] ??
                            data['nom_exploitation_fr'])
                      : (data['nom_exploitation_fr'] ??
                            data['nom_exploitation_ar']),
                ),
                _row(isAr ? 'المكان المسمى' : 'Lieu dit', data['lieu_dit']),
              ]),

              _sectionHeader(
                isAr
                    ? '2. المساحات واستخدام الأراضي'
                    : '2. Surfaces & Utilisation',
                green,
              ),
              _dataCard([
                _row(
                  'SAU',
                  data['s51_sau'] != null ? '${data['s51_sau']} Ha' : null,
                ),
                _row(
                  'SAT',
                  data['s54_sat'] != null ? '${data['s54_sat']} Ha' : null,
                ),
                _row(
                  'ST',
                  data['s56_st'] != null ? '${data['s56_st']} Ha' : null,
                ),
              ]),

              _sectionHeader(
                isAr
                    ? '3. الإنتاج النباتي (المحاصيل)'
                    : '3. Production Végétale',
                green,
              ),
              _dynamicTableData([
                'gc',
                'ls',
                'fr',
                'mr',
                'ci',
                'ar',
                'dv',
                'ae',
                'oa',
              ], isAr),

              _sectionHeader(
                isAr ? '4. الإنتاج الحيواني (الثروة)' : '4. Production Animale',
                green,
              ),
              _dynamicTableData(['bv', 'oc', 'cm', 'eq', 'av', 'ap'], isAr),

              _sectionHeader(
                isAr ? '5. الموارد المائية والري' : '5. Ressources en Eau',
                green,
              ),
              _dataCard([
                _row(isAr ? 'عدد الآبار' : 'Nombre de puits', data['nb_puits']),
                _row(
                  isAr ? 'نظام الري' : 'Mode d\'irrigation',
                  data['mode_irrigation'],
                ),
              ]),

              _sectionHeader(
                isAr
                    ? '6. المعدات والمباني الفلاحية'
                    : '6. Matériel & Bâtiments',
                green,
              ),
              _dynamicTableData(['mat', 'bat'], isAr),

              _sectionHeader(
                isAr
                    ? '7. اليد العاملة والتمويل'
                    : '7. Main d\'oeuvre & Financement',
                green,
              ),
              _dataCard([
                _row(
                  isAr ? 'عمال دائمون' : 'Permanents',
                  data['mo_permanente'],
                ),
                _row(
                  isAr ? 'عمال موسمين' : 'Saisonniers',
                  data['mo_saisonniere'],
                ),
                _row(
                  isAr ? 'قرض بنكي' : 'Crédit bancaire',
                  data['credit_bancaire'] == 1 ? (isAr ? 'نعم' : 'Oui') : null,
                ),
              ]),

              const SizedBox(height: 40),
              if (onBackToStart != null) ...[
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: OutlinedButton.icon(
                    onPressed: onBackToStart,
                    icon: Icon(Icons.refresh_rounded, color: green),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: green),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    label: Text(
                      isAr ? 'الرجوع لبداية الاستبيان' : 'Retour au début',
                      style: TextStyle(
                        color: green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              if (onConfirm != null) ...[
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    onPressed: onConfirm,
                    icon: const Icon(Icons.check_circle, color: Colors.white),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    label: Text(
                      isAr
                          ? 'تأكيد وحفظ الاستبيان'
                          : 'Confirmer et Sauvegarder',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    isAr
                        ? 'نهاية مراجعة الاستمارة'
                        : 'Fin de révision du formulaire',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dynamicTableData(List<String> prefixes, bool isAr) {
    List<Widget> rows = [];
    for (var prefix in prefixes) {
      int count = int.tryParse(data['${prefix}_count']?.toString() ?? '0') ?? 0;
      for (int i = 0; i < count; i++) {
        final type = data['${prefix}_${i}_type'];
        final v1 = data['${prefix}_${i}_v1'];
        if (type != null && v1 != null) {
          rows.add(_row(type.toString(), v1));
        }
      }
    }
    if (rows.isEmpty)
      return _dataCard([
        _row(
          isAr ? 'لا توجد بيانات' : 'Aucune donnée',
          isAr ? 'لا شيء' : 'Néant',
        ),
      ]);
    return _dataCard(rows);
  }

  Widget _infoCard(bool isAr, Color green) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: green.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, color: green, size: 40),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isAr ? 'استمارة مكتملة' : 'Questionnaire Complété',
                style: TextStyle(fontWeight: FontWeight.bold, color: green),
              ),
              Text(
                isAr ? 'تاريخ الإحصاء: $date' : 'Date: $date',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dataCard(List<Widget> children) {
    bool allEmpty = true;
    for (var child in children) {
      if (child is! SizedBox) {
        allEmpty = false;
        break;
      }
    }
    if (allEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _row(String label, dynamic value) {
    if (value == null ||
        value == '' ||
        value == 0 ||
        value == '0' ||
        value == '0 Ha')
      return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ),
          Text(
            value.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, Color green, {List<String>? keys}) {
    if (keys != null) {
      bool hasData = false;
      for (var k in keys) {
        var v = data[k];
        if (v != null && v != '' && v != 0 && v != '0') {
          hasData = true;
          break;
        }
      }
      if (!hasData) return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8, left: 4, right: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: green,
        ),
      ),
    );
  }
}
