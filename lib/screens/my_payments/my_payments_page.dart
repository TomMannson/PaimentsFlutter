import 'package:flutter/material.dart';
import 'package:paymenow/dependency_resolver.dart';
import 'package:paymenow/main_navigation_bloc.dart';
import 'package:paymenow/model/my_payment_view_ds.dart';
import 'package:paymenow/navigation_resolver.dart';
import 'package:paymenow/screens/my_payments/upcoming_list_item.dart';

class MyPaymentsPage extends StatelessWidget {
  MainNavigationBloc bloc;

  MyPaymentsPage() {
    bloc = getIt.get();
    bloc.commandsSink.add(LoadMyPaymentsCommands());
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MyPaymentViewDs>>(
        stream: bloc.currentMyPayments,
        builder: (context, AsyncSnapshot<List<MyPaymentViewDs>> snapshot) {

          if(snapshot.data == null){
            return Text("no Data");
          }

          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (ctx, index){
                return MyPaymentListItem(snapshot.data[index]);
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
