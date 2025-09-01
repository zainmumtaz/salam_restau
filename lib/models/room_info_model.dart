class RoomInfoModel {
  final String roomNumber;
  final String buildingName;
  final String villageName;
  final String startDate;
  final String endDate;
  final List<RoomDetail> details;

  RoomInfoModel({
    required this.roomNumber,
    required this.buildingName,
    required this.villageName,
    required this.startDate,
    required this.endDate,
    required this.details,
  });

  /// Normal JSON (agar already flat data ho)
  factory RoomInfoModel.fromJson(Map<String, dynamic> json) {
    return RoomInfoModel(
      roomNumber: json['room_number'] ?? '',
      buildingName: json['building_name'] ?? '',
      villageName: json['village_name'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      details: (json['details'] as List<dynamic>)
          .map((item) => RoomDetail.fromJson(item))
          .toList(),
    );
  }

  /// ✅ API Response se model create karna
  factory RoomInfoModel.fromApi(Map<String, dynamic> apiJson) {
    final activeOrder = apiJson['data']?['active_room_orders'];
    final room = activeOrder?['room'];
    final building = room?['building'];
    final village = building?['village'];

    return RoomInfoModel(
      roomNumber: room?['room_number'] ?? '',
      buildingName: building?['name'] ?? '',
      villageName: village?['village_name'] ?? '',
      startDate: activeOrder?['start_date'] ?? '',
      endDate: activeOrder?['end_date'] ?? '',
      details: (activeOrder?['details'] as List<dynamic>? ?? [])
          .map((item) => RoomDetail.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "room_number": roomNumber,
      "building_name": buildingName,
      "village_name": villageName,
      "start_date": startDate,
      "end_date": endDate,
      "details": details.map((d) => d.toJson()).toList(),
    };
  }
}

class RoomDetail {
  final int id;
  final int roomOrderId;
  final int etudiantId;
  final String billMonth;
  final String price;
  final String paymentStatus;
  final String createdAt;
  final String updatedAt;

  RoomDetail({
    required this.id,
    required this.roomOrderId,
    required this.etudiantId,
    required this.billMonth,
    required this.price,
    required this.paymentStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RoomDetail.fromJson(Map<String, dynamic> json) {
    return RoomDetail(
      id: json['id'] ?? 0,
      roomOrderId: json['room_order_id'] ?? 0,
      etudiantId: json['etudiant_id'] ?? 0,
      billMonth: json['bill_month'] ?? '',
      price: json['price'] ?? '0.0',
      paymentStatus: json['payment_status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "room_order_id": roomOrderId,
      "etudiant_id": etudiantId,
      "bill_month": billMonth,
      "price": price,
      "payment_status": paymentStatus,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }
}
