import 'package:antichess/widgets/square.dart';
import 'package:antichess/widgets/util/widget_utils.dart';
import 'package:flutter/cupertino.dart';

class ChessBoard extends StatelessWidget {
  const ChessBoard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var squares = _drawBoard();
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      child: GridView.count(
        crossAxisCount: 8,
        children: squares,
      ),
    );
  }

  _drawBoard() {
    bool _isLight = true;
    List<Square> _squares = new List<Square>();

    final Color _lightColor = WidgetUtils.THEME_COLORS[BoardThemeColors.LIGHT];
    final Color _darkColor = WidgetUtils.THEME_COLORS[BoardThemeColors.DARK];

    for (int i = 1; i < 65; i++) {
      if (i % 8 == 1 && i > 8) {
        _isLight = !_isLight;
      }
      _squares.add(Square(
        color: _isLight ? _lightColor : _darkColor,
        name: _getName(i),
      ));
      _isLight = !_isLight;
    }
    return _squares;
  }

  _getName(int number) {
    String _name;
    final int _remainder = number % 8;
    const List<String> _cols = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];
    _name = _cols.elementAt(_remainder == 0 ? 7 : _remainder - 1);
    final int _quotient = number ~/ 8;
    final int _rowNo = _remainder == 0 ? 8 - _quotient + 1 : 8 - _quotient;
    _name = _name + _rowNo.toString();
    return _name;
  }
}
