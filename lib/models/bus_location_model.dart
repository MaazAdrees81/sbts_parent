class BusLocation {
  final String? busId;
  final String? driverId;
  final String? latitude;
  final String? longitude;
  final String? speed;
  final String? heading;
  final String? schedule;
  final String? accuracy;
  final String? source;
  final String? recordedAt;
  final String? busNumber;
  final String? secondsAgo;
  final bool visible;

  BusLocation({
    this.busId,
    this.driverId,
    this.latitude,
    this.longitude,
    this.speed,
    this.heading,
    this.schedule,
    this.accuracy,
    this.source,
    this.recordedAt,
    this.busNumber,
    this.secondsAgo,
    this.visible = false,
  });

  String get lastSeenText {
    if (secondsAgo == null) return "";
    final secs = int.tryParse(secondsAgo!) ?? 0;
    if (secs < 60) return "${secs}s ago";
    if (secs < 3600) return "${secs ~/ 60}m ago";
    return "${secs ~/ 3600}h ago";
  }

  factory BusLocation.fromJson(Map<String, dynamic> json) {
    return BusLocation(
      busId: json['bus_id']?.toString(),
      driverId: json['driver_id']?.toString(),
      latitude: json['latitude']?.toString(),
      longitude: json['longitude']?.toString(),
      speed: json['speed']?.toString(),
      heading: json['heading']?.toString(),
      schedule: json['schedule'],
      accuracy: json['accuracy']?.toString(),
      source: json['source'],
      recordedAt: json['recorded_at'],
      busNumber: json['bus_number'],
      secondsAgo: json['seconds_ago']?.toString(),
      visible: json['visible'] == true,
    );
  }
}
