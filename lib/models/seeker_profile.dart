import 'dart:convert';

class SeekerProfile {
  const SeekerProfile({
    required this.name,
    this.phone = '',
    this.address = '',
    this.birthDate,
    this.gender = '',
    this.preferredArea = '',
    this.monthlyBudget = '',
    this.moveInDate,
    this.occupation = '',
  });

  final String name;
  final String phone;
  final String address;
  final DateTime? birthDate;
  final String gender;
  final String preferredArea;
  final String monthlyBudget;
  final DateTime? moveInDate;
  final String occupation;

  int? get age {
    final date = birthDate;
    if (date == null) return null;
    final today = DateTime.now();
    var years = today.year - date.year;
    if (today.month < date.month ||
        (today.month == date.month && today.day < date.day)) {
      years--;
    }
    return years;
  }

  String toJson() => jsonEncode({
    'name': name,
    'phone': phone,
    'address': address,
    'birthDate': birthDate?.toIso8601String(),
    'gender': gender,
    'preferredArea': preferredArea,
    'monthlyBudget': monthlyBudget,
    'moveInDate': moveInDate?.toIso8601String(),
    'occupation': occupation,
  });

  factory SeekerProfile.fromJson(String source) {
    final json = jsonDecode(source) as Map<String, dynamic>;
    return SeekerProfile(
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      address: json['address'] as String? ?? '',
      birthDate: _parseDate(json['birthDate']),
      gender: json['gender'] as String? ?? '',
      preferredArea: json['preferredArea'] as String? ?? '',
      monthlyBudget: json['monthlyBudget'] as String? ?? '',
      moveInDate: _parseDate(json['moveInDate']),
      occupation: json['occupation'] as String? ?? '',
    );
  }

  static DateTime? _parseDate(Object? value) {
    if (value is! String || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }
}
