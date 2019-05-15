import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:audioplayers/audio_cache.dart';

enum BoardThemeColors { LIGHT, DARK, HIGHLIGHT, HIGHLIGHT2 }

class WidgetUtils {
  static const Map<BoardThemeColors, Color> THEME_COLORS = {
    BoardThemeColors.LIGHT: Color.fromARGB(255, 244, 243, 230),
    BoardThemeColors.DARK: Color.fromARGB(255, 59, 99, 43),
    BoardThemeColors.HIGHLIGHT: Color.fromARGB(255, 244, 244, 100),
    BoardThemeColors.HIGHLIGHT2: Color.fromARGB(160, 244, 244, 100)
  };

  static getPieceByType(String type, num size) {
    switch (type) {
      case 'br':
        return BlackRook(
          size: size,
        );
      case 'bn':
        return BlackKnight(
          size: size,
        );
      case 'bb':
        return BlackBishop(
          size: size,
        );
      case 'bq':
        return BlackQueen(
          size: size,
        );
      case 'bk':
        return BlackKing(
          size: size,
        );
      case 'bp':
        return BlackPawn(
          size: size,
        );
      case 'wr':
        return WhiteRook(
          size: size,
        );
      case 'wn':
        return WhiteKnight(
          size: size,
        );
      case 'wb':
        return WhiteBishop(
          size: size,
        );
      case 'wq':
        return WhiteQueen(
          size: size,
        );
      case 'wk':
        return WhiteKing(
          size: size,
        );
      case 'wp':
        return WhitePawn(
          size: size,
        );
      default:
        return Container();
    }
  }

  static AudioCache _player = new AudioCache();

  static void playMoveSound() {
    _player.play('board_1.mp3');
  }

  static void playMoveSoundAlternate() {
    _player.play('board_2.mp3');
  }

  static void playAlertSound() {
    _player.play('alert_1.mp3');
  }
}
