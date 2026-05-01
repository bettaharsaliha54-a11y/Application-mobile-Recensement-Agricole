import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../providers/questionnaire_provider.dart';
import '../core/theme/app_theme.dart';
import '../models/exploitation.dart';
import '../core/database/database_helper.dart';
import 'sections/exploitation_form.dart';
import 'rga_stepper_screen.dart';

class CensusScreen extends StatefulWidget {
  final Exploitation exploitation;
  const CensusScreen({super.key, required this.exploitation});

  @override
  State<CensusScreen> createState() => _CensusScreenState();
}

class _CensusScreenState extends State<CensusScreen> {
  Map<String, dynamic>? _exploitantData;
  Map<String, dynamic>? _wilayaData;
  Map<String, dynamic>? _communeData;
  Map<String, dynamic>? _superficiesData;
  int _culturesCount = 0;
  int _bovinsCount = 0;
  int _ruminantsCount = 0;
  int _materielCount = 0;
  int _laborCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    try {
      final db = await DatabaseHelper.instance.database;

      // 1. تحميل بيانات المستثمر
      final exploitantResult = await db.query(
        'exploitants',
        where: 'id = ?',
        whereArgs: [widget.exploitation.exploitantId],
      );

      // 2. تحميل بيانات الموقع (ولاية/بلدية)
      final communeResult = await db.query(
        'communes',
        where: 'id = ?',
        whereArgs: [widget.exploitation.communeId],
      );

      Map<String, dynamic>? wilaya;
      if (communeResult.isNotEmpty) {
        final wilayaResult = await db.query(
          'wilayas',
          where: 'id = ?',
          whereArgs: [communeResult.first['wilaya_id']],
        );
        if (wilayaResult.isNotEmpty) wilaya = wilayaResult.first;
      }

      // 3. تحميل الإحصاء المرتبط بهذه المستثمرة
      final recensementResult = await db.query(
        'recensements',
        where: 'exploitation_id = ?',
        whereArgs: [widget.exploitation.id],
      );

      int? recensementId;
      if (recensementResult.isNotEmpty) {
        recensementId = recensementResult.first['id'] as int;
      }

      int culturesCount = 0;
      int bovinsCount = 0;
      int ruminantsCount = 0;
      int materielCount = 0;
      int laborCount = 0;

      if (recensementId != null) {
        final superficiesResult = await db.query(
          'superficies',
          where: 'recensement_id = ?',
          whereArgs: [recensementId],
        );

        final culturesRes = await db.query(
          'cultures',
          where: 'recensement_id = ?',
          whereArgs: [recensementId],
        );
        final arbresRes = await db.query(
          'arbres',
          where: 'recensement_id = ?',
          whereArgs: [recensementId],
        );
        culturesCount = culturesRes.length + arbresRes.length;

        final bovinsRes = await db.query(
          'bovins',
          where: 'recensement_id = ?',
          whereArgs: [recensementId],
        );
        bovinsCount = bovinsRes.length;

        final cheptelRes = await db.query(
          'cheptel',
          where: 'recensement_id = ?',
          whereArgs: [recensementId],
        );
        ruminantsCount = cheptelRes.length;

        final materielRes = await db.query(
          'materiels',
          where: 'recensement_id = ?',
          whereArgs: [recensementId],
        );
        materielCount = materielRes.length;

        final laborRes = await db.query(
          'main_oeuvre',
          where: 'recensement_id = ?',
          whereArgs: [recensementId],
        );
        laborCount = laborRes.length;

        if (mounted) {
          setState(() {
            _superficiesData = superficiesResult.isNotEmpty
                ? superficiesResult.first
                : null;
          });
        }
      }

      if (mounted) {
        setState(() {
          _exploitantData = exploitantResult.isNotEmpty
              ? exploitantResult.first
              : null;
          _communeData = communeResult.isNotEmpty ? communeResult.first : null;
          _wilayaData = wilaya;
          _culturesCount = culturesCount;
          _bovinsCount = bovinsCount;
          _ruminantsCount = ruminantsCount;
          _materielCount = materielCount;
          _laborCount = laborCount;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isAr = lang.isArabic;
    final e = widget.exploitation;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: AppTheme.primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isAr ? 'بطاقة الإحصاء' : 'Fiche de recensement',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryGreen),
            )
          : Directionality(
              textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ─── بطاقة المستثمرة ───
                    _buildSectionHeader(
                      icon: Icons.business_rounded,
                      title: isAr
                          ? 'معلومات المستثمرة'
                          : 'Informations de l\'exploitation',
                      color: AppTheme.primaryGreen,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard([
                      _infoRow(
                        icon: Icons.label_outline,
                        label: isAr ? 'الاسم' : 'Nom',
                        value: isAr
                            ? (e.nomExploitationAr ?? '—')
                            : (e.nomExploitationFr ?? '—'),
                      ),
                      _infoRow(
                        icon: Icons.qr_code_rounded,
                        label: isAr ? 'الرمز' : 'Code',
                        value: e.code ?? '—',
                        isCode: true,
                      ),
                      _infoRow(
                        icon: Icons.location_on_rounded,
                        label: isAr ? 'الموقع الجغرافي' : 'Localisation',
                        value:
                            '${_wilayaData != null ? (isAr ? _wilayaData!['nom_ar'] : _wilayaData!['nom_fr']) : ''} - ${_communeData != null ? (isAr ? _communeData!['nom_ar'] : _communeData!['nom_fr']) : ''}',
                      ),
                    ]),

                    const SizedBox(height: 24),

                    // ─── بطاقة المستثمر ───
                    _buildSectionHeader(
                      icon: Icons.person_rounded,
                      title: isAr
                          ? 'معلومات المستثمر'
                          : 'Informations de l\'exploitant',
                      color: Colors.teal,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard([
                      _infoRow(
                        icon: Icons.badge_rounded,
                        label: isAr ? 'الاسم واللقب' : 'Nom et prénom',
                        value: _exploitantData != null
                            ? '${_exploitantData!['nom_ar'] ?? ''} ${_exploitantData!['prenom_ar'] ?? ''}'
                                  .trim()
                            : '—',
                      ),
                      _infoRow(
                        icon: Icons.phone_rounded,
                        label: isAr ? 'الهاتف' : 'Téléphone',
                        value: _exploitantData?['telephone']?.toString() ?? '—',
                      ),
                    ]),

                    const SizedBox(height: 24),

                    // ─── ملخص الأنشطة الفلاحية ───
                    _buildSectionHeader(
                      icon: Icons.analytics_rounded,
                      title: isAr
                          ? 'بيانات الأقسام الجارية'
                          : 'Résumé des rubriques',
                      color: Colors.orange.shade800,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard([
                      _infoRow(
                        icon: Icons.grass_rounded,
                        label: isAr ? 'الأرض والمحاصيل' : 'Terres et Cultures',
                        value:
                            '$_culturesCount ${isAr ? 'محاصيل' : 'Cultures'}',
                      ),
                      _infoRow(
                        icon: Icons.pets_rounded,
                        label: isAr ? 'الثروة الحيوانية' : 'Cheptel',
                        value:
                            '${_bovinsCount + _ruminantsCount} ${isAr ? 'رؤوس' : 'Têtes'}',
                      ),
                      _infoRow(
                        icon: Icons.handyman_rounded,
                        label: isAr ? 'العتاد والمعدات' : 'Matériel',
                        value: '$_materielCount ${isAr ? 'عناصر' : 'Éléments'}',
                      ),
                    ]),

                    const SizedBox(height: 32),

                    // ─── زر الدخول للاستبيان ───
                    SizedBox(
                      width: double.infinity,
                      height: 80,
                      child: ElevatedButton(
                        onPressed: () {
                          // تفعيل الـ Provider بالمستثمرة المختارة
                          context
                              .read<QuestionnaireProvider>()
                              .setExploitationId(e.id);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RgaStepperScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 8,
                          shadowColor: AppTheme.primaryGreen.withOpacity(0.4),
                        ),
                        child: Text(
                          isAr
                              ? 'بدء الإحصاء الفعلي'
                              : 'Commencer le recensement',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(List<Widget> rows) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(children: rows),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
    bool isCode = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isCode ? AppTheme.primaryGreen : Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
