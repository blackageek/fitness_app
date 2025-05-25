import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gofitnext/modules/monCompte/controller/controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../app/components/bouton_components.dart';
import '../../app/components/text_components.dart';
import '../../main.dart';
import '../../utils/colors.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

import '../seance_personnalise.dart';
import '../stockageSeancePersoList/stockage.dart';

class DetailsSeancesFromSeancePerso extends StatefulWidget {
  final String? nomExo;
  final String? nombreDeSerie;
  final String? combinaisonId;
  final String jourSelectionne;
  final String? jourIndex;
  final String? exerciceIndex;
  final String? videoUrls;
  String? nombreDeRepetition;
  int? second;

  DetailsSeancesFromSeancePerso(
      {this.second = 30,
      this.jourIndex,
      this.nombreDeRepetition,
      this.videoUrls,
      this.exerciceIndex,
      this.nomExo,
      this.nombreDeSerie,
      this.combinaisonId,
      required this.jourSelectionne});

  @override
  State<DetailsSeancesFromSeancePerso> createState() =>
      _DetailsSeancesFromSeancePersoState();
}

class _DetailsSeancesFromSeancePersoState
    extends State<DetailsSeancesFromSeancePerso> {
  int currentExerciseIndex = 0;
  Timer? timer;
  late List<YoutubePlayerController> _controllers;

  bool _isTimerRunning = false;
  bool _isPaused = false;
  int _remainingTime = 55; // Durée de la minuterie en secondes
  int _seriesCount = 0; // Compteur de séries
  Timer? _timer;
  AudioPlayer _audioPlayer = AudioPlayer();

  List<String> videoUrls = [];
  @override
  void initState() {
    super.initState();
    _remainingTime = widget.second! + 4;
    _loadProgram();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    videoUrls = [widget.videoUrls!];
    // Initialisation de la liste des URLs vidéo
    _controllers = videoUrls.map((url) {
      final videoId = YoutubePlayer.convertUrlToId(url);
      return YoutubePlayerController(
        initialVideoId: videoId ?? '',
        flags: YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
            loop: true,
            disableDragSeek: false,
            isLive: false,
            forceHD: true,
            enableCaption: false,
            useHybridComposition: false,
            hideControls: false // Cache l'icône de plein écran
            ),
      )..addListener(_videoListener);
    }).toList();
  }

  bool _hasResetVideo = false;

  void _videoListener() {
    if (_controllers[0].value.isFullScreen) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);

      if (!_hasResetVideo) {
        _hasResetVideo = true; // Empêche la réinitialisation multiple
        Future.delayed(Duration(seconds: 5), () {
          if (_controllers[0].value.isFullScreen) {
            _controllers[0].seekTo(Duration.zero);
          }
        });
      }
    } else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      _hasResetVideo = false; // Réinitialise pour la prochaine fois
    }

    if (mounted) {
      setState(() {
        _isFullScreen = _controllers[0].value.isFullScreen;
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Center(
          child: Text(
            "🎉 Félicitations !",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: mainColor),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Vous avez terminé toutes les répétitions de l'exercice !",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Icon(Icons.emoji_events, size: 50, color: Colors.amber),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: mainColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text("OK",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadProgram() async {
    List<List<Map<String, double>>>? storedProgram =
        await getProgramFromSharedPreferences2();

    /*if (storedProgram == null) {
      storedProgram = generateTwoWeeksProgram();
      await saveProgramToSharedPreferences(storedProgram.cast<List<Map<String, double>>>());
    }*/

    setState(() {
      _program = storedProgram!;
      print("****d****d**d*d*d*d*d*d*d");
      print(_program);
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _audioPlayer.dispose();
    timer?.cancel();
    _timer?.cancel();

    // Restauration des orientations par défaut
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  List<List<Map<String, double>>> _program = [];
  Future<void> _startTimer() async {
    if (!_isTimerRunning) {
      setState(() {
        _isTimerRunning = true;
      });
      await _audioPlayer.play(AssetSource('sounds/audioo.m4a'));
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (_remainingTime > 0) {
          setState(() {
            _remainingTime--;
          });
        } else {
          _timer?.cancel();
          _audioPlayer.stop();

          setState(() {
            _isTimerRunning = false;
          });

          _audioPlayer.play(AssetSource('sounds/ok.mp3')).then((_) {
            _seriesCount++;

            if (_seriesCount >= int.parse(widget.nombreDeSerie!)) {
              _seriesCount = 0;
              _repetitionCount++;

              if (_repetitionCount >= int.parse(widget.nombreDeRepetition!)) {
                _showSuccessDialog(); // Fin de l'exercice
                markExerciseAsComplete(int.parse(widget.jourIndex!),
                    int.parse(widget.exerciceIndex!));
              } else {
                _restartWithAudio();
                _remainingTime = widget.second!;
                _startTimer();
              }
            } else {
              _remainingTime = widget.second!;
              _startTimer();
              _restartWithAudio();
            }
          });
        }
      });
    }
  }

  void _restartWithAudio() {
    _remainingTime = widget.second!;
    _audioPlayer.play(AssetSource('sounds/audioo.m4a')).then((_) {
      _startTimer();
    });
  }

  void markExerciseAsComplete(int dayIndex, int exerciseIndex) {
    setState(() {
      if (dayIndex < _program.length &&
          exerciseIndex < _program[dayIndex].length) {
        Map<String, double> exerciseMap = _program[dayIndex][exerciseIndex];
        String exerciseName = exerciseMap.keys.first;

        _program[dayIndex][exerciseIndex] = {exerciseName: 100.0};

        saveProgramToSharedPreferences(_program);
      }
    });
  }

// Sauvegarde du programmePowerBand mis à jour dans SharedPreferences
  Future<void> saveProgramToSharedPreferences(
      List<List<Map<String, double>>> program) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String programJson = jsonEncode(program);
    await prefs.setString('threeMonthsProgram',
        programJson); // Utiliser 'threeMonthsProgram' comme clé
  }

  void _pauseTimer() {
    if (_isTimerRunning) {
      _timer?.cancel();
      _audioPlayer.stop();
      setState(() {
        _isPaused = true;
        _isTimerRunning = false;
      });
    }
  }

  void _resumeTimer() {
    if (_isPaused) {
      _startTimer();
      _isPaused = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      bottomNavigationBar: InkWell(
      onTap: () {
        _showSuccessDialog();
        markExerciseAsComplete(int.parse(widget.jourIndex!), int.parse(widget.exerciceIndex!));
      },
        child: Container(
            height: 50,
            margin: EdgeInsets.only(left: 20,right: 20,bottom: 20),
            child: ButtonComponent(label: "Terminer la séance",color: Colors.green,)),
      ),
      appBar: _controllers[0].value.isFullScreen
          ? null
          : AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: mainColor,
              centerTitle: true,
              title: TextComponent(
                  text: widget.nomExo!,
                  color: Colors.white,
                  size: 16,
                  fontWeight: FontWeight.bold),
            ),
      body: _controllers[0].value.isFullScreen
          ? YoutubePlayer(
              controller: _controllers[0],
              showVideoProgressIndicator: true,
              progressIndicatorColor: mainColor,
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20,
                children: [
                  TextComponent(
                      text:
                          "Veuillez d'abord suivre la vidéo avant de commencer les exercices",
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.bold),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: YoutubePlayer(
                              controller: _controllers[0],
                              showVideoProgressIndicator: true,
                              progressIndicatorColor: mainColor,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Center(
                            child: _controllers[0]
                                    .value
                                    .isReady // Vérifie si la vidéo est prête
                                ? IconButton(
                                    icon: Icon(
                                      _controllers[0].value.isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      color: Colors.white,
                                    ),
                                    iconSize: 40,
                                    onPressed: () {
                                      setState(() {
                                        _controllers[0].value.isPlaying
                                            ? _controllers[0].pause()
                                            : _controllers[0].play();
                                      });
                                    },
                                  )
                                : SizedBox(), // Cache le bouton tant que la vidéo n'est pas prête
                          ),
                        ),

                        // Affiche le bouton "Quitter plein écran" uniquement si on est en plein écran
                        if (_isFullScreen)
                          Positioned(
                            top: 20,
                            right: 20,
                            child: IconButton(
                              icon: Icon(Icons.close,
                                  color: Colors.white, size: 30),
                              onPressed: () {
                                _controllers[0]
                                    .toggleFullScreenMode(); // Quitte le mode plein écran
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Vérifier si la vidéo est prête avant d'afficher le bouton
                  if (_controllers[0].value.isReady)
                    InkWell(
                      onTap: () {
                        _controllers[0].toggleFullScreenMode();
                      },
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        child: ButtonComponent(label: "Voir en plein écran"),
                      ),
                    ),

                  TextComponent(
                      text:
                          "Servez-vous de la minuterie ci-dessous afin de bien faire les répétitions des exercices",
                      textAlign: TextAlign.center),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        spacing: 10,
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: mainColor, width: 2)),
                            child: Center(
                              child: TextComponent(
                                  text: "$_remainingTime",
                                  size: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          TextComponent(
                            text: "Secondes",
                            size: 13,
                          ),
                        ],
                      ),
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.green, width: 2)),
                        child: InkWell(
                            onTap: () {
                              _isTimerRunning ? _pauseTimer() : _startTimer();
                            },
                            child: _isTimerRunning
                                ? Icon(Icons.pause, color: mainColor, size: 35)
                                : Icon(Icons.play_arrow,
                                    color: mainColor, size: 35)),
                      ),
                      Column(
                        children: [
                          SizedBox(height: 20),
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.green, width: 2)),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextComponent(
                                      text:
                                          "$_seriesCount/${int.parse(widget.nombreDeSerie!)}",
                                      size: 13,
                                      fontWeight: FontWeight.bold),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          TextComponent(
                              text: "Répétitions",
                              size: 13,
                              fontWeight: FontWeight.bold),
                        ],
                      ),
                      _buildCounter(
                          "Séries",
                          "$_repetitionCount/${widget.nombreDeRepetition}",
                          main2),
                    ],
                  ),
                ],
              )),
    );
  }

  int _repetitionCount = 0;
  bool _isFullScreen = false; // Indique si on est en plein écran

  Widget _buildCounter(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 4)),
          child: Center(
            child: TextComponent(
                text: value, size: 16, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 5),
        TextComponent(
          text: label,
          size: 13,
        ),
      ],
    );
  }
}
