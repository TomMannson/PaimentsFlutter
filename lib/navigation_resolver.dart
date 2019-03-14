import 'package:flutter/material.dart';
import 'package:paymenow/screens/hostory_payments.dart';
import 'package:paymenow/screens/main_page.dart';
import 'package:paymenow/screens/test_payments.dart';
import 'package:paymenow/screens/upcomming_paiments/upcoming_payments.dart';

String ROUTE_UPCOMING = "/";
String ROUTE_HISTORY = "/history";

void resolveNavigation(BuildContext ctx, int index) {
  if (index == 0) {
    Navigator.pushReplacementNamed(ctx, ROUTE_UPCOMING);
  } else if (index == 1) {
    Navigator.pushReplacementNamed(ctx, ROUTE_HISTORY);
  }
}

Map<String, WidgetBuilder> route() {
  return {
    "/": (ctx) => MainPage(),
    "/test": (ctx) => TestPage()
  };
}

Route<dynamic> onRoute(RouteSettings settings) {
  if (settings.name == ROUTE_UPCOMING) {
    return MaterialPageRoute(builder: (buildContext) => UpcomingPaymentsPage());
  } else if (settings.name == ROUTE_HISTORY) {
    return MaterialPageRoute(builder: (buildContext) => HistoryPeymentsPage());
  }
}
