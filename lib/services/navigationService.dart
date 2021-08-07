import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NavigationService {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState.pushNamed(routeName, arguments: arguments);
  }

  void goBack() {
    return navigatorKey.currentState.pop();
  }

  void popUntil() {
    return navigatorKey.currentState.popUntil((route) => false);
  }

  Future<dynamic> popUntilAndNavigateTo(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState
        .popAndPushNamed(routeName, arguments: arguments);
  }
}
