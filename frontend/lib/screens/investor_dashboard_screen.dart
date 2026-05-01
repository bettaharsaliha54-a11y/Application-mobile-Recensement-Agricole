import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../providers/exploitant_provider.dart';
import '../providers/questionnaire_provider.dart';
import '../models/exploitant.dart';
import '../core/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;
import 'dart:io';

class InvestorDashboardScreen extends StatefulWidget {
  const InvestorDashboardScreen({super.key});

  @override
  State<InvestorDashboardScreen> createState() =>
      _InvestorDashboardScreenState();
}

class _InvestorDashboardScreenState extends State<InvestorDashboardScreen> {
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      setState(() => _isSearchFocused = _searchFocusNode.hasFocus);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExploitantsProvider>().loadExploitants();
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final investorProvider = context.watch<ExploitantsProvider>();
    final isAr = lang.isArabic;
    const green = Color(0xFF2E7D32);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          isAr ? 'قائمة المستثمرين' : 'Liste des Investisseurs',
          style: const TextStyle(
            color: green,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: green),
            onPressed: () =>
                Navigator.pushReplacementNamed(context, '/welcome'),
          ),
        ],
      ),
      body: Directionality(
        textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
        child: RefreshIndicator(
          onRefresh: () => investorProvider.loadExploitants(),
          color: green,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  isAr ? 'إدارة المستثمرين' : 'Gestion des Investisseurs',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isAr ? 'قائمة المستثمرين' : 'Liste des Investisseurs',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text(isAr ? 'تنبيه' : 'Attention'),
                                content: Text(
                                  isAr
                                      ? 'هل تريد حقاً مسح جميع البيانات والبدء من جديد؟'
                                      : 'Voulez-vous vraiment réinitialiser toutes les données ?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: Text(isAr ? 'إلغاء' : 'Annuler'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: Text(
                                      isAr ? 'مسح' : 'Effacer',
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              try {
                                final db =
                                    await DatabaseHelper.instance.database;
                                await db.close();

                                final dbPath = await getDatabasesPath();
                                final path = join(dbPath, 'rga_census_v7.db');
                                final file = File(path);
                                if (await file.exists()) await file.delete();
                              } catch (e) {
                                debugPrint("Reset error: $e");
                              }

                              if (mounted) {
                                await context
                                    .read<ExploitantsProvider>()
                                    .loadExploitants();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isAr
                                          ? 'تمت إعادة تهيئة البيانات بنجاح'
                                          : 'Données réinitialisées avec succès',
                                    ),
                                    backgroundColor: green,
                                  ),
                                );
                              }
                            }
                          },
                          icon: const Icon(
                            Icons.delete_forever,
                            color: Colors.redAccent,
                            size: 18,
                          ),
                          label: Text(
                            isAr ? 'تهيئة' : 'Reset',
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => investorProvider.loadExploitants(),
                          icon: const Icon(
                            Icons.refresh_rounded,
                            color: Color(0xFF2E7D32),
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // --- Search Bar ---
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isSearchFocused ? green : Colors.grey.shade200,
                      width: 1.5,
                    ),
                    boxShadow: [
                      if (_isSearchFocused)
                        BoxShadow(
                          color: green.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                    ],
                  ),
                  child: TextField(
                    focusNode: _searchFocusNode,
                    onChanged: (v) => investorProvider.search(v),
                    decoration: InputDecoration(
                      hintText: isAr
                          ? 'البحث عن مستثمر...'
                          : 'Rechercher un investisseur...',
                      icon: Icon(
                        Icons.search,
                        color: _isSearchFocused ? green : Colors.grey,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/add_exploitant'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(
                          Icons.person_add_alt_1_rounded,
                          color: Colors.white,
                        ),
                        label: Text(
                          isAr ? 'إضافة مستثمر' : 'Ajouter Investisseur',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Expanded(
                  child: investorProvider.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(color: green),
                        )
                      : investorProvider.exploitants.isEmpty
                      ? _buildEmptyState(isAr)
                      : ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: investorProvider.exploitants.length,
                          itemBuilder: (context, index) {
                            final exp = investorProvider.exploitants[index];
                            return _buildInvestorCard(context, exp, isAr, lang);
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInvestorCard(
    BuildContext context,
    Exploitant e,
    bool isAr,
    LanguageProvider lang,
  ) {
    const green = Color(0xFF2E7D32);
    String title = isAr
        ? ("${e.nomAr ?? ''} ${e.prenomAr ?? ''}")
        : ("${e.nomFr ?? ''} ${e.prenomFr ?? ''}");

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.person, color: green, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 17,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "NIN: ${e.nin ?? '---'}",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        e.telephone ?? '---',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFFF9FAFB),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => context
                      .read<ExploitantsProvider>()
                      .deleteExploitant(e.id!),
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                    size: 20,
                  ),
                  label: Text(
                    lang.t('حذف', 'Supprimer'),
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    context.read<QuestionnaireProvider>().initForExploitant(e);
                    Navigator.pushNamed(context, '/questionnaire');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    lang.t('إحصاء', 'Recenser'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isAr) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_off_rounded, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            isAr ? 'لم يتم العثور على مستثمرين' : 'Aucun investisseur trouvé',
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
