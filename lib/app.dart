import 'package:base_project/helper/messaging.dart';
import 'package:base_project/interface/container/home_page/view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  App({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          primary: false,
          resizeToAvoidBottomInset: false,
          key: MessagingInstance.instance.key,
          body: currentApp(),
        ),
      ),
    );
  }

  Widget currentApp() {
    ColorScheme defaultColorScheme = const ColorScheme.light();
    final textButtonTheme = TextButtonThemeData(
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.resolveWith(
                    (states) => const Color(0xFF9B177E))));
    return GetMaterialApp(
      title: 'Base-Project',
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      getPages: [
        GetPage(name: '/home', page: () => HomePage()),
      ],
      navigatorKey: MessagingInstance.instance.navigatorKey,
      theme: ThemeData(
          fontFamily: "Gilroy",
          colorScheme: ColorScheme(
            primary: const Color(0xFF898AC4),
            primaryContainer: const Color(0xFF898AC4),
            secondary: const Color(0xFF555879),
            secondaryContainer: const Color(0xFF555879),
            background: Colors.white,
            surface: const Color(0xFFFAFBFB),
            onBackground: Colors.black,
            onError: defaultColorScheme.onError,
            error: defaultColorScheme.error,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: Colors.black,
            brightness: Brightness.light,
          ),
          inputDecorationTheme: const InputDecorationTheme(
            border: UnderlineInputBorder(),
            focusColor: Color(0xFF9B177E),
            labelStyle: TextStyle(color: Colors.white),

          ),
          iconTheme: const IconThemeData(color: Color(0xFF9B177E)),
          textButtonTheme: textButtonTheme,
          textSelectionTheme: const TextSelectionThemeData(
              cursorColor: Colors.black),
          appBarTheme: const AppBarTheme(
              color: Color(0xFFFFFFFF),
              centerTitle: false,
              toolbarTextStyle: TextStyle(color: Colors.black),
              titleTextStyle: TextStyle(color: Colors.black),
              elevation: 1,
              iconTheme: IconThemeData(color: Colors.black, size: 14),
              actionsIconTheme: IconThemeData(color: Colors.black, size: 14))),
      onGenerateRoute: (RouteSettings settings){
        return CupertinoPageRoute<Object>(builder: (BuildContext context) {
          return HomePage();
        });
      },

    );
  }

}