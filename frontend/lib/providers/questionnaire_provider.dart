import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import '../core/database/database_helper.dart';
import 'exploitant_provider.dart';
import 'dashboard_provider.dart';

class QuestionnaireProvider with ChangeNotifier {
  int _currentStep = 0;
  bool _isLoading = false;
  Map<String, dynamic> _values = {};

  List<Map<String, dynamic>> _wilayas = [];
  List<Map<String, dynamic>> _communes = [];
  List<Map<String, dynamic>> _statutsJuridiques = [];
  List<Map<String, dynamic>> _activites = [];

  int get currentStep => _currentStep;
  bool get isLoading => _isLoading;
  Map<String, dynamic> get values => _values;

  List<Map<String, dynamic>> get wilayas => _wilayas;
  List<Map<String, dynamic>> get communes => _communes;
  List<Map<String, dynamic>> get statutsJuridiques => _statutsJuridiques;
  List<Map<String, dynamic>> get activites => _activites;

  QuestionnaireProvider() {
    _initValues();
    _loadInitialData();
  }

  void _initValues() {
    _values = {
      'nom_exploitation_fr': '',
      'nom_exploitation_ar': '',
      'wilaya_id': null,
      'commune_id': null,
      'statut_juridique_id': null,
      'activite_exploitation_id': null,
      'latitude': null,
      'longitude': null,
      'acces_reseau_electrique': 0,
      'acces_reseau_telephonique': 0,
      'acces_internet': 0,
    };
  }

  Future<void> _loadInitialData() async {
    _isLoading = true;
    notifyListeners();
    try {
      await DatabaseHelper.instance.forceSeed();
      _wilayas = await DatabaseHelper.instance.readAllWilayas();
      _statutsJuridiques = await DatabaseHelper.instance.readReferenceTable(
        'statut_juridique',
      );
      _activites = await DatabaseHelper.instance.readReferenceTable(
        'type_activite',
      );
    } catch (e) {
      debugPrint("Load Error: $e");
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadCommunes(int wilayaId) async {
    _communes = await DatabaseHelper.instance.readCommunesByWilaya(wilayaId);
    notifyListeners();
  }

  void updateValue(String key, dynamic value) {
    _values[key] = value;
    if (key == 'wilaya_id') {
      _values['commune_id'] = null;
      if (value != null) loadCommunes(value);
    }
    notifyListeners();
  }

  void updateExploitant({String? nomAr, String? prenomAr}) {
    if (nomAr != null) _values['nom_ar'] = nomAr;
    if (prenomAr != null) _values['prenom_ar'] = prenomAr;
    notifyListeners();
  }

  void nextStep() {
    if (_currentStep < 13) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  void setStep(int s) {
    _currentStep = s;
    notifyListeners();
  }

  int? _exploitantId;
  int? get exploitantId => _exploitantId;

  void setExploitantId(int? id) {
    _exploitantId = id;
    notifyListeners();
  }

  void initForExploitant(dynamic e) {
    reset();
    _exploitantId = e.id;
    _values['nom_ar'] = e.nomAr;
    _values['prenom_ar'] = e.prenomAr;
    _values['nom_fr'] = e.nomFr;
    _values['prenom_fr'] = e.prenomFr;
    _values['nin'] = e.nin;
    _values['telephone'] = e.telephone;
    notifyListeners();
  }

  String getSummary(bool isAr) {
    StringBuffer sb = StringBuffer();
    sb.writeln(
      isAr
          ? "📊 ملخص استمارة الإحصاء الفلاحي"
          : "📊 Résumé du Questionnaire RGA",
    );
    sb.writeln("--------------------------------");

    sb.writeln(isAr ? "👤 هوية المستغل:" : "👤 Identité de l'exploitant:");
    String fullName = isAr
        ? "${_values['nom_ar'] ?? ''} ${_values['prenom_ar'] ?? ''}".trim()
        : "${_values['nom_fr'] ?? ''} ${_values['prenom_fr'] ?? ''}".trim();
    if (fullName.isEmpty) fullName = '---';
    sb.writeln("   - ${isAr ? 'الاسم واللقب' : 'Nom & Prénom'}: $fullName");
    sb.writeln(
      "   - ${isAr ? 'رقم التعريف (NIN)' : 'NIN'}: ${_values['nin'] ?? '---'}",
    );
    sb.writeln(
      "   - ${isAr ? 'الهاتف' : 'Tél'}: ${_values['telephone'] ?? '---'}",
    );

    sb.writeln("");
    sb.writeln(isAr ? "🏠 معلومات المستثمرة:" : "🏠 Info Exploitation:");
    String nomExpl = isAr
        ? (_values['nom_exploitation_ar'] ??
              _values['nom_exploitation_fr'] ??
              '---')
        : (_values['nom_exploitation_fr'] ??
              _values['nom_exploitation_ar'] ??
              '---');
    sb.writeln("   - ${isAr ? 'الاسم' : 'Nom'}: $nomExpl");

    if (_values['wilaya_id'] != null) {
      final w = _wilayas.firstWhere(
        (element) => element['id'] == _values['wilaya_id'],
        orElse: () => {},
      );
      if (w.isNotEmpty)
        sb.writeln(
          "   - ${isAr ? 'الولاية' : 'Wilaya'}: ${isAr ? w['nom_ar'] : w['nom_fr']}",
        );
    }

    if (_values['commune_id'] != null) {
      final c = _communes.firstWhere(
        (element) => element['id'] == _values['commune_id'],
        orElse: () => {},
      );
      if (c.isNotEmpty)
        sb.writeln(
          "   - ${isAr ? 'البلدية' : 'Commune'}: ${isAr ? c['nom_ar'] : c['nom_fr']}",
        );
    }

    sb.writeln("");
    sb.writeln(isAr ? "📐 المساحات (هكتار):" : "📐 Superficies (Ha):");
    sb.writeln("   - SAU: ${_values['s51_sau'] ?? '0'} Ha");
    sb.writeln("   - SAT: ${_values['s54_sat'] ?? '0'} Ha");
    sb.writeln("   - ST:  ${_values['s56_st'] ?? '0'} Ha");

    sb.writeln("");
    sb.writeln(isAr ? "🔌 الشبكات والتوصيلات:" : "🔌 Réseaux & Connexions:");
    sb.writeln(
      "   - ${isAr ? 'الكهرباء' : 'Électricité'}: ${(_values['acces_reseau_electrique'] == 1) ? (isAr ? 'نعم' : 'Oui') : (isAr ? 'لا' : 'Non')}",
    );
    sb.writeln(
      "   - ${isAr ? 'الإنترنت' : 'Internet'}: ${(_values['acces_internet'] == 1) ? (isAr ? 'نعم' : 'Oui') : (isAr ? 'لا' : 'Non')}",
    );

    sb.writeln("");
    sb.writeln("--------------------------------");
    return sb.toString();
  }

  void reset() {
    _currentStep = 0;
    _exploitantId = null;
    _values = {};
    _initValues();
    notifyListeners();
  }

  Future<void> saveCensus(BuildContext context) async {
    debugPrint(
      "💾 Attempting to save census for Exploitant ID: $_exploitantId",
    );
    if (_exploitantId != null) {
      final date =
          "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
      final String jsonValues = jsonEncode(_values);

      await DatabaseHelper.instance.updateExploitantIdentity(
        _exploitantId!,
        nomAr: _values['nom_ar'],
        prenomAr: _values['prenom_ar'],
        nomFr: _values['nom_fr'],
        prenomFr: _values['prenom_fr'],
        nin: _values['nin'],
        tel: _values['telephone'],
      );

      await DatabaseHelper.instance.markAsCompleted(
        _exploitantId!,
        date,
        jsonValues,
      );

      if (context.mounted) {
        await context.read<ExploitantsProvider>().loadExploitants();
        await context.read<DashboardProvider>().loadData();
      }

      reset();
    }
    notifyListeners();
  }
}
