import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'mid_screen.dart';
import 'global_variables.dart';
import 'dart:math' show Random;

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key key}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.only(top: 50, bottom: 20, left: 10, right: 10),
            child: SingleChildScrollView(
                child: Column(
              children: [
                RainbowAnimatedText(),
                SizedBox(
                  height: 50,
                ),
                Container(height: 400, child: FavoritesGrid())
              ],
            )),
          ),
        );
  }
}

class RainbowAnimatedText extends StatefulWidget {
  const RainbowAnimatedText({Key key}) : super(key: key);

  @override
  _RainbowAnimatedTextState createState() => _RainbowAnimatedTextState();
}

class _RainbowAnimatedTextState extends State<RainbowAnimatedText>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      child: Text(
        "My Favorites",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 45, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      shaderCallback: (rect) {
        return LinearGradient(stops: [
          _animation.value - 0.5,
          _animation.value,
          _animation.value + 0.5
        ], colors: [
          tColor,
          Colors.purple,
          tColor
        ]).createShader((rect));
      },
    );
  }
}

class FavoritesGrid extends StatefulWidget {
  const FavoritesGrid({Key key}) : super(key: key);

  @override
  _FavoritesGridState createState() => _FavoritesGridState();
}

class _FavoritesGridState extends State<FavoritesGrid> {
  List<Widget> gridTiles = [];


  @override
  void initState() {
    _addTiles();
    super.initState();
    print(gridTiles.runtimeType);
  }

  void _addTiles() {
    allObjects.forEach((element) {
      if (prefs.getBool("educam$element") == true) {
        gridTiles.add(TextButton(
          child: Container(
            decoration: BoxDecoration(
              color: primaryColors[Random().nextInt(primaryColors.length)],
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            child: CachedNetworkImage(
              imageUrl: objectKeys[element.toLowerCase()]["ui_img"],
              fit: BoxFit.fitHeight,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  CircularProgressIndicator(value: downloadProgress.progress),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DescScreen(entity: element),
                  settings: RouteSettings(name: "Description Screen - $element")),
            );
          },
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (gridTiles.length > 0) {
      return GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 2 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20),
          itemCount: gridTiles.length,
          itemBuilder: (BuildContext context, int index) {
            return gridTiles[index];
          });
    } else {
      return Center(
          child: Container(
            child: Text(
              "No Favourites for now ¯" + r'\' + "_(ツ)_/¯",
              style: TextStyle(fontWeight: FontWeight.w700, color: Colors.purple),
            ),
          ));
    }}
  }
