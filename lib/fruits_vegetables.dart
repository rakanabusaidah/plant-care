import 'package:flutter/material.dart';

class FruitsVegetables extends StatelessWidget {
  static const routeName = '/fruitsvegetables';
  @override
  Widget build(BuildContext context) {
    //final args = ModalRoute.of(context).settings.arguments as List<Plant>;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        centerTitle: true,
        title: Text(
          'إضافة نبات',
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          VegtablesFrutisWidget(
            key: const Key('veg'),
            title: 'خضار',
            imageLink: 'images/vegeetables.jpg',
            dest: '/addvegtables',
          ),
          VegtablesFrutisWidget(
            title: 'فواكه',
            imageLink: 'images/fruits.jpg',
            dest: '/addfruits',
          ),
        ],
      ),
    );
  }
}

class VegtablesFrutisWidget extends StatelessWidget {
  VegtablesFrutisWidget({
    Key key,
    @required this.imageLink,
    @required this.title,
    @required this.dest,
  }) : super(key: key);

  final String imageLink;
  final String title;
  final String dest;

  @override
  Widget build(BuildContext context) {
    //final args = ModalRoute.of(context).settings.arguments as List<Plant>;
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, dest);
        },
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 240,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      image: AssetImage(imageLink), fit: BoxFit.cover),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.bottomRight,
                      colors: [
                        Colors.black.withOpacity(.4),
                        Colors.black.withOpacity(.2),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      title,
                      style: TextStyle(
                          backgroundColor: Colors.black54,
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
