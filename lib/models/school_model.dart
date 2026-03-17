import '../services/api_service.dart';

class School {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? pincode;
  final String? logoUrl;
  final String? schoolPicture;
  final String? website;
  final String? principalName;
  final String? board;

  School({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.address,
    this.city,
    this.state,
    this.country,
    this.pincode,
    this.logoUrl,
    this.schoolPicture,
    this.website,
    this.principalName,
    this.board,
  });

  String get fullAddress {
    final parts = [address, city, state].where((e) => e != null && e.isNotEmpty);
    return parts.join(', ');
  }

  String? get logoFullUrl {
    if (logoUrl == null || logoUrl!.isEmpty) return null;
    return "${ApiService.baseUrl}/$logoUrl";
  }

  String? get pictureFullUrl {
    if (schoolPicture == null || schoolPicture!.isEmpty) return null;
    return "${ApiService.baseUrl}/$schoolPicture";
  }

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      id: "${json['id']}",
      name: json['name'] ?? '',
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      pincode: json['pincode'],
      logoUrl: json['logo_url'],
      schoolPicture: json['school_picture'],
      website: json['website'],
      principalName: json['principal_name'],
      board: json['board'],
    );
  }
}