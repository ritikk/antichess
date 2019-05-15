import 'package:antichess/model/game_model.dart';
import 'package:antichess/model/piece_model.dart';
import 'package:antichess/widgets/piece.dart';
import 'package:antichess/widgets/util/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Square extends StatelessWidget {
  Square({Key key, @required this.color, @required this.name})
      : super(key: key);

  final Color color;
  final String name;

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<GameModel>(context);
    final pieceType = model.getPieceAtSquare(name);
    final pieceModel = PieceModel(type: pieceType, square: name);
    return DragTarget(
      builder: (context, candidates, rejected) {
        return GestureDetector(
          onTap: () {
            // An empty square has been tapped.
            // If a piece is already selected, attempt move
            if (model.getSelectedPiece() != null) {
              _handleMove(model, model.getSelectedPiece(), context);
            }
          },
          child: Container(
            color: _getSquareColor(candidates, model),
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 3, top: 3),
                  child: Text(
                    name,
                    style: TextStyle(
                        color: CupertinoColors.inactiveGray, fontSize: 10.0),
                  ),
                ),
                Center(
                  child: GestureDetector(
                    child: Piece(
                      model: pieceModel,
                    ),
                    onTap: () {
                      if (pieceType != null &&
                          pieceType[0] == model.getTurn()) {
                        // Tapped on own piece, select the piece
                        model.selectPiece(pieceModel);
                      } else {
                        // Tapped on opponent's piece, attempt capture
                        if (model.getSelectedPiece() != null) {
                          _handleMove(model, model.getSelectedPiece(), context);
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
      onWillAccept: (data) {
        return true;
      },
      onAccept: (PieceModel piece) {
        return _handleMove(model, piece, context);
      },
    );
  }

  Color _getSquareColor(List candidates, GameModel model) {
    // Piece is hovering over square, highlight
    if (candidates.length > 0)
      return WidgetUtils.THEME_COLORS[BoardThemeColors.HIGHLIGHT];

    // Piece is selected, highlight
    if (model.getSelectedPiece() != null &&
        model.getSelectedPiece().square == name)
      return WidgetUtils.THEME_COLORS[BoardThemeColors.HIGHLIGHT];

    // Square was part of last move, highlight
    var _lastMove = model.getLastMove();
    if (_lastMove != null &&
        (_lastMove['from'] == name || _lastMove['to'] == name))
      return WidgetUtils.THEME_COLORS[BoardThemeColors.HIGHLIGHT2];

    // Normal square, don't highlight
    return color;
  }

  bool _handleMove(GameModel model, PieceModel piece, BuildContext context) {
    var turn = model.getTurn();
    //check if pawn is being promoted
    var shouldAskToPromote = piece.type.endsWith('p') &&
        ((turn == 'w' && name[1] == '8') || (turn == 'b' && name[1] == '1'));
    if (shouldAskToPromote) {
      _showPromotionOptions(context, turn).then((value) {
        var success = model.tryMove(
            source: piece.square, destination: name, promoteTo: value);
        _playSound(success, turn);
      });
    } else {
      var success = model.tryMove(source: piece.square, destination: name);
      _playSound(success, turn);
    }
    print("Move: from ${piece.square} to $name");
    return true;
  }

  void _playSound(bool success, String turn) {
    if (success) {
      if (turn == 'w') {
        WidgetUtils.playMoveSound();
      } else {
        WidgetUtils.playMoveSoundAlternate();
      }
    } else {
      WidgetUtils.playAlertSound();
    }
  }

  Future<String> _showPromotionOptions(
      BuildContext context, String color) async {
    return showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            title: Text('Promote Pawn'),
            message: Text('Select how you want to promote this Pawn.'),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    WidgetUtils.getPieceByType(color + 'k', 20.0),
                    SizedBox(
                      width: 10,
                    ),
                    Text('King'),
                  ],
                ),
                onPressed: () {
                  Navigator.of(context).pop('k');
                },
              ),
              CupertinoActionSheetAction(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    WidgetUtils.getPieceByType(color + 'q', 20.0),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Queen'),
                  ],
                ),
                onPressed: () {
                  Navigator.of(context).pop('q');
                },
              ),
              CupertinoActionSheetAction(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    WidgetUtils.getPieceByType(color + 'r', 20.0),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Rook'),
                  ],
                ),
                onPressed: () {
                  Navigator.of(context).pop('r');
                },
              ),
              CupertinoActionSheetAction(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    WidgetUtils.getPieceByType(color + 'b', 20.0),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Bishop'),
                  ],
                ),
                onPressed: () {
                  Navigator.of(context).pop('b');
                },
              ),
              CupertinoActionSheetAction(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    WidgetUtils.getPieceByType(color + 'n', 20.0),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Knight'),
                  ],
                ),
                onPressed: () {
                  Navigator.of(context).pop('n');
                },
              ),
            ],
          );
        }).then((value) {
      return value;
    });
  }
}
