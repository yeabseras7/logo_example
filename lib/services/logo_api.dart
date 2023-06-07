import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/brand.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/game_brand.dart';

class LogoApi {
  static Future<GameBrand> getBrand(String brandDomain) async {
    // Get api key
    final brandtoken =
        dotenv.env['s1it4un3DhuOQMuTs1of4RPHAoBDE/v6hMveRzizkvw='];

    final response = await http.get(
        Uri.parse('https://api.brandfetch.io/v2/brands/$brandDomain'),
        headers: {'Authorization': 'Bearer $brandtoken'});

    if (response.statusCode == 200) {
      final brand = Brand.fromJson(jsonDecode(response.body));

      final gameBrand = GameBrand(
          name: brand.name,
          description: brand.description,
          icon: brand.logos.firstWhere((l) => l.type == 'icon').formats[0].src,
          logo: brand.logos
              .firstWhere((l) => l.type == 'logo')
              .formats
              .firstWhere((f) => f.format == 'svg')
              .src);

      return gameBrand;
    } else {
      throw Exception('Failed to fetch brand');
    }
  }
}
