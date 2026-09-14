import '../../domain/entities/member_profile.dart';

class MemberProfileModel {
  final int id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final DateTime registeredDate;
  final bool isActive;

  const MemberProfileModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.registeredDate,
    required this.isActive,
  });

  factory MemberProfileModel.fromJson(Map<String, dynamic> json) {
    return MemberProfileModel(
      id: json['id'] as int,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      registeredDate: DateTime.parse(json['registeredDate'] as String),
      isActive: json['isActive'] as bool,
    );
  }

  MemberProfile toEntity() {
    return MemberProfile(
      id: id,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      registeredDate: registeredDate,
      isActive: isActive,
    );
  }
}
