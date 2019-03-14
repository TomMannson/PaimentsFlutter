import 'package:get_it/get_it.dart';
import 'package:paymenow/main_navigation_bloc.dart';

GetIt getIt = GetIt();

void resolveDependency(){

  getIt.registerLazySingleton(() => MainNavigationBloc());


}