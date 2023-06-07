import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../models/game_brand.dart';
import '../../services/logo_api.dart';
import '../game/game.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<GameBrand> _brands = <GameBrand>[];

  // for show loading indicator
  bool _fetchingBrands = false;
  // for show error
  bool _fetchingBrandsError = false;

  /*
  ** Get brands from api and turn them GameBrand
  ** object and store them _brands list
  */
  Future<void> _initBrands() async {
    setState(() {
      _fetchingBrands = true;
    });

    for (var b in brandDomainList) {
      try {
        final brand = await LogoApi.getBrand(b);
        _brands.add(brand);
      } catch (ex) {
        setState(() {
          _fetchingBrandsError = true;
          _fetchingBrands = false;
        });

        return;
      }
    }

    setState(() {
      _fetchingBrandsError = false;
      _fetchingBrands = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Flutter Logo Quiz',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 36,
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              child: _fetchingBrands
                  ? const Text('Loading...')
                  : _fetchingBrandsError
                      ? const Text('Error')
                      : const Text('Start'),
              onPressed: () async {
                // Send brands list to game page
                if (!_fetchingBrands) {
                  await _initBrands();

                  if (!_fetchingBrandsError) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Game(brands: _brands);
                    }));
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
