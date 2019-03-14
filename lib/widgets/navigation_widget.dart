import 'package:flutter/material.dart';
import 'package:paymenow/dependency_resolver.dart';
import 'package:paymenow/main_navigation_bloc.dart';

class NavigationWidget extends StatelessWidget {
  MainNavigationBloc bloc;

  NavigationWidget() {
    bloc = getIt.get();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        initialData: 0,
        stream: bloc.currentNavigationItem,
        builder: (ctx, AsyncSnapshot<int> snapshot) {
          int currentIndex = 0;
          if (snapshot != null && snapshot.data != null) {
            currentIndex = snapshot.data;
          }

          return new Theme(
            data: Theme.of(context).copyWith(
              // sets the background color of the `BottomNavigationBar`
              canvasColor: Colors.amber,
            ), // sets the inactive color of the `BottomNavigationBar`
            child: BottomNavigationBar(
              onTap: (index) => selectedItem(context, index),
              currentIndex: currentIndex,
              // this will be set when a new tab is tapped
              items: [
                BottomNavigationBarItem(
                  icon: new Icon(Icons.attach_money),
                  backgroundColor: Colors.blueAccent,
                  title: new Text('Płatności'),
                ),
                BottomNavigationBarItem(
                  icon: new Icon(Icons.event),
                  title: new Text('Oś czasu'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.access_alarm),
                  title: Text('Moje alarmy'),
                )
              ],
            ),
          );
        });
  }

  void selectedItem(BuildContext value, int index) {
    bloc.navigationIndex.add(index);
  }
}
