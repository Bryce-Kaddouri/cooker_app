// user model means the employee model
class UserModel {
  final String uid;
  final String fName;
  final String lName;

  UserModel({
    required this.uid,
    required this.fName,
    required this.lName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json['user_id'],
        fName: json['user_full_name']['fName'],
        lName: json['user_full_name']['lName'],
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'user_full_name': {
          'fName': fName,
          'lName': lName,
        },
      };
}
