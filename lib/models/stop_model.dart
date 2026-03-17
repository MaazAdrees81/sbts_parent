class Stop {
  final String id;
  final String routeId;
  final String name;
  final String? landmark;
  final String? latitude;
  final String? longitude;
  final String sequenceOrder;
  final String? morningArrivalTime;
  final String? eveningArrivalTime;
  final String? routeName;
  final String? routeDescription;
  final String? morningStartTime;
  final String? eveningStartTime;
  final String? busNumber;
  final String? registrationNo;
  final String? capacity;
  final String? driverName;
  final String? driverMobile;
  final String? attendantName;
  final String? attendantMobile;
  final bool isMyPickup;
  final bool isMyDrop;
  final String? scheduledTime;
  final String? myStopLabel;

  Stop({
    required this.id,
    required this.routeId,
    required this.name,
    this.landmark,
    this.latitude,
    this.longitude,
    required this.sequenceOrder,
    this.morningArrivalTime,
    this.eveningArrivalTime,
    this.routeName,
    this.routeDescription,
    this.morningStartTime,
    this.eveningStartTime,
    this.busNumber,
    this.registrationNo,
    this.capacity,
    this.driverName,
    this.driverMobile,
    this.attendantName,
    this.attendantMobile,
    this.isMyPickup = false,
    this.isMyDrop = false,
    this.scheduledTime,
    this.myStopLabel,
  });

  String get formattedScheduledTime {
    if (scheduledTime == null) return "";
    final parts = scheduledTime!.split(":");
    if (parts.length < 2) return scheduledTime!;
    final hour = int.tryParse(parts[0]) ?? 0;
    final min = parts[1];
    final period = hour >= 12 ? "pm" : "am";
    final h = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return "$h:$min $period";
  }

  String get morningTime {
    if (morningArrivalTime == null) return "";
    return _formatTime(morningArrivalTime!);
  }

  String get eveningTime {
    if (eveningArrivalTime == null) return "";
    return _formatTime(eveningArrivalTime!);
  }

  String _formatTime(String time) {
    final parts = time.split(":");
    if (parts.length < 2) return time;
    final hour = int.tryParse(parts[0]) ?? 0;
    final min = parts[1];
    final period = hour >= 12 ? "P.M." : "A.M.";
    final h = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return "${h.toString().padLeft(2, '0')}:$min $period";
  }

  factory Stop.fromJson(Map<String, dynamic> json) {
    return Stop(
      id: "${json['id']}",
      routeId: "${json['route_id'] ?? ''}",
      name: "${json['name'] ?? ''}",
      landmark: json['landmark'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      sequenceOrder: "${json['sequence_order'] ?? ''}",
      morningArrivalTime: json['morning_arrival_time'],
      eveningArrivalTime: json['evening_arrival_time'],
      routeName: json['route_name'],
      routeDescription: json['route_description'],
      morningStartTime: json['morning_start_time'],
      eveningStartTime: json['evening_start_time'],
      busNumber: json['bus_number'],
      registrationNo: json['registration_no'],
      capacity: json['capacity'],
      driverName: json['driver_name'],
      driverMobile: json['driver_mobile'],
      attendantName: json['attendant_name'],
      attendantMobile: json['attendant_mobile'],
      isMyPickup: json['is_my_pickup'] == true,
      isMyDrop: json['is_my_drop'] == true,
      scheduledTime: json['scheduled_time'],
      myStopLabel: json['my_stop_label'],
    );
  }
}
