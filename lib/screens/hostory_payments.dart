import 'package:flutter/material.dart';
import 'package:paymenow/dependency_resolver.dart';
import 'package:paymenow/main_navigation_bloc.dart';
import 'package:paymenow/tag_holder.dart';
import 'package:paymenow/widgets/navigation_widget.dart';




class HistoryPeymentsPage extends StatelessWidget {

  MainNavigationBloc bloc;

  HistoryPeymentsPage(){
    bloc = getIt.get();
  }

  @override
  Widget build(BuildContext context) {

    AppBar appbar = buildAppBar();

    return Center(
        child: Text("History"),
      );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text("Paymenow"),
    );
  }

  void selectedItem(int value) {
//    bloc.navigationIndex.add(value);
  }
}
