 class StudentModel{
   final int id;
   final String nomComplet;
   final String matricule;
   final String photo;

   StudentModel({
     required this.id,
     required this.nomComplet,
     required this.matricule,
     required this.photo
 });
   factory StudentModel.fromJson(Map<String, dynamic> json) {
     return StudentModel(
       id: json["id"],
       nomComplet: json["nomComplet"],
       matricule: json["matricule"],
       photo: json["photo"],

     );
   }
 }