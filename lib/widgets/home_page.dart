import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          'Anti Chess Rules',
          style: TextStyle(color: CupertinoColors.white, fontSize: 20.0),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: CupertinoColors.darkBackgroundGray,
        actionsForegroundColor: CupertinoColors.white,
      ),
      child: Material(
        child: ListView(
          padding: EdgeInsets.only(top: 20.0),
          primary: true,
          shrinkWrap: true,
          children: <Widget>[
            ListTile(
              leading: Icon(CupertinoIcons.right_chevron),
              title: Text('Capturing'),
              subtitle: Text(
                  'Capturing is compulsory. If a player can capture a piece including the king, it must be captured. If multiple pieces are available for capture, player may choose.'),
            ),
            ListTile(
              leading: Icon(CupertinoIcons.right_chevron),
              title: Text('Check & Checkmate'),
              subtitle: Text(
                  'There is no check or checkmate. The king has no royal power and may expose itself to capture.'),
            ),
            ListTile(
              leading: Icon(CupertinoIcons.right_chevron),
              title: Text('Castling'),
              subtitle: Text('Castling is not allowed.'),
            ),
            ListTile(
              leading: Icon(CupertinoIcons.right_chevron),
              title: Text('Promotion'),
              subtitle: Text('A pawn may be promoted to a king.'),
            ),
            ListTile(
              leading: Icon(CupertinoIcons.right_chevron),
              title: Text('Win'),
              subtitle: Text(
                  'Player can win by losing all their pieces or by being stalemated.'),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: CupertinoButton.filled(
                      child: Text('NEW GAME', style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold
                      ),),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/game');
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
