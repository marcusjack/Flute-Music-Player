import 'package:flute_music/home_page.dart';
import 'package:flute_music/theming/dynamic_theming._bloc.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  ThemeBloc theme_bloc = new ThemeBloc();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: false,
      stream: theme_bloc.currentTheme,
      builder: (context, snapshot) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: snapshot.data ? ThemeData.dark() : ThemeData.light(),
          home: MyHomePage(snapshot.data, theme_bloc),
        );
      },
    );
  }
}