import 'dart:async';

import 'package:antichess/model/game_clock.dart';
import 'package:antichess/model/piece_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:chess/chess.dart' as chess;

class GameModel with ChangeNotifier {
  chess.Chess _game;
  bool _isGameOver = false;
  StreamController<chess.Move> _streamController;
  PieceModel _selectedPiece;
  Map<String, String> _lastMove;
  GameClock _gameClock;
  String _winner;

  GameModel(this._game) {
    this._streamController = this._getStreamController();
    _gameClock = GameClock(Duration(seconds: 60), _clockTimeOut);
    _gameClock.turnWhite();
  }

  static const String WHITE = 'w';
  static const String BLACK = 'b';

  String get timeLeftWhite {
    return _gameClock.getWhiteTimeLeft();
  }

  String get timeLeftBlack {
    return _gameClock.getBlackTimeLeft();
  }

  String get winner {
    return _winner;
  }

  void _clockTimeOut(String turn) {
    endGame(winner: turn == WHITE ? BLACK : WHITE);
  }

  StreamController _getStreamController() {
    StreamController<chess.Move> _sc = StreamController();
    _sc.stream.listen((move) {
      _handleMove(move);
    }, onDone: () {
      print("Stream Done.");
    }, onError: (error) {
      print(error);
    });
    return _sc;
  }

  void _handleMove(chess.Move move) {
    _game.make_move(move);
    if (_game.moves({'legal': false}).length == 0) {
      endGame(winner: _game.turn.toString());
    } else {
      _game.turn.toString() == WHITE
          ? _gameClock.turnWhite()
          : _gameClock.turnBlack();
    }
    setLastMove();
    notifyListeners();
  }

  void endGame({String winner}) {
    if (winner != null) {
      _winner = winner;
    }
    _isGameOver = true;
    _streamController.close();
    _gameClock.stopClock();
    notifyListeners();
  }

  String getPieceAtSquare(String squareName) {
    chess.Piece piece = _game.get(squareName);
    if (piece == null) return null;

    return piece.color.toString() + piece.type.toString();
  }

  bool tryMove(
      {@required String source,
      @required String destination,
      String promoteTo}) {
    //unselect any selected pieces
    _selectedPiece = null;
    notifyListeners();

    //get possible moves
    List<chess.Move> moves = _game.moves({'legal': false, 'asObjects': true});
    chess.Move moveObj;

    //check if capture is available
    bool canCapture = moves.where((m) => m.captured != null).length > 0;

    //check if we're promoting to a king
    if (promoteTo == 'k') {
      moveObj = moves.firstWhere(
          (m) =>
              source == m.fromAlgebraic &&
              destination == m.toAlgebraic &&
              'q' == m.promotion.name,
          orElse: () => null);
      if (moveObj != null) {
        chess.PieceType king = chess.PieceType.KING;
        moveObj = new chess.Move(moveObj.color, moveObj.from, moveObj.to,
            moveObj.flags, moveObj.piece, moveObj.captured, king);
      }
    } else {
      moveObj = moves.firstWhere(
          (m) =>
              source == m.fromAlgebraic &&
              destination == m.toAlgebraic &&
              (m.promotion == null ||
                  promoteTo == null ||
                  promoteTo == m.promotion.name),
          orElse: () => null);
    }
    if (moveObj != null) {
      //must capture if available
      if (canCapture && moveObj.captured == null) {
        return false;
      }
      //disallow casling
      if (moveObj.flags == chess.Chess.BITS_QSIDE_CASTLE ||
          moveObj.flags == chess.Chess.BITS_KSIDE_CASTLE) {
        return false;
      }

      //Send the move to the stream
      if (!_streamController.isClosed) _streamController.add(moveObj);
      return true;
    }
    return false;
  }

  void resetGame() {
    _selectedPiece = null;
    _lastMove = null;
    _streamController.close();
    _streamController = this._getStreamController();
    _gameClock.stopClock();
    _gameClock = GameClock(Duration(seconds: 60), this._clockTimeOut);
    _game = chess.Chess();
    _gameClock.turnWhite();
    notifyListeners();
  }

  String getPGN() {
    return _game.pgn();
  }

  bool isGameOver() {
    return _isGameOver;
  }

  void undoLastMove() {
    //throw UnsupportedError('Undo not supported in multiplayer');
    _game.undo();
    notifyListeners();
  }

  num getMoveCount() {
    return _game.history.length;
  }

  String getTurn() {
    return _game.turn.toString();
  }

  List<String> getPiecesCaptured(String color) {
    String _opponent = color == 'w' ? 'b' : 'w';
    return _game.history
        .where(
            (s) => s.move.captured != null && s.move.color.toString() == color)
        .map((s) => _opponent + s.move.captured.name)
        .toList();
  }

  void selectPiece(PieceModel piece) {
    _selectedPiece = piece;
    print('Selected piece ${piece.type} at ${piece.square}');
    notifyListeners();
  }

  PieceModel getSelectedPiece() {
    return _selectedPiece;
  }

  void setLastMove() {
    if (_game.history.length == 0) return null;

    List moves = _game.getHistory({'verbose': true});

    if (moves == null) return null;

    _lastMove = {'from': moves.last['from'], 'to': moves.last['to']};
  }

  Map<String, String> getLastMove() {
    return _lastMove;
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}
