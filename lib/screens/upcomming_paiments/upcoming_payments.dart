import 'package:flutter/material.dart';
import 'package:paymenow/dependency_resolver.dart';
import 'package:paymenow/main_navigation_bloc.dart';
import 'package:paymenow/model/upcoming_paiment_view_ds.dart';
import 'package:paymenow/navigation_resolver.dart';
import 'package:paymenow/screens/upcomming_paiments/upcoming_list_item.dart';

class UpcomingPaymentsPage extends StatelessWidget {
  MainNavigationBloc bloc;

  UpcomingPaymentsPage() {
    bloc = getIt.get();
    bloc.commandsSink.add(LoadUpcomingPaymentsCommands());
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<List<UpcomingPaimentsViewDs>>(
      stream: bloc.currentUpcomingPayments,
      builder: (context, AsyncSnapshot<List<UpcomingPaimentsViewDs>> snapshot) {

        if(snapshot.data == null){
          return Text("no Data");
        }

        return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (ctx, index){
          return UpcommingListItem(snapshot.data[index]);
        });
      }
    );
  }

  AppBar buildAppBar() {
    return AppBar();
  }

  void selectedItem(BuildContext value, int index) {
    resolveNavigation(value, index);
  }
}
