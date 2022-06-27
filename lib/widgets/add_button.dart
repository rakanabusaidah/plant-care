import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddButton extends StatelessWidget {
  AddButton({@required this.onPressed});

  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      key: const Key('addButton'),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'اضافة',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 10),
          Icon(
            FontAwesomeIcons.plus,
            color: Colors.white,
            size: 16,
          ),
        ],
      ),
      onPressed: onPressed,
      elevation: 6,
      constraints: const BoxConstraints.tightFor(
        width: 90,
        height: 40,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      fillColor: const Color(0XFFE9AA08),
    );
  }
}
