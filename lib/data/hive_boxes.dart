
import 'package:hive/hive.dart';
import '../model/subject_model.dart';

class HiveBoxes {

  static const String subjectBox = "subjects";

  static Box<SubjectModel> getSubjects() =>
      Hive.box<SubjectModel>(subjectBox);
}