import 'package:antichess/model/game_players_model.dart';
import 'package:antichess/model/mocks.dart';
import 'package:antichess/model/players_arena_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FindOpponentPage extends StatelessWidget {
  const FindOpponentPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var arena = PlayersArenaModel(null, Mocks.players[0]);
    arena.addListener(() {
      Navigator.of(context).popAndPushNamed('/game',
          arguments: GamePlayersModel(arena.self, arena.value));
    });
    arena.requestOpponent();
    return Container(
      padding: EdgeInsets.fromLTRB(50.0, 200.0, 50.0, 300.0),
      color: CupertinoColors.lightBackgroundGray,
      child: CupertinoPopupSurface(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text(
              'Finding Opponents',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            CupertinoActivityIndicator(
              radius: 30.0,
            ),
            SizedBox(
              height: 50.0,
            ),
            CupertinoButton.filled(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
  }
}
