import 'logo_format.dart';

class Logo {
  final String type;
  final List<LogoFormat> formats;

  const Logo({required this.type, required this.formats});

  factory Logo.fromJson(Map<String, dynamic> json) {
    return Logo(
        type: json['type'] as String,
        formats: json['formats']
            .map<LogoFormat>((f) => LogoFormat.fromJson(f))
            .toList());
  }
}
