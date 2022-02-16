import 'package:flutter/material.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static void navigateTo(String routeName) =>
      navigatorKey.currentState!.pushNamed(routeName);
  static void navigateToPage(Widget page) =>
      navigatorKey.currentState!.push(MaterialPageRoute(
        builder: (context) => page,
      ));

  static void navigateToSlideLeft(Widget page) => navigatorKey.currentState!
      .push(navigateAnimationSlideLeft(navigatorKey.currentContext!, page));

  static void replaceTo(String routeName) {
    navigatorKey.currentState!.pushReplacementNamed(routeName);
  }

  static void replaceUntilTo(String routeName) {
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
    navigatorKey.currentState!.pushReplacementNamed(routeName);
  }

  static void replaceAnimatedTo(Widget page) {
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
    navigatorKey.currentState!
        .pushReplacement(navigateAnimation(navigatorKey.currentContext!, page));
  }

  static void navigateAnimatedTo(Widget page) => navigatorKey.currentState!
      .push(navigateAnimation(navigatorKey.currentContext!, page));

  static void pop([dynamic result]) => navigatorKey.currentState!.pop(result);
  static void popUntil() =>
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
}

PageRouteBuilder navigateAnimation(BuildContext context, Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 1200),
    transitionsBuilder: (context, animation, _, child) => SlideTransition(
      child: page,
      position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
          .animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutQuint)),
    ),
    pageBuilder: (_, __, ___) => page,
  );
}

PageRouteBuilder navigateAnimationSlideLeft(BuildContext context, Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 600),
    transitionsBuilder: (context, animation, _, child) => SlideTransition(
      child: page,
      position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
          .animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutQuint)),
    ),
    pageBuilder: (_, __, ___) => page,
  );
}
