import 'dart:async';
import 'package:ar_ui/mid_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'category_page.dart';
import 'global_variables.dart';
import 'dart:math' show Random;
import 'package:cached_network_image/cached_network_image.dart';
import 'splash_screen.dart';

class HomeScreenV2 extends StatefulWidget {
  const HomeScreenV2({Key key}) : super(key: key);

  @override
  _HomeScreenV2State createState() => _HomeScreenV2State();
}

class _HomeScreenV2State extends State<HomeScreenV2> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: bgColor,
          height: MediaQuery.of(context).size.height,
          child: FilterGallery()),
    );
  }
}

class FilterGallery extends StatefulWidget {
  const FilterGallery({Key key}) : super(key: key);

  @override
  _FilterGalleryState createState() => _FilterGalleryState();
}

class _FilterGalleryState extends State<FilterGallery> {
  String filter = "";
  List<Widget> filterTags = [];
  List<Widget> categoriesItem = [];
  TextEditingController _controller = new TextEditingController();
  ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _addFilterTags();
    _addCategorys();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addCategorys() {
    trendingCategories.forEach((element) {
      categoriesItem.add(TextButton(
        child: Container(
          decoration: BoxDecoration(
            color: primaryColors[Random().nextInt(primaryColors.length)],
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          child: CachedNetworkImage(
            imageUrl: objectKeys[element],
            fit: BoxFit.fitHeight,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                CircularProgressIndicator(value: downloadProgress.progress),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    CategoryPage(myCategory: element.replaceAll("_", " ")),
                settings: RouteSettings(name: "Description Screen - $element")),
          );
        },
      ));
    });
  }

  void _addFilterTags() {
    objectTypes.keys.forEach((element) {
      filterTags.add(Container(
        margin: EdgeInsets.only(right: 10),
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CategoryPage(myCategory: element.replaceAll("_", " ")),
                  settings: RouteSettings(name: "Category Screen - $element")),
            );
          },
          child: Text(
            element,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: "Farro",
                color: Colors.black),
          ),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(secondaryColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.transparent)))),
        ),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      SliverAppBar(
        leading: Container(),
        expandedHeight: 200,
        pinned: true,
        floating: true,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IntroScreen(),
                  ));
            },
            child: Text(
              "HELP",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Farro",
                  color: Colors.grey),
            ),
          )
        ],
        backgroundColor: tColor,
        flexibleSpace: FlexibleSpaceBar(
          titlePadding: EdgeInsets.only(left: 10, bottom: 0, top: 0, right: 0),
          title: TextField(
              controller: _controller,
              onChanged: (text) => setState(() {
                    this.filter = text;
                  }),
              style: TextStyle(color: Colors.blue[900]),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                labelText: "Enter a search term",
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber)),
                focusColor: Colors.blue,
              )),
          background: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(alignment: Alignment.topLeft, child: TitleText()),
                  Container(
                    height: 60,
                    padding:
                        EdgeInsets.only(top: 10, bottom: 10, left: 7, right: 7),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: filterTags,
                    ),
                  ),
                ]),
          ),
        ),
      ),
      returnTypingText(),
      returnMainGallery(),
      returnModelGallery(),
    ]);
  }

  Widget returnMainGallery() => SliverToBoxAdapter(
      child: CarouselSlider(
          items: categoriesItem,
          options: CarouselOptions(
              viewportFraction: 0.8,
              enlargeCenterPage: true,
              autoPlay: true,
              autoPlayInterval: Duration(milliseconds: 3000))));

  Widget returnTypingText() => SliverToBoxAdapter(
          child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Align(
          child: TypingText(),
          alignment: Alignment.topLeft,
        ),
      ));

  Widget returnModelGallery() =>
      SliverToBoxAdapter(child: ModelGallery(filter: this.filter));
}

class ModelGallery extends StatefulWidget {
  final String filter;

  const ModelGallery({Key key, this.filter}) : super(key: key);

  @override
  _ModelGalleryState createState() => _ModelGalleryState();
}

class _ModelGalleryState extends State<ModelGallery> {
  String filter;
  List filteredItems = [];
  int threshAndLength = 0;

  @override
  void initState() {
    super.initState();
    int lastThreshhold = 0;
    bool done = false;
    while (done == false) {
      if (lastThreshhold > objectTypesCarousel.length &&
          lastThreshhold - 3 < objectTypesCarousel.length) {
        threshAndLength = lastThreshhold - objectTypesCarousel.length;
        done = true;
      } else {
        lastThreshhold += 3;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    filter = widget.filter;

    if (filter.isEmpty) {
      return StaggeredGridView.countBuilder(
        padding: EdgeInsets.all(0),
        crossAxisCount: 4,
        itemCount: objectTypesCarousel.length + threshAndLength,
        primary: false,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          if (index > objectTypesCarousel.length - 1) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              child: ModelCarousel(
                  myIndex: Random().nextInt(objectTypesCarousel.length)),
            );
          } else {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              child: ModelCarousel(myIndex: index),
            );
          }
        },
        staggeredTileBuilder: (int index) =>
            StaggeredTile.count(index % 3 == 0 ? 2 : 1, index % 3 == 0 ? 2 : 1),
      );
    } else {
      filteredItems = [];
      allObjects.forEach((element) {
        if (element.toLowerCase().contains(filter.toLowerCase())) {
          filteredItems.add(element);
        }
      });

      try {
        if (filteredItems.length == 0) {
          objectTypes[filter]
              .forEach((element) => {filteredItems.add(element)});
        }

        return StaggeredGridView.countBuilder(
            crossAxisCount: 4,
            itemCount: filteredItems.length,
            primary: false,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return TextButton(
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        primaryColors[Random().nextInt(primaryColors.length)],
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: objectKeys[filteredItems[index].toLowerCase()]
                        ["ui_img"],
                    fit: BoxFit.fitHeight,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            CircularProgressIndicator(
                                value: downloadProgress.progress),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            DescScreen(entity: filteredItems[index]),
                        settings: RouteSettings(
                            name:
                                "Description Screen - ${filteredItems[index]}")),
                  );
                },
              );
            },
            staggeredTileBuilder: (int index) => StaggeredTile.count(2, 2));
      } catch (e) {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "No results found for $filter ¯" + r'\' + "_(ツ)_/¯",
                style: TextStyle(color: Colors.white),
              )
            ]);
      }
    }
  }
}

class ModelCarousel extends StatefulWidget {
  final int myIndex;

  const ModelCarousel({Key key, this.myIndex}) : super(key: key);

  @override
  _ModelCarouselState createState() => _ModelCarouselState();
}

class _ModelCarouselState extends State<ModelCarousel> {
  int myIndex;
  int number = Random().nextInt(4000) + 3000;
  List<Widget> modelTiles = [];

  void _addModelViews() {
    objectTypesCarousel[myIndex].forEach((element) {
      modelTiles.add(TextButton(
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
    });
  }

  @override
  void initState() {
    super.initState();
    myIndex = widget.myIndex;
    _addModelViews();
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: modelTiles,
      options: CarouselOptions(
          autoPlayInterval: Duration(milliseconds: number),
          autoPlay: true,
          viewportFraction: 1),
    );
  }
}

class TitleText extends StatefulWidget {
  const TitleText({Key key}) : super(key: key);

  @override
  _TitleTextState createState() => _TitleTextState();
}

class _TitleTextState extends State<TitleText>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ShaderMask(
              child: Text(
                "3d Models",
                style: TextStyle(
                    fontFamily: "Farro",
                    fontWeight: FontWeight.w800,
                    fontSize: 38.0,
                    color: Colors.white),
              ),
              shaderCallback: (rect) {
                return LinearGradient(stops: [
                  _animation.value - 0.5,
                  _animation.value,
                  _animation.value + 0.5
                ], colors: [
                  Color(int.parse("0xFF00c3ff")),
                  Color(int.parse("0xFFffff1c")),
                  Color(int.parse("0xFF00c3ff"))
                ]).createShader((rect));
              },
            )
          ]),
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 1000),
      curve: Curves.easeIn,
      builder: (BuildContext context, double _val, Widget child) {
        return Opacity(
          opacity: _val,
          child:
              Padding(padding: EdgeInsets.only(top: _val * 50), child: child),
        );
      },
    );
  }
}

class TypingText extends StatefulWidget {
  const TypingText({Key key}) : super(key: key);

  @override
  _TypingTextState createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText>
    with SingleTickerProviderStateMixin {
  final String subtext =
      "Choose from ${(objectKeys.length / 10).floor() * 10}+ Models";
  AnimationController controller;
  Animation<int> animation;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    super.initState();
    animation = IntTween(begin: 0, end: subtext.length).animate(controller);
    new Timer(const Duration(seconds: 2), () {
      controller.forward();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget child) {
            return Text(
              subtext.substring(0, animation.value) +
                  (animation.value / subtext.length == 1 ? "" : "|"),
              style: TextStyle(
                  color: Colors.blue, fontFamily: "Pangolin", fontSize: 18),
            );
          }),
    );
  }
}