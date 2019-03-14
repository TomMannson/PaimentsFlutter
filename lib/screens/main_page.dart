import 'package:flutter/material.dart';
import 'package:paymenow/animation/multi_child_crossfade.dart';
import 'package:paymenow/dependency_resolver.dart';
import 'package:paymenow/main_navigation_bloc.dart';
import 'package:paymenow/screens/hostory_payments.dart';
import 'package:paymenow/screens/my_payments/my_payments_page.dart';
import 'package:paymenow/screens/upcomming_paiments/upcoming_payments.dart';
import 'package:paymenow/tag_holder.dart';
import 'package:paymenow/widgets/navigation_widget.dart';

class MainPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {

  MainNavigationBloc bloc;
  List<Widget> listOfWidgets = [
    UpcomingPaymentsPage(),
    HistoryPeymentsPage(),
    MyPaymentsPage()
  ];
  int lastSelected = 0;

  _MainPageState() {
    bloc = getIt.get();
  }


  @override
  Widget build(BuildContext context) {
    AppBar appbar = buildAppBar();

    return Scaffold(
        appBar: PreferredSize(
          child: Hero(
            tag: appBarTag,
            child: appbar,
          ),
          preferredSize: appbar.preferredSize,
        ),
        body: StreamBuilder(
            initialData: 0,
            stream: bloc.currentNavigationItem,
            builder: (ctx, AsyncSnapshot<int> snapshot) {

              MultiChildrenCrossfadeAnimation animatedWidget = MultiChildrenCrossfadeAnimation(
                children: listOfWidgets,
                from: lastSelected,
                to: snapshot.data,
                duration: Duration(milliseconds: 300),
              );

              lastSelected = snapshot.data;


              return animatedWidget;
            }),
        bottomNavigationBar: Hero(tag: navBarTag, child: NavigationWidget()));
  }

  Widget createWidget(int last){
    if(last == 0){
      return UpcomingPaymentsPage();
    }
    else {
      return HistoryPeymentsPage();
    }
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text("Paymenow"),
    );
  }

  void selectedItem(int value) {
    bloc.navigationIndex.add(value);
  }
}
