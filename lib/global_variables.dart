import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'analytics_service.dart';

final Color primaryColor = Color(0xFFE6C79C);
final Color secondaryColor = Colors.orange;
final Color bgColor = Colors.white;
final Color tColor = Color(0xFF6200EE);
final primaryColors = [Colors.blue, Colors.green, Colors.teal];

bool userLoggedIn = false;

var objectTypes;
var objectTypesCarousel;
var objectKeys;
var allObjects;
var trendingCategories;
var userFavourites;
String uid;
SharedPreferences prefs;
final analyticsInstance = AnalyticsService();

Future<void> getKeys() async {
  prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  DatabaseReference _dbRef = FirebaseDatabase().reference();
  await _dbRef.child('/').once().then((DataSnapshot snapshot) {
    objectKeys = snapshot.value["objectKeys"];
    objectTypes = snapshot.value["objectTypes"];
    objectTypesCarousel = snapshot.value["objectTypesCarousel"];
    allObjects = snapshot.value["allObjects"];
    trendingCategories = snapshot.value["trendingCategories"];
  });
  prefs = await SharedPreferences.getInstance();
}
