
class FilterModel{
  final int id;
  final String libelle;
  final String color;

  FilterModel({
    required this.id,
    required this.libelle,
    required this.color,
  });

  factory FilterModel.fromJson(Map<String, dynamic> json)
  {
  return FilterModel(
      id: json["id"],
      libelle: json["libelle"],
      color: json["color"]);
  }

}