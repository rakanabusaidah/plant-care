import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DeleteButton extends StatelessWidget {
  DeleteButton({@required this.onPressed});

  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'حذف جميع التنبيهات',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 10),
          Icon(
            FontAwesomeIcons.trash,
            color: Colors.white,
            size: 16,
          ),
        ],
      ),
      onPressed: onPressed,
      elevation: 2,
      constraints: BoxConstraints.tightFor(
        width: 120,
        height: 40,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      fillColor: Colors.red,
    );
  }
}
