
// info_model.dart
class InfoModel {
  final int id;
  final String code;
  final String date_naissance;
  final String photo;
  final double solde;
  final String numero;

  InfoModel({
    required this.id,
    required this.code,
    required this.date_naissance,
    required this.photo,
    required this.solde,
    required this.numero,
  });

  factory InfoModel.fromJson(Map<String, dynamic> json) {
    return InfoModel(
      id:json["id"],
      code: json["code"],
      date_naissance: json["date_naissance"]?? 'Unknown',
      photo: json["photo"],
      solde: json['solde'] is int ? json['solde'].toDouble() : json['solde']?.toDouble() ?? 0.0,
      numero: json["numero"],// Handle solde as double. // Convert to double
    );
  }
}
