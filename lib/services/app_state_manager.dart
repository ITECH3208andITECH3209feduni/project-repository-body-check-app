import 'package:flutter/material.dart';
import 'package:itech3209/models/symptom_record.dart';

import 'hive_service.dart';

class AppStateManager extends ChangeNotifier {
  final HiveService _hiveService = HiveService();
  List<SymptomRecord> _symptomRecords = [];

  // Getter for symptom records
  List<SymptomRecord> get symptomRecords => _symptomRecords;

  // Load symptom records from Hive
  Future<void> loadSymptomRecords() async {
    _symptomRecords = await _hiveService.getSymptomRecords();
    notifyListeners();
  }

  // Add a new symptom record
  Future<void> addSymptomRecord(SymptomRecord record) async {
    await _hiveService.addSymptomRecord(record);
    _symptomRecords.add(record);
    notifyListeners();
  }

  // Update an existing symptom record
  Future<void> updateSymptomRecord(SymptomRecord record) async {
    await _hiveService.updateSymptomRecord(record);
    int index = _symptomRecords.indexWhere((r) => r.key == record.key);
    if (index != -1) {
      _symptomRecords[index] = record;
      notifyListeners();
    }
  }

  // Delete a symptom record
  Future<void> deleteSymptomRecord(SymptomRecord record) async {
    await _hiveService.deleteSymptomRecord(record);
    _symptomRecords.removeWhere((r) => r.key == record.key);
    notifyListeners();
  }

  // Call this method in the constructor or when the app starts
  void initializeData() {
    loadSymptomRecords();
  }
}
