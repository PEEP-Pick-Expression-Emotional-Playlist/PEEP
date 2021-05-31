import 'package:flutter/material.dart';

class PlayCards extends StatelessWidget {
  final List<Widget> cards;

  const PlayCards({Key key, this.cards}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio:5/6,
        scrollDirection: Axis.horizontal,
        children: cards,
      ),
    );
  }
}

class CardData {
  CardData(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color color;
}