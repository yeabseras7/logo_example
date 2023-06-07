class LogoFormat {
  final String src;
  final String format;

  const LogoFormat({required this.src, required this.format});

  factory LogoFormat.fromJson(Map<String, dynamic> json) {
    return LogoFormat(
        src: json['src'] as String, format: json['format'] as String);
  }
}
