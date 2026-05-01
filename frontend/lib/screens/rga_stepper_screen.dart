import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../providers/questionnaire_provider.dart';
import '../providers/exploitant_provider.dart';
import '../providers/language_provider.dart';
import 'sections/03_superficies_form.dart';
import 'sections/04_cultures_form.dart';
import 'sections/05_cheptel_form.dart';
import 'sections/06_eau_irrigation_form.dart';
import 'sections/07_batiments_materiel_form.dart';
import 'sections/08_main_oeuvre_form.dart';
import 'sections/09_intrants_financement_form.dart';

class RgaStepperScreen extends StatefulWidget {
  const RgaStepperScreen({super.key});
  @override
  State<RgaStepperScreen> createState() => _RgaStepperScreenState();
}

class _RgaStepperScreenState extends State<RgaStepperScreen> {
  int _step = 0;
  final _pc = PageController();

  final List<Map<String, String>> _sections = [
    {'ar': '1. المساحات', 'fr': '1. Superficie'},
    {'ar': '2. المحاصيل', 'fr': '2. Cultures'},
    {'ar': '3. الثروة الحيوانية', 'fr': '3. Cheptel'},
    {'ar': '4. الماء والري', 'fr': '4. Eau/Irrigation'},
    {'ar': '5. البنايات والعتاد', 'fr': '5. Bâtiments/Matériel'},
    {'ar': '6. اليد العاملة', 'fr': '6. Main d\'Oeuvre'},
    {'ar': '7. المدخلات والتمويل', 'fr': '7. Intrants/Financement'},
  ];

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isAr = lang.isArabic;
    final primaryColor = const Color(0xFF2E7D32);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          isAr ? 'الاستبيان الفلاحي الشامل' : 'Recensement Agricole',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.grey),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Directionality(
        textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
        child: Column(
          children: [
            _buildCustomStepper(isAr, primaryColor),
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey.shade200,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              child: Row(
                children: [
                  Icon(
                    Icons.dashboard_customize_rounded,
                    color: primaryColor,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isAr ? _sections[_step]['ar']! : _sections[_step]['fr']!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pc,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _step = i),
                children: const [
                  SuperficiesFormScreen(),
                  CulturesFormScreen(),
                  CheptelFormScreen(),
                  EauIrrigationFormScreen(),
                  BatimentsMaterielFormScreen(),
                  MainOeuvreFormScreen(),
                  IntrantsFinancementFormScreen(),
                ],
              ),
            ),
            _buildNav(lang, primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomStepper(bool isAr, Color primaryColor) {
    return Container(
      height: 85,
      width: double.infinity,
      color: const Color(0xFFF9FAFB),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _sections.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          bool isActive = index == _step;
          bool isCompleted = index < _step;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  _pc.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 4,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isActive
                              ? primaryColor
                              : (isCompleted
                                    ? primaryColor.withOpacity(0.2)
                                    : Colors.white),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isActive || isCompleted
                                ? primaryColor
                                : Colors.grey.shade300,
                            width: 2,
                          ),
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                    color: primaryColor.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [],
                        ),
                        child: Center(
                          child: isCompleted
                              ? Icon(
                                  Icons.check_rounded,
                                  color: primaryColor,
                                  size: 20,
                                )
                              : Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: isActive
                                        ? Colors.white
                                        : Colors.grey.shade500,
                                    fontWeight: FontWeight.bold,
                                    fontSize: isActive ? 16 : 14,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        (isAr
                                ? _sections[index]['ar']!
                                : _sections[index]['fr']!)
                            .replaceAll('${index + 1}. ', ''),
                        style: TextStyle(
                          fontSize: isActive ? 11 : 10,
                          fontWeight: isActive
                              ? FontWeight.w900
                              : FontWeight.w600,
                          color: isActive ? primaryColor : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (index < _sections.length - 1)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 15,
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    color: isCompleted ? primaryColor : Colors.grey.shade300,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNav(LanguageProvider lang, Color primaryColor) {
    final isAr = lang.isArabic;
    final isLast = _step == _sections.length - 1;
    final isFirst = _step == 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (!isFirst)
              Expanded(
                child: _btnOutline(
                  lang.t('السابق', 'Précédent'),
                  isAr
                      ? Icons.arrow_forward_ios_rounded
                      : Icons.arrow_back_ios_rounded,
                  () => _pc.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                ),
              ),
            if (!isFirst && !isLast) const SizedBox(width: 12),
            if (!isLast)
              Expanded(
                child: _btnFilled(
                  lang.t('التالي', 'Suivant'),
                  isAr
                      ? Icons.arrow_back_ios_rounded
                      : Icons.arrow_forward_ios_rounded,
                  primaryColor,
                  () {
                    FocusScope.of(context).unfocus(); // hide keyboard
                    _pc.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ),
            if (isLast) ...[
              if (!isFirst) const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () => _save(context, lang),
                    icon: const Icon(
                      Icons.check_circle_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                    label: Text(
                      lang.t('إنهاء وحفظ', 'Terminer & Sauvegarder'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryForestGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 4,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _btnFilled(String lbl, IconData icon, Color bg, VoidCallback fn) =>
      SizedBox(
        height: 56,
        child: ElevatedButton.icon(
          onPressed: fn,
          icon: Icon(icon, size: 20, color: Colors.white),
          label: Text(
            lbl,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: bg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 2,
          ),
        ),
      );

  Widget _btnOutline(String lbl, IconData icon, VoidCallback fn) => SizedBox(
    height: 56,
    child: OutlinedButton.icon(
      onPressed: fn,
      icon: Icon(icon, size: 20, color: const Color(0xFF1F2937)),
      label: Text(
        lbl,
        style: const TextStyle(
          color: Color(0xFF1F2937),
          fontWeight: FontWeight.w900,
          fontSize: 16,
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.grey.shade400, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        backgroundColor: const Color(0xFFF9FAFB),
      ),
    ),
  );

  Future<void> _save(BuildContext ctx, LanguageProvider lang) async {
    // Save directly as requested

    // 2. Show loading
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryForestGreen),
      ),
    );

    // 3. Save to DB
    await context.read<QuestionnaireProvider>().saveCensus(context);

    if (!mounted) return;

    // 4. Close loading + RGA screen → Go to Completed Census list
    Navigator.pop(context); // Close loading dialog
    Navigator.pushReplacementNamed(context, '/completed_census');

    // 5. Show success snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          lang.isArabic
              ? '✅ تم حفظ الاستمارة وإضافتها إلى المكتملة!'
              : '✅ Questionnaire sauvegardé avec succès!',
        ),
        backgroundColor: AppTheme.primaryForestGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
