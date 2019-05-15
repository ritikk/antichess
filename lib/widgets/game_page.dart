import 'dart:math';

import 'package:antichess/model/game_model.dart';
import 'package:antichess/model/mocks.dart';
import 'package:antichess/widgets/pgn_bar.dart';
import 'package:antichess/widgets/player_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'chess_board.dart';

class GamePage extends StatefulWidget {
  GamePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  bool _showUndoButton = false;
  bool _isGameOver = false;
  String _turn = 'w';

  @override
  Widget build(BuildContext context) {
    GameModel model = Provider.of<GameModel>(context);

    void _updateGameSreen() {
      if (!_showUndoButton) {
        setState(() {
          _showUndoButton = model.getMoveCount() > 0;
        });
      }
      if (!_isGameOver) {
        setState(() {
          _isGameOver = model.isGameOver();
        });
      }
      setState(() {
        _turn = model.getTurn();
      });
    }

    model.addListener(_updateGameSreen);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        backgroundColor: CupertinoColors.darkBackgroundGray,
        actionsForegroundColor: CupertinoColors.white,
        leading: Icon(CupertinoIcons.conversation_bubble),
        middle: Text(
          'Anti Chess',
          style: TextStyle(color: CupertinoColors.white, fontSize: 20),
        ),
        trailing: Icon(CupertinoIcons.volume_mute),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          PGNBar(),
          PlayerDetails(
            player: Mocks.players[Random(1).nextInt(4)],
            color: GameModel.BLACK,
            timeLeft: '1:00',
          ),
          ChessBoard(),
          PlayerDetails(
            player: Mocks.players[0],
            color: GameModel.WHITE,
            timeLeft: '1:00',
          ),
          _isGameOver ? Text('Game Over! $_turn Wins') : Container(),
          CupertinoButton.filled(
            child: Text('Reset'),
            onPressed: () {
              model.resetGame();
              setState(() {
                _isGameOver = false;
                _showUndoButton = false;
              });
            },
          ),
          SizedBox(height: 10),
          _showUndoButton
              ? CupertinoButton.filled(
                  child: Icon(CupertinoIcons.back),
                  onPressed: () {
                    model.undoLastMove();
                  },
                )
              : Container(),
          Text('Turn: $_turn')
        ],
      ),
    );
  }
}
