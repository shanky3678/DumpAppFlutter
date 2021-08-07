import 'package:dump/screens/About%20Us/aboutUsView.dart';
import 'package:dump/screens/ComplaintPortal/ComplaintPortalView.dart';
import 'package:dump/screens/DetailsPage/DetailsView.dart';
import 'package:dump/screens/DriverRequestPortalView/DriverRequestPortalView.dart';
import 'package:dump/screens/RequestPortal/addRequestPortalView.dart';
import 'package:dump/screens/ResidentLogin/ResidentLoginView.dart';
import 'package:dump/screens/ResidentNotification/ResidentNotification.dart';
import 'package:dump/screens/StartupPage/StartupView.dart';
import 'package:dump/screens/DriverMainPage/driverMainView.dart';
import 'package:dump/screens/DriverLoginPage/DriverLogin.dart';
import 'package:dump/screens/ResidentHomeView/ResidentHomeView.dart';
import 'package:dump/screens/Unfinished%20Screens/testing.dart';
import 'package:flutter/material.dart';
import 'pathnames.dart' as routeName;

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case routeName.StartUpRoute:
      return MaterialPageRoute(builder: (context) => StartUpView());
    case routeName.DriverLoginRoute:
      return MaterialPageRoute(builder: (context) => DriverLogin());
    case routeName.ResidentLoginViewRoute:
      return MaterialPageRoute(builder: (context) => ResidentLoginView());
    case routeName.DriverHomeViewRoute:
      return MaterialPageRoute(builder: (context) => DriverHomeView());
    case routeName.ResidentHomeViewRoute:
      return MaterialPageRoute(builder: (context) => ResidentHomeView());
    case routeName.NotificationRoute:
      return MaterialPageRoute(builder: (context) => ResidentalNotification());
    case routeName.RequestFormRoute:
      return MaterialPageRoute(builder: (context) => RequestForm());
    case routeName.ComplaintRoute:
      return MaterialPageRoute(builder: (context) => ComplaintForm());
    case routeName.DriverRequestPortal:
      return MaterialPageRoute(builder: (context) => DriverRequestPortalView());
    case routeName.TestingPage:
      var argument = settings.arguments as Map;
      return MaterialPageRoute(
          builder: (context) => Testing(
                argument: argument['name'],
              ));
    case routeName.DetailsViewRoute:
      var argument = settings.arguments as Map;
      return MaterialPageRoute(
          builder: (context) => DetailsView(
                phoneNumber: argument['phoneNumber'],
                type: argument['type'],
                userId: argument['userId'],
              ));
    case routeName.AboutusViewRoute:
      return MaterialPageRoute(builder: (context) => AboutUs());
    default:
      return MaterialPageRoute(builder: (context) => StartUpView());
  }
}
