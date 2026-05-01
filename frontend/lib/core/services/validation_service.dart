import 'package:flutter/foundation.dart';

class ValidationService {
  static final ValidationService instance = ValidationService._init();
  ValidationService._init();

  /// Validates the entire questionnaire data before final submission
  ValidationReport validateSurvey(Map<String, dynamic> data) {
    List<String> errors = [];
    List<String> warnings = [];

    // 1. Basic Identity Validation
    if (data['exploitant_nom'] == null || data['exploitant_nom'].toString().isEmpty) {
      errors.add('Nom de l\'exploitant est requis (اسم المستثمر مطلوب)');
    }
    
    // 2. NIN Validation (Must be 15 or 18 digits)
    final nin = data['nin']?.toString() ?? '';
    if (nin.isEmpty) {
      errors.add('NIN est requis (رقم التعريف الوطني مطلوب)');
    } else if (nin.length != 15 && nin.length != 18) {
      warnings.add('Le format du NIN semble incorrect (تنسيق رقم التعريف الوطني قد يكون خاطئا)');
    }

    // 3. Section specific logic (Example: Surface verification)
    final totalSurface = double.tryParse(data['superficie_totale']?.toString() ?? '0') ?? 0;
    final utilizedSurface = double.tryParse(data['superficie_utile']?.toString() ?? '0') ?? 0;
    
    if (utilizedSurface > totalSurface) {
      errors.add('La superficie utile ne peut pas dépasser la superficie totale (المساحة المستغلة لا يمكن أن تتجاوز المساحة الإجمالية)');
    }

    // 4. Livestock section logic
    if (data['has_livestock'] == true) {
      final animalCount = int.tryParse(data['animal_count']?.toString() ?? '0') ?? 0;
      if (animalCount <= 0) {
        errors.add('Vous avez déclaré posséder du bétail, mais le nombre est 0 (لقد صرحت بوجود مواشي ولكن العدد 0)');
      }
    }

    return ValidationReport(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
    );
  }
}

class ValidationReport {
  final bool isValid;
  final List<String> errors;
  final List<String> warnings;

  ValidationReport({
    required this.isValid,
    required this.errors,
    required this.warnings,
  });
}
