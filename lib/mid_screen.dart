import 'package:ar_ui/ar_screen.dart';
import 'package:ar_ui/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DescScreen extends StatefulWidget {
  final String entity;

  const DescScreen({Key key, this.entity}) : super(key: key);

  @override
  _DescScreenState createState() => _DescScreenState();
}

class _DescScreenState extends State<DescScreen> {
  String entity;

  @override
  void initState(){
    super.initState();
    this.entity = widget.entity;
  }

  @override
  Widget build(BuildContext context) {
    print(entity.toLowerCase());
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 300),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: Text(
                                entity,
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                  fontFamily: 'Avenir',
                                  fontSize: 42,
                                  color: tColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            HeartFavourite(
                              myEntity: entity,
                            ),
                          ],
                        ),
                        Text(
                          objectKeys[entity.toLowerCase()]["category"],
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            fontSize: 31,
                            color: Color(0xFF414C6B),
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Divider(color: Colors.white),
                        SizedBox(height: 32),
                        Text(
                          objectKeys[entity.toLowerCase()]["description"],
                          style: TextStyle(
                            fontFamily: 'Josefin',
                            fontSize: 20,
                            color: Colors.
                            grey[500],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 32),
                        Divider(color: Colors.black38),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            TopModelView(entity: entity,)
          ],
        ),
      ),
    );
  }
}

class TopModelView extends StatefulWidget {
  final String entity;
  const TopModelView({Key key, this.entity}) : super(key: key);

  @override
  _TopModelViewState createState() => _TopModelViewState();
}

class _TopModelViewState extends State<TopModelView> {
  double modelViewerSize = 300;
  String entity;

  @override
  void initState() {
    super.initState();
    entity = widget.entity;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Stack(alignment: Alignment.bottomRight, children: [
        AnimatedContainer(
            duration: Duration(seconds: 1),
            color: Colors.transparent,
            height: modelViewerSize,
            child: WebView(
              initialUrl:
              "https://joelnadar-thesorceror.github.io/model_viewer/?model_url=${objectKeys[entity.toLowerCase()]["3d_model_URI"]}",
              javascriptMode: JavascriptMode.unrestricted,
            )),
        TextButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ARScreen(entity: entity),
                  settings: RouteSettings(
                      name: "AR placement Screen - $entity")),
            );
          },
          icon: Icon(Icons.camera_sharp, color: Colors.white),
          label:
          Text("View In AR", style: TextStyle(color: Colors.white)),
          style: ButtonStyle(
              backgroundColor:
              MaterialStateProperty.all<Color>(Colors.blue[900])),
        ),
        Positioned(bottom: 0, left: 0, child: IconButton(
          onPressed: () {
            setState(() {
              modelViewerSize == 300 ? modelViewerSize = MediaQuery.of(context).size.height : modelViewerSize = 300;
            });
            print(modelViewerSize);
          },
          icon: Icon(Icons.filter_center_focus, color: Colors.white),
          // style: ButtonStyle(
          //     backgroundColor:
          //     MaterialStateProperty.all<Color>(Colors.grey[800])),
        )),
      ]),
    );
  }
}


class HeartFavourite extends StatefulWidget {
  final String myEntity;

  const HeartFavourite({Key key, this.myEntity}) : super(key: key);

  @override
  _HeartFavouriteState createState() => _HeartFavouriteState();
}

class _HeartFavouriteState extends State<HeartFavourite>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _colorAnimation;
  bool isFavorite;
  String myEntity;

  @override
  void initState() {
    myEntity = widget.myEntity;
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    isFavorite = prefs.getBool("educam$myEntity") ?? false;
    print(isFavorite);
    _colorAnimation = ColorTween(begin: Colors.grey[400], end: Colors.red)
        .animate(_controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget child) {
        return IconButton(
            iconSize: 42,
            padding: EdgeInsets.all(0.0),
            icon: Icon(Icons.favorite,
                color: isFavorite ? Colors.red : _colorAnimation.value),
            onPressed: () async {
              if (isFavorite) {
                _controller.reverse();
                prefs.remove("educam$myEntity");
                isFavorite = false;
              } else {
                _controller.forward();
                prefs.setBool("educam$myEntity", true);
                await prefs.setBool("educam$myEntity", true);
                isFavorite = true;
              }
            });
      },
    );
  }
}
