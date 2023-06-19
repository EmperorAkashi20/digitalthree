import 'package:isar/isar.dart';

part 'user_details_model.g.dart';

@collection
class UserDetailsItem {
  Id id = Isar.autoIncrement;
  String? name;
  String? email;
  String? password;
  String? phoneNo;
  String? profession;
}
