import 'package:antichess/widgets/find_opponent_page.dart';
import 'package:antichess/widgets/game_page.dart';
import 'package:antichess/widgets/home_page.dart';
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
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/': (context) => HomePage(),
        '/game': (context) => ChangeNotifierProvider<GameModel>(
            builder: (_) => GameModel(new chess.Chess()), child: GamePage()),
        '/find-opponent': (context) => FindOpponentPage(),
      },
    );
  }
}
