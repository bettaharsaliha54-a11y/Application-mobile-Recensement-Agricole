import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../providers/exploitant_provider.dart';
import '../models/exploitant.dart';
import '../core/theme/app_theme.dart';
import 'census_consultation_screen.dart';
import 'dart:convert';

class CompletedSurveysScreen extends StatelessWidget {
  const CompletedSurveysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final prov = context.watch<ExploitantsProvider>();
    final isAr = lang.isArabic;
    final completed = prov.completedExploitants;
    debugPrint(
      "🖥️ CompletedSurveysScreen Build: Found ${completed.length} items",
    );
    const green = Color(0xFF2E7D32);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          isAr
              ? 'قائمة الاستمارات المكتملة'
              : 'Liste des Questionnaires Complétés',
          style: const TextStyle(
            color: green,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: green),
            onPressed: () => prov.loadExploitants(),
          ),
        ],
      ),
      body: Directionality(
        textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                isAr ? 'الاستمارات المكتملة' : 'Questionnaires Complétés',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isAr
                    ? 'سجل العمليات التي تمت بنجاح'
                    : 'Historique des opérations terminées',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),

              Expanded(
                child: prov.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: green),
                      )
                    : prov.completedExploitants.isEmpty
                    ? _buildEmptyState(isAr)
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: prov.completedExploitants.length,
                        itemBuilder: (context, index) {
                          final item = prov.completedExploitants[index];
                          return _buildCompletedCard(context, item, isAr);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompletedCard(BuildContext context, Exploitant e, bool isAr) {
    const green = Color(0xFF2E7D32);
    String name = isAr
        ? ('${e.nomAr ?? ''} ${e.prenomAr ?? ''}').trim()
        : ('${e.nomFr ?? ''} ${e.prenomFr ?? ''}').trim();
    if (name.isEmpty) name = isAr ? 'مستثمر مجهول' : 'Exploitant Inconnu';

    return Dismissible(
      key: Key(e.id.toString()),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(isAr ? 'تأكيد الحذف' : 'Confirmation'),
            content: Text(
              isAr
                  ? 'هل أنت متأكد من حذف هذه الاستمارة المكتملة؟ سيتم حذف جميع بيانات المستثمر والمستثمرة المرتبطة بها نهائياً من الجهتين.'
                  : 'Voulez-vous supprimer ce questionnaire ? Toutes les données de l\'exploitant et de l\'exploitation associées seront définitivement supprimées des deux côtés.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(isAr ? 'إلغاء' : 'Annuler'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  isAr ? 'حذف' : 'Supprimer',
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        if (e.id != null) {
          context.read<ExploitantsProvider>().deleteExploitant(e.id!);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isAr ? 'تم حذف الاستمارة' : 'Questionnaire supprimé',
              ),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: isAr ? Alignment.centerLeft : Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: const Icon(
          Icons.delete_sweep_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
      child: GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isAr
                    ? 'لا يمكن فتح الاستمارة، يجب مزامنة البيانات أولاً'
                    : 'Impossible d\'ouvrir, vous devez d\'abord synchroniser les données',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Container(width: 6, color: green),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: green.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.assignment_turned_in_rounded,
                              color: green,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xFF2C3E50),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today_rounded,
                                      size: 14,
                                      color: Colors.grey.shade500,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      "${isAr ? 'تاريخ الإحصاء' : 'Date du recensement'}: ${e.censusDate ?? '---'}",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            isAr
                                ? Icons.chevron_left_rounded
                                : Icons.chevron_right_rounded,
                            color: Colors.grey.shade400,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isAr) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_rounded, size: 80, color: Colors.grey.shade200),
          const SizedBox(height: 16),
          Text(
            isAr
                ? 'لا توجد عمليات إحصاء مكتملة حالياً'
                : 'Aucun recensement terminé pour le moment',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
