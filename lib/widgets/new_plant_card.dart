import 'package:flutter/material.dart';

class NewPlantCard extends StatelessWidget {
  const NewPlantCard({Key key, this.onPress, this.imageLink, this.title})
      : super(key: key);

  final Function onPress;
  final String imageLink;
  final String title;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              colors: [
                Colors.black.withOpacity(.8),
                Colors.black.withOpacity(.1),
              ],
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                  backgroundColor: Colors.black54,
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.9),
              spreadRadius: 3,
              blurRadius: 7,
              offset: Offset(0, 5), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(20),
          image:
              DecorationImage(image: AssetImage(imageLink), fit: BoxFit.cover),
        ),
      ),
    );
  }
}
