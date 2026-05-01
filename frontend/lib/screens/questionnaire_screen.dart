import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../providers/questionnaire_provider.dart';
import 'sections/01_exploitant_section.dart';
import 'sections/exploitation_form.dart';
import 'sections/03_superficies_form.dart';
import 'sections/04_cultures_form.dart';
import 'sections/05_cheptel_form.dart';
import 'sections/06_eau_irrigation_form.dart';
import 'sections/07_batiments_materiel_form.dart';
import 'sections/08_main_oeuvre_form.dart';
import 'sections/09_intrants_financement_form.dart';
import 'census_consultation_screen.dart';

class QuestionnaireScreen extends StatelessWidget {
  const QuestionnaireScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<QuestionnaireProvider>();
    final lang = context.watch<LanguageProvider>();

    final List<Widget> sections = [
      ExploitantFormScreen(),
      ExploitationFormScreen(),
      const SuperficiesFormScreen(),
      const CulturesFormScreen(),
      const CheptelFormScreen(),
      const EauIrrigationFormScreen(),
      // Combined Section 7: Material, Labor, Inputs
      SingleChildScrollView(
        child: Column(
          children: [
            const BatimentsMaterielFormScreen(),
            const Divider(),
            const MainOeuvreFormScreen(),
            const Divider(),
            const IntrantsFinancementFormScreen(),
          ],
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.t('استمارة الإحصاء الفلاحي', 'Questionnaire RGA')),
      ),
      body: Column(
        children: [
          Expanded(
            child: sections[prov.currentStep > 6 ? 6 : prov.currentStep],
          ),
          _buildNav(context, prov, lang),
        ],
      ),
    );
  }

  void _showFinishDialog(
    BuildContext context,
    QuestionnaireProvider prov,
    LanguageProvider lang,
  ) {
    final isAr = lang.isArabic;
    final date =
        "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CensusConsultationScreen(
          data: prov.values,
          date: date,
          onBackToStart: () {
            prov.setStep(0);
            Navigator.pop(context);
          },
          onConfirm: () async {
            await prov.saveCensus(context);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isAr ? 'تم حفظ الإحصاء بنجاح' : 'Recensement enregistré',
                  ),
                ),
              );
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/completed_surveys',
                (route) => route.isFirst,
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildNav(
    BuildContext context,
    QuestionnaireProvider prov,
    LanguageProvider lang,
  ) {
    final isAr = lang.isArabic;
    const int totalSteps = 7;
    final int stepIndex = prov.currentStep > 6 ? 6 : prov.currentStep;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (stepIndex > 0)
            ElevatedButton(
              onPressed: () => prov.previousStep(),
              child: Text(lang.t('السابق', 'Précédent')),
            )
          else
            const SizedBox(width: 80),

          Text(
            "${stepIndex + 1} / $totalSteps",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),

          ElevatedButton(
            onPressed: () {
              if (stepIndex < 6) {
                prov.nextStep();
              } else {
                _showFinishDialog(context, prov, lang);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: stepIndex == 6 ? const Color(0xFF2E7D32) : null,
              foregroundColor: stepIndex == 6 ? Colors.white : null,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              stepIndex < 6
                  ? lang.t('التالي', 'Suivant')
                  : lang.t('إنهاء وحفظ', 'Terminer'),
            ),
          ),
        ],
      ),
    );
  }
}
