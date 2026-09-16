import 'package:flutter_test/flutter_test.dart';
import 'package:library_mobile_app/features/profile/data/models/member_profile_model.dart';

void main() {
  test('maps all member profile response fields', () {
    final profile = MemberProfileModel.fromJson({
      'id': 2,
      'fullName': 'Demo Member',
      'email': 'member@library.local',
      'phoneNumber': null,
      'registeredDate': '2026-09-14T06:00:00Z',
      'isActive': true,
    }).toEntity();

    expect(profile.id, 2);
    expect(profile.fullName, 'Demo Member');
    expect(profile.email, 'member@library.local');
    expect(profile.phoneNumber, isNull);
    expect(profile.registeredDate, DateTime.utc(2026, 9, 14, 6));
    expect(profile.isActive, isTrue);
  });
}
