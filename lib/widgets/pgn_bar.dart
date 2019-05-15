import 'package:antichess/model/game_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class PGNBar extends StatelessWidget {
  const PGNBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<GameModel>(context);
    return Container(
      color: CupertinoColors.lightBackgroundGray,
      height: 30,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 5,
            ),
            Text(model.getPGN())
          ],
        ),
      ),
    );
  }
}
