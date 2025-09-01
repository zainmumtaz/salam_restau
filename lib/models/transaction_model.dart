

class TransactionModel {
  final int id;
  final int etudiantId;
  final int? senderId;
  final int? receiverId;
  final String date;
  final int? agentId;
  final int typeId;
  final String type;
  final int wavePaymentId;
  final String paymentStatus;
  final String checkoutStatus;
  final String waveLaunchUrl;
  final String waveAmount;
  final String whenCreated;
  final String whenExpires;
  final String whenCompleted;
  final int montant;
  final dynamic quantite;
  final String? senderName;
  final String receiverName;
  final String? senderMatricule;
  final String? receiverMatricule;
  final String reference;

  TransactionModel({
    required this.id,
    required this.etudiantId,
    this.senderId,
    this.receiverId,
    required this.date,
    this.agentId,
    required this.typeId,
    required this.type,
    required this.wavePaymentId,
    required this.paymentStatus,
    required this.checkoutStatus,
    required this.waveLaunchUrl,
    required this.waveAmount,
    required this.whenCreated,
    required this.whenExpires,
    required this.whenCompleted,
    required this.montant,
    this.quantite,
    this.senderName,
    required this.receiverName,
    this.senderMatricule,
    this.receiverMatricule,
    required this.reference,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? 0,
      etudiantId: json['etudiant_id'] ?? 0,
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      date: json['date'] ?? '',
      agentId: json['agent_id'],
      typeId: json['type_id'] ?? 0,
      type: json['type'] ?? '',
      wavePaymentId: json['wave_payment_id'] ?? 0,
      paymentStatus: json['payment_status'] ?? '',
      checkoutStatus: json['checkout_status'] ?? '',
      waveLaunchUrl: json['wave_launch_url'] ?? '',
      waveAmount: json['wave_amount'] ?? '',
      whenCreated: json['when_created'] ?? '',
      whenExpires: json['when_expires'] ?? '',
      whenCompleted: json['when_completed'] ?? '',
      montant: json['montant'] ?? 0,
      quantite: json['quantite'],
      senderName: json['sender_name'],
      receiverName: json['receiver_name'] ?? '',
      senderMatricule: json['sender_matricule'],
      receiverMatricule: json['receiver_matricule'],
      reference: json['reference'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'etudiant_id': etudiantId,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'date': date,
      'agent_id': agentId,
      'type_id': typeId,
      'type': type,
      'wave_payment_id': wavePaymentId,
      'payment_status': paymentStatus,
      'checkout_status': checkoutStatus,
      'wave_launch_url': waveLaunchUrl,
      'wave_amount': waveAmount,
      'when_created': whenCreated,
      'when_expires': whenExpires,
      'when_completed': whenCompleted,
      'montant': montant,
      'quantite': quantite,
      'sender_name': senderName,
      'receiver_name': receiverName,
      'sender_matricule': senderMatricule,
      'receiver_matricule': receiverMatricule,
      'reference': reference,
    };
  }
}




// Import TypeModel

// class TransactionModel {
//   // Reactive fields
//   final Rx<int?> id;
//   final Rx<UserModel?> agent;
//   final Rx<UserModel?> destinataire;
//   final Rx<String?> date;
//   final Rx<String?> montant; // Use double explicitly
//   final Rx<int> quantite;
//   final Rx<String> repas;
//   final Rx<String> reference;
//   final Rx<TypeModel?> type;
//
//   // Constructor
//   TransactionModel({
//     int? id,
//     UserModel? agent,
//     UserModel? destinataire,
//     String? date,
//     String? montant,
//     int quantite = -1,
//     String repas = "",
//     String reference = "",
//     TypeModel? type,
//   })  : id = Rx<int?>(id),
//         agent = Rx<UserModel?>(agent),
//         destinataire = Rx<UserModel?>(destinataire),
//         date = Rx<String?>(date),
//         montant = Rx<String?>(montant),
//         quantite = Rx<int>(quantite),
//         repas = Rx<String>(repas),
//         reference = Rx<String>(reference),
//         type = Rx<TypeModel?>(type);
//
//   // Factory method for JSON parsing
//   factory TransactionModel.fromJson(Map<String, dynamic> json) {
//     return TransactionModel(
//       id: json['id'],
//       agent: json["agent"] != null ? UserModel.fromJson(json['agent']) : null,
//       destinataire: json["destinataire"] != null
//           ? UserModel.fromJson(json['destinataire'])
//           : null,
//       date: json['date'],
//       type: json['type'] != null ? TypeModel.fromJson(json['type']) : null,
//       montant: json['montant'], // Explicitly cast montant to double
//       quantite: json['quantite'] ?? -1,
//       repas: json['repas'] ?? "",
//       reference: json['reference'] ?? "",
//     );
//   }
// }




