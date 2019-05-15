import 'package:antichess/widgets/chess_board.dart';
import 'package:antichess/widgets/pgn_bar.dart';
import 'package:antichess/widgets/player_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chess/chess.dart' as chess;

import 'model/game_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Anti Chess',
      home: ChangeNotifierProvider<GameModel>(
          builder: (_) => GameModel(new chess.Chess()),
          child: MyHomePage(title: 'Anti Chess')),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showUndoButton = false;
  bool _isGameOver = false;
  String _turn = 'White';

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
        leading: Icon(Icons.menu),
        middle: Text(
          'Anti Chess',
          style: TextStyle(color: CupertinoColors.white, fontSize: 20),
        ),
        trailing: Icon(Icons.pages),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          PGNBar(),
          PlayerDetails(
            playerData: 'Ritik Khatwani (1000)',
            timeLeft: '1:00',
            color: 'b',
          ),
          ChessBoard(),
          PlayerDetails(
            playerData: 'Niharika Thakkar (1000)',
            timeLeft: '1:00',
            color: 'w',
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
          Text(_turn)
        ],
      ),
    );
  }
}
