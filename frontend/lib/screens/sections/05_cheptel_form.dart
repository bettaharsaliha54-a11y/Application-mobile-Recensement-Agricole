import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/language_provider.dart';
import '05_sub/bovins_form.dart';
import '05_sub/ovins_caprins_form.dart';
import '05_sub/camelins_form.dart';
import '05_sub/equides_form.dart';
import '05_sub/aviculture_cuniculture_form.dart';
import '05_sub/apiculture_form.dart';

class CheptelFormScreen extends StatelessWidget {
  const CheptelFormScreen({super.key});

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
              _blackTitle(isAr ? '1. الأبقار' : '1. Bovins'),
              const BovinsForm(),
              const SizedBox(height: 10),

              _blackTitle(isAr ? '2. الأغنام والماعز' : '2. Ovins & Caprins'),
              const OvinsCaprinsForm(),
              const SizedBox(height: 10),

              _blackTitle(isAr ? '3. الإبل' : '3. Camélins'),
              const CamelinsForm(),
              const SizedBox(height: 10),

              _blackTitle(isAr ? '4. الخيول والجمال' : '4. Équidés'),
              const EquidesForm(),
              const SizedBox(height: 10),

              _blackTitle(
                isAr ? '5. الدواجن والأرانب' : '5. Aviculture & Cuniculture',
              ),
              const AvicultureCunicultureForm(),
              const SizedBox(height: 10),

              _blackTitle(isAr ? '6. تربية النحل' : '6. Apiculture'),
              const ApicultureForm(),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _blackTitle(String t) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
}
