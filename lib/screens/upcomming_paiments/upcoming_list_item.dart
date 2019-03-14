import 'package:flutter/material.dart';
import 'package:paymenow/dependency_resolver.dart';
import 'package:paymenow/main_navigation_bloc.dart';
import 'package:paymenow/model/upcoming_paiment_view_ds.dart';
import 'package:paymenow/screens/upcomming_paiments/icon_id_decoder.dart';

class UpcommingListItem extends StatelessWidget {
  UpcomingPaimentsViewDs upcomingPaimentsViewDs;
  MainNavigationBloc bloc;

  UpcommingListItem(this.upcomingPaimentsViewDs){
    bloc = getIt.get();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.only(
        top: 8.0,
        bottom: 8.0
      ),
      child: Row(
        children: <Widget>[
          Container(
              margin: EdgeInsets.all(16.0),
              child: Icon(getIconForType(upcomingPaimentsViewDs.iconType))),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 8.0),
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(upcomingPaimentsViewDs.name,
                    style: TextStyle(
                      fontSize: 16.0
                    ),
                  ),
                  Text(upcomingPaimentsViewDs.formatedDateToPaiment,
                  style: TextStyle(
                    color: Colors.red
                  ),),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 8.0),
            child: Checkbox(
              activeColor: Colors.amber,
              value: upcomingPaimentsViewDs.checked,
              onChanged: (value) {
                bloc.commandsSink.add(ChangeCheckPaymentCommands(upcomingPaimentsViewDs));
              },
            ),
          )
        ],
      ),
    );
  }
}
