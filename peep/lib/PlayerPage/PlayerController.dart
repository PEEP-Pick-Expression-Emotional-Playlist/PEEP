import 'package:flutter/material.dart';

class PlayerController extends StatelessWidget {
  const PlayerController({
    Key key,
    this.previousSize,
    this.playSize,
    this.nextSize,
  }) : super(key: key);

  final double previousSize;
  final double playSize;
  final double nextSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        IconButton(
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          icon: Icon(Icons.skip_previous_rounded),
          iconSize: previousSize,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
                new SnackBar(content: Text('onPressed Previous Button')));
          },
        ),
        IconButton(
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          icon: Icon(Icons.play_arrow_rounded),
          iconSize: playSize,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
                new SnackBar(content: Text('onPressed Play Button')));
          },
        ),
        IconButton(
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          icon: Icon(Icons.skip_next_rounded),
          iconSize: nextSize,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
              content: Text('onPressed Next Button'),
            ));
          },
        ),
      ],
    );
  }
}