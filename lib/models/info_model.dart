
// info_model.dart
class InfoModel {
  final int id;
  final String code;
  final String date_naissance;
  final String photo;
  final double solde;

  InfoModel({
    required this.id,
    required this.code,
    required this.date_naissance,
    required this.photo,
    required this.solde,
  });

  factory InfoModel.fromJson(Map<String, dynamic> json) {
    return InfoModel(
      id:json["id"],
      code: json["code"],
      date_naissance: json["date_naissance"]?? 'Unknown',
      photo: json["photo"],
      solde: json['solde'] is int ? json['solde'].toDouble() : json['solde']?.toDouble() ?? 0.0,  // Handle solde as double. // Convert to double
    );
  }
}
