import 'dart:ui';

import 'package:alicsnet_app/util/shared_preferences_util.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:alicsnet_app/model/purchase_provider_model.dart';
import 'package:alicsnet_app/router/router.gr.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alicsnet_app/page/page_theme.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SystemChrome.setPreferredOrientations(
      <DeviceOrientation>[
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown
      ]
  ).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  final _appRouter = AppRouter();

  MyApp();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<PurchaseProviderModel>(create: (context) => PurchaseProviderModel()),
    ],
    child:
    MaterialApp.router(
      scrollBehavior: MaterialScrollBehavior().copyWith(dragDevices:{PointerDeviceKind.touch,
        PointerDeviceKind.mouse,}),
      title: 'Alicsnet APP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: PageTheme.fontName,
        primarySwatch: Colors.blue,
      ),
      builder: EasyLoading.init(),
      //routerDelegate: _appRouter.delegate(initialRoutes: [isSignin == true ? IndexRoute() : SignInRoute(),]),
      routerDelegate: _appRouter.delegate(initialRoutes: [IndexRoute()]),
      routeInformationParser:_appRouter.defaultRouteParser(),
    ),);
    /*
    //強制限制 Web 版尺寸
    return FlutterWebFrame(
      maximumSize: Size(720.0, 1280.0),
      enabled: kIsWeb,
      backgroundColor: Colors.white10,
      builder: (context) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<PurchaseProviderModel>(create: (context) => PurchaseProviderModel()),
          ],
          child: MaterialApp.router(
            title: 'Alicsnet APP',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: PageTheme.fontName,
              primarySwatch: Colors.blue,
            ),
            builder: EasyLoading.init(),
            routerDelegate: _appRouter.delegate(initialRoutes: [isSignin == true ? IndexRoute() : SignInRoute(),]),
            routeInformationParser:_appRouter.defaultRouteParser(),
          )
        );
      },
    );
    */
  }
}