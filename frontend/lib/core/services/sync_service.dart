import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../database/database_helper.dart';
// import 'package:http/http.dart' as http; // Assume http is available or will be added

class SyncService {
  static final SyncService instance = SyncService._init();
  SyncService._init();

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  /// Main synchronization logic
  Future<SyncResult> syncData() async {
    if (_isSyncing) return SyncResult(success: false, message: 'Sync already in progress');
    
    _isSyncing = true;
    int successCount = 0;
    int failCount = 0;

    try {
      final db = DatabaseHelper.instance;
      final completedSurveys = await db.getCompletedNotSynced();

      if (completedSurveys.isEmpty) {
        _isSyncing = false;
        return SyncResult(success: true, message: 'No new data to sync', count: 0);
      }

      for (var survey in completedSurveys) {
        final int id = survey['id'];
        final String jsonData = survey['census_json'] ?? '{}';
        
        // Simulation of API call
        bool success = await _uploadToBackend(id, jsonData);
        
        if (success) {
          await db.markAsSynced(id);
          successCount++;
        } else {
          failCount++;
        }
      }

      _isSyncing = false;
      return SyncResult(
        success: failCount == 0,
        message: 'Sync completed: $successCount success, $failCount failed',
        count: successCount,
      );
    } catch (e) {
      _isSyncing = false;
      return SyncResult(success: false, message: 'Sync error: $e');
    }
  }

  /// Internal method to handle the HTTP POST request to the backend
  Future<bool> _uploadToBackend(int id, String jsonData) async {
    try {
      debugPrint('🚀 Syncing survey ID $id to backend...');
      
      // MOCK BACKEND CALL
      await Future.delayed(const Duration(seconds: 2)); // Simulate network latency
      
      /* 
      // Real implementation would look like this:
      final response = await http.post(
        Uri.parse('https://api.rga-dz.com/v1/sync'),
        headers: {'Content-Type': 'application/json'},
        body: jsonData,
      );
      return response.statusCode == 200;
      */
      
      debugPrint('✅ Survey ID $id synced successfully.');
      return true;
    } catch (e) {
      debugPrint('❌ Sync failed for ID $id: $e');
      return false;
    }
  }
}

class SyncResult {
  final bool success;
  final String message;
  final int count;

  SyncResult({required this.success, required this.message, this.count = 0});
}
