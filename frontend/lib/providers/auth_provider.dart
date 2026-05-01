import 'package:flutter/material.dart';
import '../core/database/database_helper.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final db = await DatabaseHelper.instance.database;
      print("Offline login attempt for email: $email");
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'email = ? AND password_hash = ?',
        whereArgs: [email, password],
      );

      if (maps.isNotEmpty) {
        _currentUser = User.fromMap(maps.first);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = "اسم المستخدم أو كلمة المرور غير صحيحة";
      }
    } catch (e) {
      print("Database error during login: $e");
      _errorMessage = "حدث خطأ في قاعدة البيانات";
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
