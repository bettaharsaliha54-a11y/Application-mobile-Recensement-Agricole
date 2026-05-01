import 'package:flutter/material.dart';
import '../core/database/database_helper.dart';
import '../models/exploitant.dart';
import '../models/exploitation.dart';

class DashboardProvider with ChangeNotifier {
  List<Exploitation> _exploitations = [];
  List<Exploitant> _exploitants = [];
  bool _isLoading = false;

  List<Exploitation> get exploitations => _exploitations;
  List<Exploitant> get exploitants => _exploitants;
  bool get isLoading => _isLoading;

  DashboardProvider() {
    loadData();
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _exploitations = await DatabaseHelper.instance.readAllExploitations();
      _exploitants = await DatabaseHelper.instance.readAllExploitants();
    } catch (e) {
      debugPrint("Error loading dashboard data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // حل مشكلة الخطأ في شاشة الإضافة
  Future<void> loadExploitations() async => await loadData();
  Future<void> loadExploitants() async => await loadData();

  Future<void> deleteExploitation(int id) async {
    await DatabaseHelper.instance.deleteExploitation(id);
    await loadData();
  }

  Future<void> deleteExploitants(int id) async {
    await DatabaseHelper.instance.deleteExploitant(id);
    await loadData();
  }
}
