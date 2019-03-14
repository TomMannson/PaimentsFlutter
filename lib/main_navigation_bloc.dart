import 'package:paymenow/model/my_payment_view_ds.dart';
import 'package:paymenow/model/upcoming_paiment_view_ds.dart';
import 'package:rxdart/rxdart.dart';

class MainNavigationBloc {
  List<UpcomingPaimentsViewDs> _currentList = [];
  List<MyPaymentViewDs> _myCurrentPaymentList = [];

  MainNavigationBloc() {
    _upcomingPaiments.add([]);
    _myPaimentsStream.add([]);
    _commandsSubscriber.listen(resolveCommands);
  }

  BehaviorSubject<int> _subject = BehaviorSubject();
  BehaviorSubject<List<MyPaymentViewDs>> _myPaimentsStream = BehaviorSubject();
  BehaviorSubject<List<UpcomingPaimentsViewDs>> _upcomingPaiments =
      BehaviorSubject();
  BehaviorSubject<Commands> _commandsSubscriber = BehaviorSubject();

  Sink<int> get navigationIndex => _subject.sink;

  Stream<int> get currentNavigationItem => _subject.asBroadcastStream();

  Stream<List<UpcomingPaimentsViewDs>> get currentUpcomingPayments =>
      _upcomingPaiments.asBroadcastStream();

  Stream<List<MyPaymentViewDs>> get currentMyPayments =>
      _myPaimentsStream.asBroadcastStream();

  Sink<Commands> get commandsSink => _commandsSubscriber.sink;

  List<UpcomingPaimentsViewDs> loadUpcomming() {
    return [
      UpcomingPaimentsViewDs()
        ..name = "jak dojedziesz"
        ..checked = false
        ..iconType = 1
        ..formatedDateToPaiment = "6 Days ago",
      UpcomingPaimentsViewDs()
        ..name = "jak dojedziesz"
        ..checked = false
        ..iconType = 1
        ..formatedDateToPaiment = "Yasterday",
      UpcomingPaimentsViewDs()
        ..name = "jak dojedziesz"
        ..checked = false
        ..iconType = 1
        ..formatedDateToPaiment = "Today",
      UpcomingPaimentsViewDs()
        ..name = "jak dojedziesz"
        ..checked = false
        ..iconType = 6
        ..formatedDateToPaiment = "Today",
      UpcomingPaimentsViewDs()
        ..name = "jak dojedziesz"
        ..checked = false
        ..iconType = 1
        ..formatedDateToPaiment = "Tomorrow",
    ];
  }

  void resolveCommands(Commands event) {
    if (event is LoadUpcomingPaymentsCommands) {
      _currentList = loadUpcomming();
      _upcomingPaiments.add(_currentList);
    } else if (event is LoadMyPaymentsCommands) {
      _myCurrentPaymentList = loadMyPaymentsUpcomming();
      _myPaimentsStream.add(_myCurrentPaymentList);
    } else if (event is ChangeCheckPaymentCommands) {
      int index = _currentList.indexOf(event.item);
      List<UpcomingPaimentsViewDs> list = List.from(_currentList);

      list[index] = event.item..checked = !event.item.checked;
      _currentList = list;
      _upcomingPaiments.add(_currentList);
    }
  }

  List<MyPaymentViewDs> loadMyPaymentsUpcomming() {
    return [
      MyPaymentViewDs()
        ..name = "Test"
        ..iconType = 1,
      MyPaymentViewDs()
        ..name = "Test"
        ..iconType = 2,
      MyPaymentViewDs()
        ..name = "jak dojedziesz"
        ..iconType = 4,
      MyPaymentViewDs()
        ..name = "azsldkal;k"
        ..iconType = 5,
      MyPaymentViewDs()
        ..name = "w902edhkccnqoiud"
        ..iconType = 7,
    ];
  }
}

class Commands {}

class LoadUpcomingPaymentsCommands extends Commands {}

class LoadMyPaymentsCommands extends Commands {}

class ChangeCheckPaymentCommands extends Commands {
  UpcomingPaimentsViewDs item;

  ChangeCheckPaymentCommands(this.item);
}
