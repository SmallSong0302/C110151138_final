import 'package:flutter/material.dart';
import 'package:finaltest/music_player.dart';

void main(){
  runApp(const MainApp());
}

class MainApp extends StatelessWidget{
  const MainApp({super.key});

  @override
  Widget build(BuildContext context){
    return  MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: Scaffold(
        body: const MusicPlayer(),
      ),
    );
  }
}


