import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/questionnaire_provider.dart';
import '../providers/language_provider.dart';
import '../core/theme/app_theme.dart';
import 'sections/exploitant_form.dart';
import 'sections/exploitation_form.dart';

class QuestionnaireStepper extends StatelessWidget {
  const QuestionnaireStepper({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuestionnaireProvider>();
    final lang = context.watch<LanguageProvider>();
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    // أقسام الاستبيان الـ 9
    final List<Widget> sections = [
      const ExploitantFormScreen(),
      const ExploitationFormScreen(),
      Center(
        child: Text(
          lang.t(
            'القسم 3: المساحات (قيد التطوير...)',
            'Section 3: Superficies (En cours...)',
          ),
        ),
      ),
      Center(
        child: Text(
          lang.t(
            'القسم 4: المحاصيل (قيد التطوير...)',
            'Section 4: Cultures (En cours...)',
          ),
        ),
      ),
      Center(
        child: Text(
          lang.t(
            'القسم 5: الثروة الحيوانية (قيد التطوير...)',
            'Section 5: Elevage/Cheptel (En cours...)',
          ),
        ),
      ),
      Center(
        child: Text(
          lang.t(
            'القسم 6: المباني (قيد التطوير...)',
            'Section 6: Bâtiments (En cours...)',
          ),
        ),
      ),
      Center(
        child: Text(
          lang.t(
            'القسم 7: المياه (قيد التطوير...)',
            'Section 7: Eau (En cours...)',
          ),
        ),
      ),
      Center(
        child: Text(
          lang.t(
            'القسم 8: اليد العاملة (قيد التطوير...)',
            'Section 8: Main doeuvre (En cours...)',
          ),
        ),
      ),
      Center(
        child: Text(
          lang.t(
            'القسم 9: المدخلات (قيد التطوير...)',
            'Section 9: Intrants (En cours...)',
          ),
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(
          lang.t(
            'التعداد - المرحلة ${provider.currentStepIndex + 1} / 9',
            'Recensement - Étape ${provider.currentStepIndex + 1} / 9',
          ),
          style: const TextStyle(color: AppTheme.primaryForestGreen),
        ),
        backgroundColor: AppTheme.surfaceLight,
        iconTheme: const IconThemeData(color: AppTheme.primaryForestGreen),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                '${((provider.currentStepIndex + 1) / 9 * 100).toInt()}%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryForestGreen,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: isDesktop ? 700 : size.width * 0.95,
          margin: const EdgeInsets.symmetric(vertical: 24.0),
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            children: [
              // Progress Bar
              LinearProgressIndicator(
                value: (provider.currentStepIndex + 1) / 9,
                backgroundColor: AppTheme.surfaceTonal1,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppTheme.primaryForestGreen,
                ),
              ),

              // Form Content
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: sections[provider.currentStepIndex],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
