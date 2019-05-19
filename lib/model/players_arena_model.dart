import 'dart:math';

import 'package:antichess/model/mocks.dart';
import 'package:antichess/model/player_model.dart';
import 'package:flutter/cupertino.dart';

class PlayersArenaModel extends ValueNotifier<PlayerModel> {
  final PlayerModel self;
  PlayersArenaModel(value, this.self) : super(value);

  List<PlayerModel> _players = new List<PlayerModel>();
  List<PlayerModel> _mockPlayers = Mocks.players;
  final _random = Random();

  Future requestOpponent() async {
    await new Future.delayed(const Duration(milliseconds: 1500), () {
      int _index = _random.nextInt(4);
      _index = _index == 0 ? _index + 1 : _index;
      print('Selected random index $_index');
      this.value = _mockPlayers[_index];
    });
    // await new Future.delayed(const Duration(milliseconds: 1500), () async {
    //   if (_players.length == 0) {
    //     await enterArena();
    //   }
    // });
  }

  Future enterArena() async {
    await new Future.delayed(const Duration(milliseconds: 500), () {
      _players.add(this.self);
    });
  }

  Future leaveArena() async {
    await new Future.delayed(const Duration(milliseconds: 500), () {
      if (_players.contains(this.self)) _players.remove(this.self);
    });
  }
}
