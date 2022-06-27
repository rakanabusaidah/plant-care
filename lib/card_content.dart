import 'package:flutter/material.dart';
import 'constants.dart';

class CardContent extends StatelessWidget {
  CardContent(
      {@required this.cardIcon,
      @required this.cardText,
      @required this.iconSize});

  final IconData cardIcon;
  final String cardText;
  final double iconSize;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          cardIcon,
          size: iconSize,
          color: Color(0XFFFDFBF9),
        ),
        SizedBox(
          height: 5,
        ),
        Text(cardText, style: kAppTitlesTextStyle),
      ],
    );
  }
}
