import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/home_app_bar.dart';
import '../components/route_info_card.dart';
import '../globals/constants.dart';
import '../models/bus_location_model.dart';
import '../models/stop_model.dart';
import '../models/student_model.dart';
import '../services/api_service.dart';

class RouteDetailScreen extends StatefulWidget {
  const RouteDetailScreen({super.key});

  @override
  State<RouteDetailScreen> createState() => _RouteDetailScreenState();
}

class _RouteDetailScreenState extends State<RouteDetailScreen> {
  late final Student student;
  List<Stop> morningStops = [];
  List<Stop> eveningStops = [];
  BusLocation? busLocation;
  bool isLoading = true;
  bool isMorning = true;
  int tabIndex = 0;
  GoogleMapController? _mapController;
  Timer? _locationTimer;

  List<Stop> get stops => isMorning ? morningStops : eveningStops;

  @override
  void initState() {
    super.initState();
    student = Get.arguments as Student;
    _loadData();
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    final routeId = student.pickupStopRouteId ?? student.dropStopRouteId ?? "1";

    // Fetch morning, evening stops and location separately
    try {
      final mData = await ApiService.I.fetchStops(routeId: routeId, schedule: "morning", studentId: student.id);
      morningStops = mData.map((e) => Stop.fromJson(e)).toList();
    } catch (e) {
      if (kDebugMode) debugPrint("morning stops error: $e");
    }

    try {
      final eData = await ApiService.I.fetchStops(routeId: routeId, schedule: "evening", studentId: student.id);
      eveningStops = eData.map((e) => Stop.fromJson(e)).toList();
    } catch (e) {
      if (kDebugMode) debugPrint("evening stops error: $e");
    }

    try {
      final locData = await ApiService.I.fetchBusLocation();
      if (locData != null) busLocation = BusLocation.fromJson(locData);
    } catch (e) {
      if (kDebugMode) debugPrint("location error: $e");
    }

    setState(() => isLoading = false);
  }

  void _fitAllMarkers(Set<Marker> markers) {
    if (markers.length < 2 || _mapController == null) return;
    double minLat = 90, maxLat = -90, minLng = 180, maxLng = -180;
    for (final m in markers) {
      if (m.position.latitude < minLat) minLat = m.position.latitude;
      if (m.position.latitude > maxLat) maxLat = m.position.latitude;
      if (m.position.longitude < minLng) minLng = m.position.longitude;
      if (m.position.longitude > maxLng) maxLng = m.position.longitude;
    }
    _mapController!.animateCamera(CameraUpdate.newLatLngBounds(
      LatLngBounds(southwest: LatLng(minLat, minLng), northeast: LatLng(maxLat, maxLng)),
      80,
    ));
  }

  void _toggleSchedule() {
    setState(() => isMorning = !isMorning);
  }

  void _startLocationPolling() {
    _locationTimer?.cancel();
    _locationTimer = Timer.periodic(const Duration(seconds: 15), (_) => _refreshLocation());
  }

  Future<void> _refreshLocation() async {
    try {
      final data = await ApiService.I.fetchBusLocation();
      if (data != null && mounted) {
        setState(() => busLocation = BusLocation.fromJson(data));
        _animateToLocation();
      }
    } catch (_) {}
  }

  void _animateToLocation() {
    if (busLocation == null || _mapController == null) return;
    final lat = double.tryParse(busLocation!.latitude ?? "");
    final lng = double.tryParse(busLocation!.longitude ?? "");
    if (lat != null && lng != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLng(LatLng(lat, lng)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final regNo = stops.isNotEmpty ? (stops.first.registrationNo ?? "") : "";
    final busNum = stops.isNotEmpty ? (stops.first.busNumber ?? "") : "";
    final title = regNo.isNotEmpty ? "$regNo ($busNum)" : student.name;

    return Scaffold(
      appBar: null,
      backgroundColor: kScaffoldBg,
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              HomeAppBar(
                height: 160,
                leading: GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 16,
                child: Column(
                  children: [
                    Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white), textAlign: TextAlign.center),
                    const SizedBox(height: 10),
                    _TabToggle(tabIndex: tabIndex, onChanged: (i) => setState(() => tabIndex = i)),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator(color: kPrimaryColor))
                : tabIndex == 0
                    ? Stack(
                        children: [
                          Positioned.fill(child: _buildLiveView()),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: _BottomStudentCard(
                              student: student,
                              driverName: stops.isNotEmpty ? stops.first.driverName : null,
                              driverMobile: stops.isNotEmpty ? stops.first.driverMobile : null,
                            ),
                          ),
                        ],
                      )
                    : _buildRouteView(),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveView() {
    final lat = double.tryParse(busLocation?.latitude ?? "");
    final lng = double.tryParse(busLocation?.longitude ?? "");
    final hasLocation = lat != null && lng != null;

    final markers = <Marker>{};
    if (hasLocation) {
      markers.add(Marker(
        markerId: const MarkerId("bus"),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: "Bus", snippet: busLocation!.lastSeenText),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ));
    }

    final polylinePoints = <LatLng>[];
    for (final stop in stops) {
      final sLat = double.tryParse(stop.latitude ?? "");
      final sLng = double.tryParse(stop.longitude ?? "");
      if (sLat != null && sLng != null) {
        final pos = LatLng(sLat, sLng);
        polylinePoints.add(pos);
        final isMyStop = stop.isMyPickup || stop.isMyDrop;
        markers.add(Marker(
          markerId: MarkerId("stop_${stop.id}"),
          position: pos,
          infoWindow: InfoWindow(title: stop.name, snippet: stop.myStopLabel),
          icon: BitmapDescriptor.defaultMarkerWithHue(isMyStop ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueRed),
        ));
      }
    }

    final polylines = <Polyline>{};
    if (polylinePoints.length > 1) {
      polylines.add(Polyline(
        polylineId: const PolylineId("route"),
        points: polylinePoints,
        color: kPrimaryColor,
        width: 4,
        patterns: [PatternItem.dash(20), PatternItem.gap(10)],
      ));
    }

    final initialPosition = hasLocation ? LatLng(lat, lng) : const LatLng(28.6139, 77.2090);

    if (_locationTimer == null) _startLocationPolling();

    return GoogleMap(
      initialCameraPosition: CameraPosition(target: initialPosition, zoom: 14),
      markers: markers,
      polylines: polylines,
      myLocationEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      padding: const EdgeInsets.only(bottom: 180),
      onMapCreated: (controller) {
        _mapController = controller;
        _fitAllMarkers(markers);
      },
    );
  }

  Widget _buildRouteView() {
    final firstStop = stops.isNotEmpty ? stops.first : null;
    final lastStop = stops.length > 1 ? stops.last : null;
    final routeName = firstStop?.routeName ?? "";
    final regNo = firstStop?.registrationNo ?? "";

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        children: [
          RouteInfoCard(
            routeName: routeName,
            registrationNo: regNo,
            firstStop: firstStop,
            lastStop: lastStop,
            isMorning: isMorning,
            onToggleSchedule: _toggleSchedule,
          ),
          const SizedBox(height: 16),
          const Text("View routes and stops", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: kPrimaryColor)),
          const SizedBox(height: 16),
          ...stops.asMap().entries.map((entry) => _StopItem(
                stop: entry.value,
                isMorning: isMorning,
                isLast: entry.key == stops.length - 1,
              )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _TabToggle extends StatelessWidget {
  const _TabToggle({required this.tabIndex, required this.onChanged});
  final int tabIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(color: Colors.white, borderRadius: kBorderRadius12),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(color: tabIndex == 0 ? kPrimaryColor : Colors.transparent, borderRadius: kBorderRadius8),
                child: Text("Live View", textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: tabIndex == 0 ? Colors.white : kDarkGrey)),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(1),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(color: tabIndex == 1 ? kPrimaryColor : Colors.transparent, borderRadius: kBorderRadius8),
                child: Text("Route", textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: tabIndex == 1 ? Colors.white : kDarkGrey)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StopItem extends StatelessWidget {
  const _StopItem({required this.stop, required this.isMorning, required this.isLast});
  final Stop stop;
  final bool isMorning;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final isPickup = stop.isMyPickup;
    final isDrop = stop.isMyDrop;
    final isMyStop = isPickup || isDrop;
    final dotColor = isMyStop ? kPrimaryColor : kGrey;
    final time = isMorning ? stop.morningTime : stop.eveningTime;

    // Use API's my_stop_label directly
    final label = stop.myStopLabel;
    final labelColor = isPickup ? kGreen : isDrop ? kOrange : kPrimaryColor;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stepper dot + line
          SizedBox(
            width: 28,
            child: Column(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: dotColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.location_on, color: dotColor, size: 16),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: kPrimaryColor.withValues(alpha: 0.3),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          stop.name,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isMyStop ? kBlack : kDarkGrey),
                        ),
                      ),
                      if (label != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: labelColor.withValues(alpha: 0.12),
                            borderRadius: kBorderRadius8,
                          ),
                          child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: labelColor)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Expanded(child: Text("Distance to next stop", style: TextStyle(fontSize: 12, color: kPrimaryColor))),
                      const Text("12 Km", style: TextStyle(fontSize: 12, color: kDarkGrey)),
                    ],
                  ),
                  Row(
                    children: [
                      const Expanded(child: Text("Time of Arrival", style: TextStyle(fontSize: 12, color: kPrimaryColor))),
                      Text(time, style: const TextStyle(fontSize: 12, color: kDarkGrey)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomStudentCard extends StatelessWidget {
  const _BottomStudentCard({required this.student, this.driverName, this.driverMobile});
  final Student student;
  final String? driverName;
  final String? driverMobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(12, 8, 12, MediaQuery.of(context).viewPadding.bottom + 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: kPrimaryColor, borderRadius: kBorderRadius20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: kLightGrey,
                backgroundImage: student.profilePicUrl != null ? NetworkImage(student.profilePicUrl!) : null,
                child: student.profilePicUrl == null ? const Icon(Icons.person, color: kGrey) : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(student.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
                    Text(student.classSection, style: const TextStyle(fontSize: 12, color: Colors.white70)),
                  ],
                ),
              ),
              const Icon(Icons.more_vert, color: Colors.white70, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Divider(height: 1, color: Colors.white.withValues(alpha: 0.2)),
          const SizedBox(height: 8),
          const Row(children: [Text("ETA:", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white70))]),
          const SizedBox(height: 8),
          Row(
            children: [
              if (driverMobile != null && driverMobile!.isNotEmpty)
                Expanded(
                  child: GestureDetector(
                    onTap: () => launchUrl(Uri.parse("tel:$driverMobile")),
                    child: const Row(children: [Icon(Icons.phone, size: 16, color: Colors.white), SizedBox(width: 6), Text("Driver", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white))]),
                  ),
                ),
              const Expanded(
                child: Row(children: [Icon(Icons.phone, size: 16, color: Colors.white), SizedBox(width: 6), Text("Transport Admin", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white))]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
