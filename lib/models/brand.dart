import 'logo.dart';

class Brand {
  final String name;
  final String description;
  final List<Logo> logos;

  const Brand(
      {required this.name, required this.description, required this.logos});

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
        name: json['name'] as String,
        description: json['description'] as String,
        logos: json['logos'].map<Logo>((l) => Logo.fromJson(l)).toList());
  }
}
