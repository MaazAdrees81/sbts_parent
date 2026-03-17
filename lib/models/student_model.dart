import '../services/api_service.dart';

class Student {
  final String id;
  final String schoolId;
  final String parentId;
  final String? stopId;
  final String? admissionNo;
  final String name;
  final String? className;
  final String? section;
  final String? rollNumber;
  final String? gender;
  final String? dateOfBirth;
  final String? bloodGroup;
  final String? profilePic;
  final String? pickupStopId;
  final String? dropStopId;
  final String? pickupStopRouteId;
  final String? dropStopRouteId;
  final String? pickupStopName;
  final String? dropStopName;
  final String? pickupMorningTime;
  final String? dropEveningTime;
  final String? stopName;
  final String? stopSequence;
  final String? parentName;
  final String? parentMobile;
  final String? parentEmail;
  final FamilyData? family;






  Student({
    required this.id,
    required this.schoolId,
    required this.parentId,
    this.stopId,
    this.admissionNo,
    required this.name,
    this.className,
    this.section,
    this.rollNumber,
    this.gender,
    this.dateOfBirth,
    this.bloodGroup,
    this.profilePic,
    this.pickupStopId,
    this.dropStopId,
    this.pickupStopRouteId,
    this.dropStopRouteId,
    this.pickupStopName,
    this.dropStopName,
    this.pickupMorningTime,
    this.dropEveningTime,
    this.stopName,
    this.stopSequence,
    this.parentName,
    this.parentMobile,
    this.parentEmail,
    this.family,
  });

  String get classSection {
    final parts = [className, section].where((e) => e != null && e.isNotEmpty);
    return parts.join(' - ');
  }

  String? get profilePicUrl {
    if (profilePic == null || profilePic!.isEmpty) return null;
    return "${ApiService.baseUrl}/$profilePic";
  }

  List<Guardian> get guardians {
    final list = <Guardian>[];
    if (family == null) return list;
    final f = family!;
    if (f.fatherName != null && f.fatherName!.isNotEmpty) {
      list.add(Guardian(
        name: f.fatherName!,
        relation: "Father",
        mobile: f.fatherMobile,
        email: f.fatherEmail,
        occupation: f.fatherOccupation,
        photo: f.fatherPhoto,
        aadhar: f.fatherAadhar,
      ));
    }
    if (f.motherName != null && f.motherName!.isNotEmpty) {
      list.add(Guardian(
        name: f.motherName!,
        relation: "Mother",
        mobile: f.motherMobile,
        email: f.motherEmail,
        occupation: f.motherOccupation,
        photo: f.motherPhoto,
        aadhar: f.motherAadhar,
      ));
    }
    if (f.guardian1Name != null && f.guardian1Name!.isNotEmpty) {
      list.add(Guardian(
        name: f.guardian1Name!,
        relation: f.guardian1Relation ?? "Guardian",
        mobile: f.guardian1Mobile,
        email: f.guardian1Email,
        photo: f.guardian1Photo,
        aadhar: f.guardian1Aadhar,
      ));
    }
    if (f.guardian2Name != null && f.guardian2Name!.isNotEmpty) {
      list.add(Guardian(
        name: f.guardian2Name!,
        relation: f.guardian2Relation ?? "Guardian",
        mobile: f.guardian2Mobile,
        email: f.guardian2Email,
        photo: f.guardian2Photo,
        aadhar: f.guardian2Aadhar,
      ));
    }
    return list;
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    FamilyData? family;
    if (json['parent'] is Map && json['parent']['family'] is Map) {
      family = FamilyData.fromJson(json['parent']['family']);
    }
    return Student(
      id: "${json['id']}",
      schoolId: "${json['school_id']}",
      parentId: "${json['parent_id']}",
      stopId: json['stop_id']?.toString(),
      admissionNo: json['admission_no'],
      name: json['name'] ?? '',
      className: json['class'],
      section: json['section'],
      rollNumber: json['roll_number'],
      gender: json['gender'],
      dateOfBirth: json['date_of_birth'],
      bloodGroup: json['blood_group'],
      profilePic: json['profile_pic'],
      pickupStopId: json['pickup_stop_id']?.toString(),
      dropStopId: json['drop_stop_id']?.toString(),
      pickupStopRouteId: json['pickup_stop_route_id']?.toString(),
      dropStopRouteId: json['drop_stop_route_id']?.toString(),
      pickupStopName: json['pickup_stop_name'],
      dropStopName: json['drop_stop_name'],
      pickupMorningTime: json['pickup_morning_time'],
      dropEveningTime: json['drop_evening_time'],
      stopName: json['stop_name'],
      stopSequence: json['stop_sequence'],
      parentName: json['parent_name'],
      parentMobile: json['parent_mobile'],
      parentEmail: json['parent_email'],
      family: family,
    );
  }
}

class FamilyData {
  final String? fatherName;
  final String? fatherMobile;
  final String? fatherEmail;
  final String? fatherAadhar;
  final String? fatherOccupation;
  final String? fatherPhoto;
  final String? motherName;
  final String? motherMobile;
  final String? motherEmail;
  final String? motherAadhar;
  final String? motherOccupation;
  final String? motherPhoto;
  final String? guardian1Name;
  final String? guardian1Relation;
  final String? guardian1Mobile;
  final String? guardian1Email;
  final String? guardian1Aadhar;
  final String? guardian1Photo;
  final String? guardian2Name;
  final String? guardian2Relation;
  final String? guardian2Mobile;
  final String? guardian2Email;
  final String? guardian2Aadhar;
  final String? guardian2Photo;
  final String? emergencyContactName;
  final String? emergencyContactMobile;
  final String? emergencyRelation;

  FamilyData({
    this.fatherName,
    this.fatherMobile,
    this.fatherEmail,
    this.fatherAadhar,
    this.fatherOccupation,
    this.fatherPhoto,
    this.motherName,
    this.motherMobile,
    this.motherEmail,
    this.motherAadhar,
    this.motherOccupation,
    this.motherPhoto,
    this.guardian1Name,
    this.guardian1Relation,
    this.guardian1Mobile,
    this.guardian1Email,
    this.guardian1Aadhar,
    this.guardian1Photo,
    this.guardian2Name,
    this.guardian2Relation,
    this.guardian2Mobile,
    this.guardian2Email,
    this.guardian2Aadhar,
    this.guardian2Photo,
    this.emergencyContactName,
    this.emergencyContactMobile,
    this.emergencyRelation,
  });

  factory FamilyData.fromJson(Map<String, dynamic> json) {
    return FamilyData(
      fatherName: json['father_name'],
      fatherMobile: json['father_mobile'],
      fatherEmail: json['father_email'],
      fatherAadhar: json['father_aadhar'],
      fatherOccupation: json['father_occupation'],
      fatherPhoto: json['father_photo'],
      motherName: json['mother_name'],
      motherMobile: json['mother_mobile'],
      motherEmail: json['mother_email'],
      motherAadhar: json['mother_aadhar'],
      motherOccupation: json['mother_occupation'],
      motherPhoto: json['mother_photo'],
      guardian1Name: json['guardian1_name'],
      guardian1Relation: json['guardian1_relation'],
      guardian1Mobile: json['guardian1_mobile'],
      guardian1Email: json['guardian1_email'],
      guardian1Aadhar: json['guardian1_aadhar'],
      guardian1Photo: json['guardian1_photo'],
      guardian2Name: json['guardian2_name'],
      guardian2Relation: json['guardian2_relation'],
      guardian2Mobile: json['guardian2_mobile'],
      guardian2Email: json['guardian2_email'],
      guardian2Aadhar: json['guardian2_aadhar'],
      guardian2Photo: json['guardian2_photo'],
      emergencyContactName: json['emergency_contact_name'],
      emergencyContactMobile: json['emergency_contact_mobile'],
      emergencyRelation: json['emergency_relation'],
    );
  }
}

class Guardian {
  final String name;
  final String relation;
  final String? mobile;
  final String? email;
  final String? occupation;
  final String? photo;
  final String? aadhar;

  Guardian({
    required this.name,
    required this.relation,
    this.mobile,
    this.email,
    this.occupation,
    this.photo,
    this.aadhar,
  });
}
