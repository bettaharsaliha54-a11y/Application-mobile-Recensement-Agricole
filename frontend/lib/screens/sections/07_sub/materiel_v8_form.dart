import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/language_provider.dart';
import 'v8_sub/mat_v8_tracteurs.dart';
import 'v8_sub/mat_v8_recolte.dart';
import 'v8_sub/mat_v8_vehicules.dart';
import 'v8_sub/mat_v8_travail_sol.dart';
import 'v8_sub/mat_v8_divers.dart';

const _green = Color(0xFF2E7D32);

class MaterielV8Form extends StatelessWidget {
  const MaterielV8Form({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isAr = lang.isArabic;

    final List<_SubCategory> cats = [
      _SubCategory(
        titleAr: 'الجرارات',
        titleFr: 'Tracteurs',
        descAr: 'أنواع الجرارات من الرمز 1 إلى 6',
        descFr: 'Types de tracteurs (Codes 1-6)',
        screen: const MatV8Tracteurs(),
      ),
      _SubCategory(
        titleAr: 'آلات الحصاد والدرس',
        titleFr: 'Moissonneuses et Récolte',
        descAr: 'آلات الحصاد، الحش والربط (الرموز 7-8، 17-20، 25-26)',
        descFr: 'Moisson, Faucheuses, Presses...',
        screen: const MatV8Recolte(),
      ),
      _SubCategory(
        titleAr: 'المركبات',
        titleFr: 'Véhicules et Remorques',
        descAr: 'مركبات خفيفة، ثقيلة، وصهاريج (الرموز 9-10، 21-22)',
        descFr: 'Véhicules léger/lourd, Citernes...',
        screen: const MatV8Vehicules(),
      ),
      _SubCategory(
        titleAr: 'المحارث وآلات تهيئة التربة',
        titleFr: 'Charrues et Travail du sol',
        descAr: 'محارث، آلات بذر، رش وأسمدة (الرموز 11-16)',
        descFr: 'Charrues, Epandeurs, Semoirs...',
        screen: const MatV8TravailSol(),
      ),
      _SubCategory(
        titleAr: 'معدات أخرى',
        titleFr: 'Autres matériels',
        descAr: 'مضخات ومعدات متنوعة (الرموز 23-24، 27)',
        descFr: 'Pompes et divers...',
        screen: const MatV8Divers(),
      ),
    ];

    return Directionality(
      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: cats.length,
        itemBuilder: (context, index) {
          final cat = cats[index];
          return _catCard(context, cat, isAr);
        },
      ),
    );
  }

  Widget _catCard(BuildContext context, _SubCategory cat, bool isAr) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _green.withValues(alpha: 0.3)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          isAr ? cat.titleAr : cat.titleFr,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: _green,
          ),
        ),
        subtitle: Text(
          isAr ? cat.descAr : cat.descFr,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
        trailing: Icon(
          isAr ? Icons.arrow_back_ios_rounded : Icons.arrow_forward_ios_rounded,
          size: 14,
          color: _green,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => _SubPage(
                title: isAr ? cat.titleAr : cat.titleFr,
                child: cat.screen,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SubCategory {
  final String titleAr, titleFr, descAr, descFr;
  final Widget screen;
  _SubCategory({
    required this.titleAr,
    required this.titleFr,
    required this.descAr,
    required this.descFr,
    required this.screen,
  });
}

class _SubPage extends StatelessWidget {
  final String title;
  final Widget child;
  const _SubPage({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: _green,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: child,
    );
  }
}
