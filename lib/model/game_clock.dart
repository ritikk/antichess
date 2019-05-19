import 'dart:async';

class GameClock {
  final Function onTimeout;
  final Duration gameDuration;
  Timer _timer;
  final Stopwatch _watchWhite;
  final Stopwatch _watchBlack;

  GameClock(gameDuration, onTimeout)
      : this.onTimeout = onTimeout,
        this.gameDuration = gameDuration,
        this._watchWhite = Stopwatch(),
        this._watchBlack = Stopwatch();

  void turnWhite() {
    _watchBlack.stop();
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
    }
    _timer = Timer(gameDuration - _watchWhite.elapsed, () {
      stopClock();
      onTimeout('w');
    });
    _watchWhite.start();
  }

  void turnBlack() {
    _watchWhite.stop();
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
    }
    _timer = Timer(gameDuration - _watchBlack.elapsed, () {
      stopClock();
      onTimeout('b');
    });
    _watchBlack.start();
  }

  void stopClock() {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
    }
    _watchWhite.stop();
    _watchBlack.stop();
  }

  String getWhiteTimeLeft() {
    return (gameDuration - _watchWhite.elapsed).inSeconds.toString();
  }

  String getBlackTimeLeft() {
    return (gameDuration - _watchBlack.elapsed).inSeconds.toString();
  }
}
