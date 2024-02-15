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
        uid: json['id'],
        fName: json['first_name'],
        lName: json['last_name'],
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'user_full_name': {
          'fName': fName,
          'lName': lName,
        },
      };
}
