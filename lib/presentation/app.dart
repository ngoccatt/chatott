// app.dart
import 'package:chatott/presentation/screens/chat_box_screen.dart';
import 'package:chatott/presentation/screens/home_screen.dart';
import 'package:chatott/presentation/screens/login_screen.dart';
import 'package:chatott/presentation/screens/signup_screen.dart';
import 'package:chatott/presentation/screens/home_screen_web.dart';

import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    Widget homeLayout() {
      return LayoutBuilder( 
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 550) {
          return HomeScreenWeb();
        } else {
          return HomeScreen();
        }
      });
    }

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        var args = settings.arguments;
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            );
          case '/signup':
            return MaterialPageRoute(
              builder: (context) => const SignupScreen(),
            );
          case '/home':
            return MaterialPageRoute(
              builder: (context) => homeLayout(),
            );
          case '/chat':
          print(args);
            var myargs = args as List;
            return MaterialPageRoute(
              builder: (context) => ChatBoxScreen(conversationId: myargs[0] as int, 
                    conversationName: myargs[1] as String, isMobile: true,),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            );
        }
      },
    );
  }
}
