import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/language_provider.dart';
import '07_sub/v7_sub/bat_v7_habitation.dart';
import '07_sub/v7_sub/bat_v7_elevage.dart';
import '07_sub/v7_sub/bat_v7_stockage.dart';
import '07_sub/v8_sub/mat_v8_tracteurs.dart';
import '07_sub/v8_sub/mat_v8_recolte.dart';
import '07_sub/v8_sub/mat_v8_vehicules.dart';
import '07_sub/v8_sub/mat_v8_travail_sol.dart';
import '07_sub/v8_sub/mat_v8_divers.dart';

class BatimentsMaterielFormScreen extends StatelessWidget {
  const BatimentsMaterielFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isAr = lang.isArabic;

    return Scaffold(
      backgroundColor: AppTheme.surfaceLight,
      body: Directionality(
        textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title 1: Buildings
              _mainSectionTitle(isAr ? '1. البنايات' : '1. Bâtiments'),

              const BatV7Habitation(),
              const BatV7Elevage(),
              const BatV7Stockage(),

              const SizedBox(height: 16),

              // Title 2: Equipment
              _mainSectionTitle(isAr ? '2. العتاد' : '2. Matériel'),

              const MatV8Tracteurs(),
              const MatV8Recolte(),
              const MatV8Vehicules(),
              const MatV8TravailSol(),
              const MatV8Divers(),

              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mainSectionTitle(String t) => Container(
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
    width: double.infinity,
    child: Text(
      t,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w900,
        color: Colors.black,
        letterSpacing: 0.5,
      ),
    ),
  );
}
