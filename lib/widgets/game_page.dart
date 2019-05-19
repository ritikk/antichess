import 'package:antichess/model/game_model.dart';
import 'package:antichess/model/game_players_model.dart';
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
  String _winner;

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
          _winner = model.winner;
        });
      }
      setState(() {
        _turn = model.getTurn();
      });
    }

    model.addListener(_updateGameSreen);

    final GamePlayersModel players = ModalRoute.of(context).settings.arguments;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        backgroundColor: CupertinoColors.darkBackgroundGray,
        actionsForegroundColor: CupertinoColors.white,
        leading: CupertinoButton(
          child: Icon(CupertinoIcons.home),
          onPressed: () {
            model.endGame();
            Navigator.pop(context);
          },
        ),
        middle: Text(
          'Anti Chess',
          style: TextStyle(color: CupertinoColors.white, fontSize: 20),
        ),
        trailing: Icon(CupertinoIcons.volume_off),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          PGNBar(),
          PlayerDetails(
            player: players.opponent,
            color: GameModel.BLACK,
            timeLeft: model.timeLeftBlack,
          ),
          ChessBoard(),
          PlayerDetails(
            player: players.self,
            color: GameModel.WHITE,
            timeLeft: model.timeLeftWhite,
          ),
          _isGameOver ? Text('Game Over! $_winner Wins') : Container(),
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
