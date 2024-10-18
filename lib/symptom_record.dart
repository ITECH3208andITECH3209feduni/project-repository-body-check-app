import 'package:hive/hive.dart';

part 'symptom_record.g.dart';

@HiveType(typeId: 0)
class SymptomRecord extends HiveObject {
  @HiveField(0)
  late String symptom;

  @HiveField(1)
  late DateTime date;

  @HiveField(2)
  late int severity;

  // Constructor
  SymptomRecord({
    required this.symptom,
    required this.date,
    required this.severity,
  });
}
