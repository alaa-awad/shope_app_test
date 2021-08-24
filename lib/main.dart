import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shope_app_test/layout/cubit/cubit.dart';
import 'package:shope_app_test/shared/bloc_observer.dart';
import 'package:shope_app_test/shared/components/constant.dart';
import 'package:shope_app_test/shared/network/local/cache_helper.dart';
import 'package:shope_app_test/shared/network/remote/dio_helper.dart';
import 'package:shope_app_test/shared/styles/themes.dart';

import 'layout/shop_layout.dart';
import 'modules/shope_app/ShopLoginScreen/ShopLoginScreen.dart';
import 'modules/shope_app/on_boarding/onBoarding.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  isDark = CacheHelper.getData(key: 'isDark')??false;
  bool? onBoarding = CacheHelper.getData(key: 'onBoarding');
  token = CacheHelper.getData(key: 'token');
  print(token);
  //CacheHelper.getData(key: 'isDark');
  Widget homeScreen;
  if(onBoarding != null){
   // if(token != null) homeScreen = ShopLayout();
    if(token != null) homeScreen = ShopLayout();
    else homeScreen = homeScreen = ShopLoginScreen();
  }
  else homeScreen = OnBoardingScreen();
  runApp(MyApp(
    isDark: isDark,
    homeScreen: homeScreen,
  ));
}

class MyApp extends StatelessWidget {
  final bool? isDark;
  Widget homeScreen;
  MyApp({
     required this.isDark,
    required this.homeScreen,
  });
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context)=>ShopCubit()..getHomeData()..getCategorise()..getFavorite()..getUserData()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme:lightTheme,
        darkTheme: darkTheme,
        themeMode: (isDark==false)?ThemeMode.light:ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        home: homeScreen,
        //homeScreen
        //ShopLoginScreen
      ),
    );
  }
}
