import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_svg/flutter_svg.dart';

import '../../../helpers.dart';
import '../../../models/game_brand.dart';
import '../../../services/shared_prefs.dart';

class GameLevel extends StatefulWidget {
  final GameBrand gameBrand;
  final int levelNumber;
  final int currentLevel;

  const GameLevel(
      {Key? key,
      required this.gameBrand,
      required this.levelNumber,
      required this.currentLevel})
      : super(key: key);

  @override
  State<GameLevel> createState() => _GameLevelState();
}

class _GameLevelState extends State<GameLevel>
    with AutomaticKeepAliveClientMixin {
  final List<String> _selectedLetters = [];
  final ValueNotifier<int> _seconds = ValueNotifier<int>(300);
  final ValueNotifier<int> _score = ValueNotifier<int>(0);

  late final Timer _timer;

  bool _levelComplete = false;
  bool? _success;
  bool _isLevelStarted = false;
  int _letterOrder = 0;
  int _totalScore = 0;
  double _iconFlipValue = 0;
  double _descriptionOpacity = 1.0;
  String _iconOrLogo = 'icon';
  List<String> _shuffledBrandNameCharList = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // Shuffle brand name characters for game buttons
    _shuffledBrandNameCharList = widget.gameBrand.name.characters.toList();
    _shuffledBrandNameCharList.shuffle();

    for (int i = 0; i < _shuffledBrandNameCharList.length; i++) {
      _selectedLetters.add('_');
    }

    _timer = Timer.periodic(
      const Duration(milliseconds: 1000),
      (timer) {
        if (_isLevelStarted &&
            widget.currentLevel == widget.levelNumber &&
            !_levelComplete) {
          _seconds.value--;

          if (_seconds.value <= 0) {
            setState(() {
              _score.value = 0;
              _levelComplete = true;
              _success = false;
              _iconFlipValue = 1;
              _descriptionOpacity = 0.0;
              _printTotalScore();
            });
          }
        }
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      children: [
        const Spacer(),
        // Level number, complete indicator, time
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _levelNumber(),
            _levelCompleteIndicator(),
            _levelScore(),
            if (_levelComplete) _levelTotalScore(),
            _levelTime(),
          ],
        ),
        const Spacer(),
        // Icon
        _levelIcon(),
        const Spacer(),
        // Brand letters or description
        AnimatedOpacity(
            onEnd: () {
              setState(() {
                _descriptionOpacity = 1.0;
              });
            },
            duration: const Duration(milliseconds: 500),
            opacity: _descriptionOpacity,
            child: _brandNameOrDescription()),
        const Spacer(),
        // Brand name buttons
        if (!_levelComplete) _brandNameButtons(),
        const Spacer(),
      ],
    );
  }

  Widget _levelCompleteIndicator() {
    return Icon(Icons.verified,
        color: _levelComplete && _success == false
            ? Colors.red
            : _levelComplete && _success == true
                ? Colors.green
                : Colors.grey,
        size: 60);
  }

  Widget _levelNumber() {
    return Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black12, width: 3),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.3),
                blurRadius: 10,
                offset: const Offset(0, 0))
          ],
          gradient: const LinearGradient(
              colors: [Colors.blue, Color.fromARGB(255, 8, 114, 201)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: Text('${widget.levelNumber + 1}',
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white)));
  }

  Widget _levelTime() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12, width: 3),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(.3),
              blurRadius: 10,
              offset: const Offset(0, 0))
        ],
        gradient: const LinearGradient(
            colors: [Colors.blue, Color.fromARGB(255, 8, 114, 201)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ValueListenableBuilder(
            valueListenable: _seconds,
            builder: (context, value, child) {
              return Text(timeFormat(_seconds.value),
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white));
            }),
      ),
    );
  }

  Widget _levelScore() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12, width: 3),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(.3),
              blurRadius: 10,
              offset: const Offset(0, 0))
        ],
        gradient: const LinearGradient(
            colors: [Colors.orange, Colors.deepOrange],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ValueListenableBuilder(
            valueListenable: _score,
            builder: (context, value, child) {
              return Text(_score.value.toString(),
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white));
            }),
      ),
    );
  }

  Widget _levelTotalScore() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12, width: 3),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(.3),
              blurRadius: 10,
              offset: const Offset(0, 0))
        ],
        gradient: const LinearGradient(
            colors: [Colors.red, Colors.brown],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ValueListenableBuilder(
            valueListenable: _score,
            builder: (context, value, child) {
              return Text(_totalScore.toString(),
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white));
            }),
      ),
    );
  }

  Widget _levelIcon() {
    return AnimatedContainer(
      onEnd: () {
        setState(() {
          _iconOrLogo = 'logo';
          _iconFlipValue = 2;
        });
      },
      duration: const Duration(milliseconds: 1000),
      transform: Matrix4.rotationY(_iconFlipValue * math.pi),
      transformAlignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(color: Colors.black12, width: 175, height: 175),
          Container(color: Colors.white, width: 150, height: 150),
          SizedBox(
            width: 125,
            height: 125,
            child: _iconOrLogo == 'icon'
                ? Image.network(
                    widget.gameBrand.icon,
                    fit: BoxFit.contain,
                    cacheWidth: 100,
                    cacheHeight: 100,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error),
                  )
                : SvgPicture.network(
                    widget.gameBrand.logo,
                    fit: BoxFit.contain,
                    placeholderBuilder: (context) {
                      return const CircularProgressIndicator();
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _brandNameOrDescription() {
    return _levelComplete
        ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              Text(
                widget.gameBrand.name,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                widget.gameBrand.description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
            ]),
          )
        : Padding(
            padding: const EdgeInsets.all(8),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 5,
              runSpacing: 5,
              children: _selectedLetters
                  .asMap()
                  .entries
                  .map<Widget>((e) => ElevatedButton(
                      onPressed: () {},
                      child: Text(e.value),
                      style: ElevatedButton.styleFrom(
                          primary: _levelComplete
                              ? Colors.green
                              : _letterOrder == e.key
                                  ? Colors.red
                                  : Colors.blue)))
                  .toList(),
            ),
          );
  }

  Widget _brandNameButtons() {
    List<Widget> wrapChildren = _shuffledBrandNameCharList
        .map<Widget>((c) => ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                primary: Colors.blueGrey,
                textStyle: const TextStyle(fontSize: 18)),
            onPressed: () {
              setState(() {
                if (!_isLevelStarted) {
                  _isLevelStarted = true;
                }

                if (widget.gameBrand.name[_letterOrder] == c) {
                  _selectedLetters[_letterOrder] = c;
                  _letterOrder++;
                  _score.value += 10;

                  if (_letterOrder == widget.gameBrand.name.length) {
                    _levelComplete = true;
                    _success = true;
                    _iconFlipValue = 1;
                    _descriptionOpacity = 0.0;
                    _printTotalScore();
                  }
                } else {
                  _score.value -= 1;
                }
              });
            },
            child: Text(c)))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 5,
          runSpacing: 5,
          children: wrapChildren),
    );
  }

  Future<void> _printTotalScore() async {
    int tscore = await SharedPrefs.getTotalScore();
    tscore += _score.value;
    await SharedPrefs.setTotalScore(tscore);

    setState(() {
      _totalScore = tscore;
    });
  }
}
