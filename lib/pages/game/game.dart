import 'package:flutter/material.dart';

import '../../models/game_brand.dart';
import '../../services/shared_prefs.dart';
import 'components/game_level.dart';

class Game extends StatefulWidget {
  final List<GameBrand> brands;

  const Game({Key? key, required this.brands}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  int _currentLevel = 0;

  @override
  void initState() {
    super.initState();

    SharedPrefs.clearTotalScore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildLevels(),
    );
  }

  /*
  ** Builds game pages and send them
  ** brand, level number and current level number
  ** For stop timer in level page game controls
  ** the page number equal to current page number
  */
  Widget _buildLevels() {
    return SafeArea(
      child: PageView.builder(
        onPageChanged: (pageIndex) {
          setState(() {
            _currentLevel = pageIndex;
          });
        },
        itemCount: widget.brands.length,
        itemBuilder: (BuildContext context, int index) {
          return GameLevel(
              gameBrand: widget.brands[index],
              levelNumber: index,
              currentLevel: _currentLevel);
        },
      ),
    );
  }
}
