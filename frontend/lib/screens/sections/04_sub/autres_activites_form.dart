import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/language_provider.dart';
import '../../../providers/questionnaire_provider.dart';

const _green = Color(0xFF2E7D32);
const _red = Color(0xFFD32F2F);

/// القسم الفرعي 9: أنشطة زراعية أخرى (Autres activités agricoles)
class AutresActivitesForm extends StatefulWidget {
  const AutresActivitesForm({super.key});

  @override
  State<AutresActivitesForm> createState() => _AutresActivitesFormState();
}

class _AutresActivitesFormState extends State<AutresActivitesForm> {
  // Local state for yes/no buttons — null = not selected
  final Map<String, bool?> _answers = {
    'act_bio': null,
    'act_bio_certif': null,
    'act_aqua': null,
    'act_helici': null,
    'act_myci': null,
    'act_convention': null,
  };

  // Local state for checkboxes
  final Map<String, bool> _checks = {
    'fil_tomate_ind': false,
    'fil_cereales': false,
    'fil_aviculture': false,
    'fil_maraichage': false,
    'fil_pdt': false,
    'fil_autre': false,
  };

  void _setAnswer(String key, bool val) {
    setState(() => _answers[key] = val);
    // sync to provider
    final prov = context.read<QuestionnaireProvider>();
    prov.updateValue(key, val);
  }

  void _toggleCheck(String key) {
    setState(() => _checks[key] = !(_checks[key] ?? false));
    final prov = context.read<QuestionnaireProvider>();
    prov.updateValue(key, _checks[key]);
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isAr = lang.isArabic;

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerNote(
              isAr
                  ? 'حدد الأنشطة الزراعية الإضافية التي تمارسها'
                  : 'Indiquez les activités agricoles supplémentaires pratiquées',
            ),
            const SizedBox(height: 16),

            _questionCard(
              question: lang.t(
                'هل تمارس الزراعة البيولوجية في المستثمرة؟',
                'Pratiquez-vous l\'agriculture biologique ?',
              ),
              answerKey: 'act_bio',
              isAr: isAr,
            ),
            if (_answers['act_bio'] == true) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(right: 16, left: 16),
                child: _questionCard(
                  question: lang.t(
                    'هل لديك شهادة بيولوجية؟',
                    'Avez-vous un certificat biologique ?',
                  ),
                  answerKey: 'act_bio_certif',
                  isAr: isAr,
                  isSubQuestion: true,
                ),
              ),
            ],
            const SizedBox(height: 10),

            _questionCard(
              question: lang.t(
                'هل تمارس تربية الأحياء المائية المدمجة مع الفلاحة؟',
                'Pratiquez-vous l\'aquaculture intégrée à l\'agriculture ?',
              ),
              answerKey: 'act_aqua',
              isAr: isAr,
            ),
            const SizedBox(height: 10),

            _questionCard(
              question: lang.t(
                'هل تمارس تربية الحلزون؟',
                'Pratiquez-vous l\'Héliciculture ?',
              ),
              answerKey: 'act_helici',
              isAr: isAr,
            ),
            const SizedBox(height: 10),

            _questionCard(
              question: lang.t(
                'هل تمارس زراعة الفطر؟',
                'Pratiquez-vous la Myciculture ?',
              ),
              answerKey: 'act_myci',
              isAr: isAr,
            ),
            const SizedBox(height: 10),

            _questionCard(
              question: lang.t(
                'هل تمارس الزراعة المحمية؟',
                'Pratiquez-vous une agriculture conventionnée ?',
              ),
              answerKey: 'act_convention',
              isAr: isAr,
            ),
            const SizedBox(height: 20),

            // ─── Filières section ───
            _sectionTitle(
              isAr ? 'إذا كان نعم، أي شعبة؟' : 'Si oui, quelle(s) filière(s) ?',
            ),
            const SizedBox(height: 10),
            _checkboxCard(
              isAr: isAr,
              items: [
                ('طماطم صناعية', 'Tomate Industrielle', 'fil_tomate_ind'),
                ('الحبوب', 'Céréales', 'fil_cereales'),
                ('تربية الدواجن', 'Aviculture', 'fil_aviculture'),
                ('الخضروات', 'Maraîchages', 'fil_maraichage'),
                ('البطاطا', 'Pomme de terre', 'fil_pdt'),
                ('شعبة أخرى', 'Autre', 'fil_autre'),
              ],
              lang: lang,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ─── Yes/No question card ───
  Widget _questionCard({
    required String question,
    required String answerKey,
    required bool isAr,
    bool isSubQuestion = false,
  }) {
    final selected = _answers[answerKey];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isSubQuestion ? const Color(0xFFF9FAFB) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSubQuestion ? Colors.grey.shade200 : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(
              fontSize: isSubQuestion ? 12 : 13,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 12),

          // ─── Toggle buttons ───
          Row(
            children: [
              // نعم / Oui
              Expanded(
                child: _ToggleBtn(
                  label: isAr ? 'نعم' : 'Oui',
                  isSelected: selected == true,
                  activeColor: _green,
                  onTap: () => _setAnswer(answerKey, true),
                ),
              ),
              const SizedBox(width: 10),
              // لا / Non
              Expanded(
                child: _ToggleBtn(
                  label: isAr ? 'لا' : 'Non',
                  isSelected: selected == false,
                  activeColor: _red,
                  onTap: () => _setAnswer(answerKey, false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Checkboxes card ───
  Widget _checkboxCard({
    required bool isAr,
    required List<(String, String, String)> items,
    required LanguageProvider lang,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        children: items.map((item) {
          final (ar, fr, key) = item;
          final checked = _checks[key] ?? false;
          return InkWell(
            onTap: () => _toggleCheck(key),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: checked ? _green : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: checked ? _green : Colors.grey.shade400,
                        width: 1.5,
                      ),
                    ),
                    child: checked
                        ? const Icon(
                            Icons.check_rounded,
                            size: 15,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    lang.t(ar, fr),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: checked ? FontWeight.w700 : FontWeight.w500,
                      color: checked
                          ? const Color(0xFF2C3E50)
                          : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

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

  Widget _sectionTitle(String text) => Container(
    padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 14),
    decoration: BoxDecoration(
      color: _green.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w900,
        color: _green,
      ),
    ),
  );
}

// ─── Reusable toggle button ───
class _ToggleBtn extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color activeColor;
  final VoidCallback onTap;

  const _ToggleBtn({
    required this.label,
    required this.isSelected,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? activeColor : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: isSelected ? Colors.white : Colors.grey.shade500,
            ),
          ),
        ),
      ),
    );
  }
}
