import 'package:antichess/model/piece_model.dart';
import 'package:antichess/widgets/util/widget_utils.dart';
import 'package:flutter/cupertino.dart';

class Piece extends StatelessWidget {
  final PieceModel model;
  const Piece({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width * 0.1;
    return Container(
      child: Draggable(
        data: this.model,
        child: WidgetUtils.getPieceByType(this.model.type, size),
        feedback: WidgetUtils.getPieceByType(this.model.type, size*1.5),
        maxSimultaneousDrags: 1,
      ),
    );
  }
}
