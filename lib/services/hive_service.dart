import 'package:hive/hive.dart';
import 'package:itech3209/models/symptom_record.dart';

class HiveService {
  static const String boxName = 'symptomRecords';

  Future<void> addSymptomRecord(SymptomRecord record) async {
    final box = await Hive.openBox<SymptomRecord>(boxName);
    await box.add(record);
  }

  Future<List<SymptomRecord>> getSymptomRecords() async {
    final box = await Hive.openBox<SymptomRecord>(boxName);
    return box.values.toList();
  }

  Future<void> updateSymptomRecord(SymptomRecord record) async {
    await record.save();
  }

  Future<void> deleteSymptomRecord(SymptomRecord record) async {
    await record.delete();
  }
}
