// user_model.dart
import 'dart:ffi';

import 'info_model.dart';

class UserModel {
  final int id;
  final String nomComplet;
  final String email;
  final String matricule;
  final String utilisateur;
  final InfoModel? info;

  UserModel({
    required this.id,
    required this.nomComplet,
    required this.email,
    required this.matricule,
    required this.utilisateur,
    this.info,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      nomComplet: json["nomComplet"],
      email: json["email"],
      matricule: json["matricule"],
      utilisateur: json["role"],
      info: json["info"] != null ? InfoModel.fromJson(json["info"]) : null,
    );
  }
}
