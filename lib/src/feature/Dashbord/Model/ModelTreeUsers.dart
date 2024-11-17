class FamilyMember {
  String id;
  String name;
  String birthDate;
  String gender;
  String image;
  String uid;

  List<FamilyMember> children = [];

  FamilyMember({
    required this.id,
    required this.name,
    required this.birthDate,
    required this.gender,
    required this.image,
    required this.uid
  });

  // Convert a map to a FamilyMember
  factory FamilyMember.fromMap(Map<String, dynamic> map) {
    return FamilyMember(
      id: map['id'],
      name: map['name'],
      birthDate: map['birthDate'],
      gender: map['gender'],
      image: map['image'],
      uid: map['uid'],
    );
  }

  // Convert the FamilyMember and its children to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'birthDate': birthDate,
      'gender': gender,
      'image':image,
      'uid':uid,
      'children': children.map((child) => child.toMap()).toList(),
    };
  }
}