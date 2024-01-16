import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';


class MusicPlayer extends StatefulWidget {
  const MusicPlayer({super.key});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  final String audioUrl = "audio/idol.mp3";
  late AudioPlayer _audioPlayer;
  late Duration _duration;
  late Duration _position;

  void playerInit() {
    _audioPlayer=AudioPlayer()..setSourceAsset(audioUrl);
    _duration=Duration();
    _position=Duration();

    _audioPlayer.onDurationChanged.listen((Duration d) {
      _duration=d;
      setState(() {});
    });

    _audioPlayer.onPositionChanged.listen((Duration p) {
      _position=p;
      setState(() {});
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _position=_duration;
      });
    });
  }

  void playOrPause(){
    if(_audioPlayer.state==PlayerState.playing){
      _audioPlayer.pause();
    } else {
      _audioPlayer.resume();
    }
    setState(() {});
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n)=>n.toString().padLeft(2, "0");
    String twoDigitMinutes=twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds=twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void initState() {
    playerInit();
    super.initState();
  }

  @override
  void dispose() {
    _audioPlayer.release();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //歌曲訊息
              Image.asset('assets/images/music.png',height: 200,width: 200),
              const SizedBox(height: 40,),
              const Text('Music Title 音樂標題',style: TextStyle(fontSize: 24,color: Colors.red),),
              const SizedBox(height: 10,),
              const Text('黃吉菘',style: TextStyle(fontSize: 14)),

              //音樂控制
              Slider(
                onChanged: (value) async{
                  await _audioPlayer.seek(Duration(seconds: value.toInt()));
                  setState(() {});
                },
                value: _position.inSeconds.toDouble(),
                min: 0,
                max: _duration.inSeconds.toDouble(),
                inactiveColor: Colors.grey,
                activeColor: Colors.red,
              ),
              Text('${formatDuration(_position)} / ${formatDuration(_duration)}'),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: (){
                      _audioPlayer.seek(Duration(seconds: _position.inSeconds-10));
                      setState(() {});
                    },
                    icon:const Icon(Icons.fast_rewind),
                    iconSize: 40,
                  ),
                  IconButton(
                    onPressed: playOrPause,
                    icon: Icon(_audioPlayer.state==PlayerState.playing ? Icons.pause : Icons.play_arrow),
                    iconSize: 50,
                  ),
                  IconButton(
                    onPressed: (){
                      _audioPlayer.seek(Duration(seconds: _position.inSeconds+10));
                      setState(() {});
                    },
                    icon:const Icon(Icons.fast_forward),
                    iconSize: 40,
                  )
                ],
              )

            ],
          ),
        )
    );
  }


}


