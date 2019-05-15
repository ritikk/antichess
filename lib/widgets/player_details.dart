import 'package:antichess/model/game_model.dart';
import 'package:antichess/widgets/util/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class PlayerDetails extends StatelessWidget {
  final String playerData;
  final String timeLeft;
  final String color;
  const PlayerDetails({
    Key key,
    @required this.playerData,
    @required this.timeLeft,
    @required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GameModel model = Provider.of<GameModel>(context);
    return Row(
      children: <Widget>[
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                playerData,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Wrap(
                children: model
                    .getPiecesCaptured(this.color)
                    .map<Widget>((p) => WidgetUtils.getPieceByType(p, 20.0))
                    .toList(),
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: Text(timeLeft),
          color: CupertinoColors.extraLightBackgroundGray,
        ),
        SizedBox(
          width: 10,
        )
      ],
    );
  }
}
