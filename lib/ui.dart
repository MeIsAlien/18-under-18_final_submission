import 'package:flutter/material.dart';
import 'ar_snr_screen.dart';
import 'home_screen.dart';
import 'favourites.dart';
import 'global_variables.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:url_launcher/url_launcher.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  RateMyApp rmaObject = RateMyApp(
    googlePlayIdentifier: 'com.joelnadar.educam',
    preferencesPrefix: "educamRateApp_",
    minDays: 5,
    minLaunches: 7,
    remindDays: 7,
    remindLaunches: 12,
  );

  @override
  void initState() {
    super.initState();
    rmaObject.init().then((value) => {if (rmaObject.shouldOpenDialog) {
      Future.delayed(Duration(minutes: 2), () {
        rmaObject.showStarRateDialog(
          context,
          title: "Enjoying EduCam?",
          message: "Help us by leaving a rating!",
          starRatingOptions: StarRatingOptions(initialRating: 0),
          actionsBuilder: actionBuilder,
        );
      })
    }});
  }

  List<Widget> actionBuilder(context, double stars) {
    if (stars == 0) {
      return [
        RateMyAppNoButton(rmaObject, text: 'Cancel'),
      ];
    } else {
      return [
        TextButton(
          child: Text('Confirm'),
          onPressed: () async {
            await rmaObject.callEvent(RateMyAppEventType.rateButtonPressed);
            if (stars >= 4) {
              rmaObject.launchStore();
            } else if (await canLaunch(
                "https://educam-website.web.app/feedback/")) {
              launch("https://educam-website.web.app/feedback/");
            }
          },
        ),
        RateMyAppNoButton(
          rmaObject,
          text: 'Cancel',
        ),
      ];
    }
  }

  int _selectedIndex = 0;
  final List<Widget> _screens = [
    HomeScreenV2(),
    AugmentedPage(),
    FavoritesScreen()
  ];

  _onItemTapped(index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Scan and Render',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favorites',
              ),
            ],
            backgroundColor: tColor,
            currentIndex: _selectedIndex,
            unselectedItemColor: Colors.grey,
            selectedItemColor: secondaryColor,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
