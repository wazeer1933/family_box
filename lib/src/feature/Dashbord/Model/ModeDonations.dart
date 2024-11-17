class Donation {
  String? type;
  String? description;
  DateTime? date;
  double? cost;
  String? beneficiaryId;
  String? imageUrl;

  Donation({
    this.type,
    this.description,
    this.date,
    this.cost,
    this.beneficiaryId,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'description': description,
      'date': date?.toIso8601String(),
      'cost': cost,
      'beneficiaryId': beneficiaryId,
      'imageUrl': imageUrl,
    };
  }
}
