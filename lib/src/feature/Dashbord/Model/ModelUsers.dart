class UserModel {
  final String uid;
  final String name;
  final String numberInTree;
  final String email;
  final String phone;
  final String gender;
  final String imageUrl;

  UserModel({
    required this.uid,
    required this.name,
    required this.numberInTree,
    required this.email,
    required this.phone,
    required this.gender,
    required this.imageUrl,
  });

  // Convert Firebase document snapshot to UserModel
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      numberInTree: data['numberInTree'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      gender: data['gender'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}
