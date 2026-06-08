import 'package:hive/hive.dart';

part 'subject_model.g.dart';

@HiveType(typeId: 0)
class SubjectModel extends HiveObject {

  @HiveField(0)
  String name;

  @HiveField(1)
  int credit;

  @HiveField(2)
  String grade;

  @HiveField(3)
  int semester;

  SubjectModel({
    required this.name,
    required this.credit,
    required this.grade,
    required this.semester,
  });
}