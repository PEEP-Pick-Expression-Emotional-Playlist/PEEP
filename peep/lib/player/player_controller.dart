import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PlayerController extends StatelessWidget {
  const PlayerController({
    Key key,
    this.previousSize, this.playSize, this.nextSize,
    this.prevIconName, this.playIconName, this.nextIconName,
  }) : super(key: key);

  final double previousSize;
  final double playSize;
  final double nextSize;

  final String prevIconName;
  final String playIconName;
  final String nextIconName;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          icon: SvgPicture.asset(
            'assets/icons/'+prevIconName+'.svg',
            fit: BoxFit.contain,
          ),
          iconSize: previousSize,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
                new SnackBar(content: Text('onPressed Previous Button')));
          },
        ),
        IconButton(
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          icon: SvgPicture.asset('assets/icons/'+playIconName+'.svg',fit: BoxFit.scaleDown,),
          iconSize: playSize,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
                new SnackBar(content: Text('onPressed Play Button')));
          },
        ),
        IconButton(
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          icon: SvgPicture.asset('assets/icons/'+nextIconName+'.svg'),
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