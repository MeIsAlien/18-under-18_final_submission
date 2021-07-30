import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'ui.dart';
import 'package:ar_ui/global_variables.dart' show allObjects, prefs, tColor;


class IntroScreen extends StatefulWidget {
  const IntroScreen({Key key}) : super(key: key);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  List<PageViewModel> listOfIntructions() {
    return [
      PageViewModel(
          titleWidget: Text("Greetings!",
              style: TextStyle(
                  fontSize: 48,
                  fontFamily: "Farro",
                  fontWeight: FontWeight.bold,
                  color: Colors.orange),
              textAlign: TextAlign.center),
          bodyWidget: Text(
            "Welcome to the AR fam, We are extremely pleased to see you here! How About a quick tutorial before we go any further?",
            style: TextStyle(
                fontSize: 20, fontFamily: "Pangolin", color: Colors.orange),
            textAlign: TextAlign.center,
          ),
          image: Padding(
              padding: EdgeInsets.only(top: 25),
              child: Image.network(
                "https://assets7.lottiefiles.com/private_files/lf30_TBKozE.json",
              ))),
      PageViewModel(
          titleWidget: Text("Choose from the library",
              style: TextStyle(
                  fontSize: 48,
                  fontFamily: "Farro",
                  fontWeight: FontWeight.bold,
                  color: Colors.orange),
              textAlign: TextAlign.center),
          bodyWidget: Text(
            "Choose from over ${allObjects.length} Models. The Library is displayed on the Home Screen. Click on the image that you want to see in Augmented Reality",
            style: TextStyle(
                fontSize: 20, fontFamily: "Pangolin", color: Colors.orange),
            textAlign: TextAlign.center,
          ),
          image: Padding(
              padding: EdgeInsets.only(top: 25),
              child: Image.network(
                "https://i.postimg.cc/HW0FGs4Z/animation-500-kpjt2k09.gif",
              ))),
      PageViewModel(
          titleWidget: Text("Scan And Render",
              style: TextStyle(
                  fontSize: 48,
                  fontFamily: "Farro",
                  fontWeight: FontWeight.bold,
                  color: Colors.orange),
              textAlign: TextAlign.center),
          bodyWidget: Text(
            "Tired of picking and searching for models? Scan any object from the library, and we will automatically display the 3d model for you.",
            style: TextStyle(
                fontSize: 20, fontFamily: "Pangolin", color: Colors.orange),
            textAlign: TextAlign.center,
          ),image: Lottie.network("https://assets8.lottiefiles.com/packages/lf20_n2m0isqh.json")),
      PageViewModel(
          titleWidget: Text("Save your models on the go",
              style: TextStyle(
                  fontSize: 48,
                  fontFamily: "Farro",
                  fontWeight: FontWeight.bold,
                  color: Colors.orange),
              textAlign: TextAlign.center),
          bodyWidget: Text(
            "You can save the models that you like at the subject's description page, just click on the ❤ icon and navigate to the favourites screen using the bottom navigation bar to view all of your favourites",
            style: TextStyle(
                fontSize: 20, fontFamily: "Pangolin", color: Colors.orange),
            textAlign: TextAlign.center,
          ),
          image: Lottie.network("https://assets9.lottiefiles.com/packages/lf20_kduzs1w9.json")),
      PageViewModel(
          titleWidget: Text("You are Ready!",
              style: TextStyle(
                  fontSize: 48,
                  fontFamily: "Farro",
                  fontWeight: FontWeight.bold,
                  color: Colors.orange),
              textAlign: TextAlign.center),
          bodyWidget: Text(
            "That's it for now. Free models everyday!\n",
            style: TextStyle(
                fontSize: 38, fontFamily: "Pangolin", color: Colors.orange),
            textAlign: TextAlign.center,
          ),
          image: Padding(
              padding: EdgeInsets.only(top: 25),
              child: Image.network(
                "https://assets2.lottiefiles.com/packages/lf20_gri1GI.json",
              ))),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: IntroductionScreen(
        globalBackgroundColor: Colors.transparent,
        done: Text(
          "Ok, Great!",
          style: TextStyle(color: Colors.green),
        ),
        onDone: () {
          prefs.setBool("educamwelcomeRunned", true);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MainPage(),
                  settings: RouteSettings(name: "Finished Tutorial")));
        },
        pages: listOfIntructions(),
        showNextButton: false,
        showSkipButton: true,
        skip: Text(
          "Skip",
          style: TextStyle(color: Colors.green),
        ),
        onSkip: () {
          prefs.setBool("educamwelcomeRunned", true);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MainPage(),
                  settings: RouteSettings(name: "Finished Tutorial")));
        },
      ),
      painter: BluePainter(),
    );
  }
}

class BluePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();

    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, width, height));
    paint.color = Colors.white;
    canvas.drawPath(mainBackground, paint);

    Path ovalPath = Path();
    ovalPath.moveTo(0, height * 0.2);
    ovalPath.quadraticBezierTo(
        width * 0.45, height * 0.25, width * 0.51, height * 0.5);
    ovalPath.quadraticBezierTo(width * 0.58, height * 0.8, width * 0.1, height);
    ovalPath.lineTo(0, height);
    ovalPath.close();

    paint.color = tColor;
    canvas.drawPath(ovalPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
