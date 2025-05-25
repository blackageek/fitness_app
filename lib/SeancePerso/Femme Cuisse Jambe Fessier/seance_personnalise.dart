import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gofitnext/main.dart';
import 'package:gofitnext/modules/stockageSeancePersoList/stockage.dart';
import 'package:http/http.dart' as http;
import 'package:gofitnext/modules/details/details_seances_from_seance_perso.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/components/text_components.dart';
import '../../utils/colors.dart';

class CuisseJambeFessier extends StatefulWidget {
  final bool isReturningFromDetails;
  List<String> joursSemaine;
  CuisseJambeFessier({super.key, this.isReturningFromDetails = false, required this.joursSemaine});

  @override
  State<CuisseJambeFessier> createState() => _CuisseJambeFessierState();
}

class _CuisseJambeFessierState extends State<CuisseJambeFessier> {
  final List<String> _warmUpExercises = [
    "Exercice Etirements",
    "Exercice Echauffement",
    "Exercice Etirements V2",
  ];

  final List<String> _mainExercises = [
    "Exercice Elevation Bassin",
    "Exercice Fente Arrière",
    "Exercice Donkey Kicks",
    "Exercice Fente Arrière Croisé",
    "Exercice Kick Back",
    "Exercice Soulever de terre",
    "Exercice Squat Sumo",
    "Exercice Fente avant Fente Arriere",
    "Exercice Extension Jambes au Sol",
    "Exercice Squat Sauter",
    "Exercice Extension Mollet",
    "Exercice Kick Squat",
    "Exercice Fire Hydrant",
    "Exercice Double Fente Avant",
    "Exercice Fentes Croisé Unilateral",
    "Exercice Fente Arriere Gauche Droit",
    "Exercice Squat Tirage sur Orteils",
    "Exercice Kick Back2",
    "Exercice GoodMorning",
    "Exercice Rowing a la Poulie basse",
    "Exercice Squat 3",
    "Exercice Front Squat Halteres",
    "Exercice Rotation des Hanches",
    "Exercice Ekevation genoux",
    "Exercice Elevation Fessier",
    "Exercice Kick Back Unilateral",
    "Exercice Quadriceps",
    "Exercice Crunch Abdominal Suspendu",
    "Exercice Gainage",
    "Exercice Tirage Oblique Haltere",
  ];

  List<List<Map<String, double>>> generateSixMonthsProgram(int sessionsPerWeek) {
    List<String> warmUpVideos = _warmUpExercises;
    List<String> exerciseVideos = List.from(_mainExercises);
    List<String> stretchingVideos = [
      ""
    ];

    List<List<Map<String, double>>> program = [];
    Set<String> usedCombinations = {};
    int totalDays = sessionsPerWeek * 4 * 6; // 6 months worth of workouts
    int exerciseIndex = 0;
    int warmUpIndex = 0;

    while (program.length < totalDays) {
      // Select warm-up and stretching videos
      String warmUp = warmUpVideos[warmUpIndex % warmUpVideos.length];
      String stretching = stretchingVideos[program.length ~/ (sessionsPerWeek * 4) % stretchingVideos.length];

      // Select 3 new exercises every full cycle of permutations
      if (exerciseIndex + 3 > exerciseVideos.length) {
        exerciseIndex = 0;
        warmUpIndex++; // Change warm-up exercise
        exerciseVideos.shuffle();
      }
      List<String> selectedExercises = exerciseVideos.sublist(exerciseIndex, exerciseIndex + 3);

      // Generate all possible orders of the 3 exercises, keeping the first one fixed
      List<List<String>> permutations = [
        [selectedExercises[0], selectedExercises[1], selectedExercises[2]],
        [selectedExercises[0], selectedExercises[2], selectedExercises[1]],
        [selectedExercises[1], selectedExercises[0], selectedExercises[2]],
        [selectedExercises[1], selectedExercises[2], selectedExercises[0]],
        [selectedExercises[2], selectedExercises[0], selectedExercises[1]],
        [selectedExercises[2], selectedExercises[1], selectedExercises[0]],
      ];

      for (List<String> permutation in permutations) {
        if (program.length >= totalDays) break;

        // Create the day's program
        List<Map<String, double>> dayProgram = [
          {warmUp: 0.0},
          {stretching: 0.0},
          for (String exercise in permutation) {exercise: 0.0},
        ];

        // Ensure unique session combinations
        String combinationKey = dayProgram.map((e) => e.keys.first).join(",");
        if (usedCombinations.contains(combinationKey)) continue;

        usedCombinations.add(combinationKey);
        program.add(dayProgram);
      }

      exerciseIndex += 3;
    }

    return program;
  }

  Future<void> _loadProgram() async {
    List<List<Map<String, double>>>? storedProgram =
    await getProgramFromSharedPreferences();
    List<bool>? storedDaysCompleted = await getDaysCompletedFromSharedPreferences();

    if (storedProgram == null) {
      storedProgram = generateSixMonthsProgram(3); // Adjust sessions per week as needed
      await saveProgramToSharedPreferences(storedProgram);
    }

    if (storedDaysCompleted == null) {
      storedDaysCompleted = List.generate(storedProgram.length, (index) => false);
      await saveDaysCompletedToSharedPreferences(storedDaysCompleted);
    }

    _program = storedProgram;
    _daysCompleted = storedDaysCompleted;
    _getCurrentDayIndex(); // Determine current day index

    _countZeroPercentExercises();

    setState(() {});
  }

  List<List<Map<String, double>>> _program = [];
  List<DateTime> datesAssociees = [];
  int _currentDayIndex = -1; // Current day index in the program
  List<bool> _daysCompleted = []; // Track completed days



  Future<void> saveDaysCompletedToSharedPreferences(List<bool> daysCompleted) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String daysCompletedJson = jsonEncode(daysCompleted);
    await prefs.setString('daysCompleted', daysCompletedJson);
  }

  Future<List<bool>?> getDaysCompletedFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? daysCompletedJson = prefs.getString('daysCompleted');
    if (daysCompletedJson != null) {
      return List<bool>.from(jsonDecode(daysCompletedJson));
    }
    return null;
  }

  Future<void> saveProgramGenerationDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await prefs.setString('programGenerationDate', currentDate);
  }

  void _getCurrentDayIndex() async {
    DateTime now = DateTime.now();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? programGenerationDate = prefs.getString('programGenerationDate');

    // Retrieve stored dates
    List<DateTime>? storedDates = await getDatesFromSharedPreferences();

    if (storedDates == null || storedDates.isEmpty) {
      if (programGenerationDate != null) {
        DateTime generationDate = DateTime.parse(programGenerationDate);
        List<DateTime> newDates = [];

        for (int i = 0; i < _program.length; i++) {
          String jourEntrainement = widget.joursSemaine[i % widget.joursSemaine.length];
          DateTime currentDate = findNextDay(generationDate, jourEntrainement);
          newDates.add(currentDate);
          generationDate = currentDate.add(Duration(days: 1));
        }

        await saveDatesToSharedPreferences(newDates);
        datesAssociees = newDates;
      } else {
        datesAssociees = [];
      }
    } else {
      datesAssociees = storedDates;
    }

    _currentDayIndex = datesAssociees.indexWhere((date) => date.isAfter(now) || date.isAtSameMomentAs(now)) - 1;

    if (_currentDayIndex == -1) {
      _currentDayIndex = 0; // Restart if all dates have passed
    }

    setState(() {});
  }
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadProgram();
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      _loadProgram();
    });
    _getCurrentDayIndex();
    saveProgramGenerationDate();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Annulez le timer lorsque le widget est détruit
    super.dispose();
  }



  Future<void> saveProgramToSharedPreferences(List<List<Map<String, double>>> program) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String programJson = jsonEncode(program);
    await prefs.setString('threeMonthsProgram', programJson);
  }

  Future<List<List<Map<String, double>>>?> getProgramFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? programJson = prefs.getString('threeMonthsProgram');
    if (programJson != null) {
      List<dynamic> decodedJson = jsonDecode(programJson);
      return decodedJson.map((day) => (day as List<dynamic>).map((exercise) => Map<String, double>.from(exercise)).toList()).toList();
    }
    return null;
  }

  DateTime findNextDay(DateTime startDate, String targetDay) {
    Map<String, int> daysOfWeek = {
      "Lundi": 1,
      "Mardi": 2,
      "Mercredi": 3,
      "Jeudi": 4,
      "Vendredi": 5,
      "Samedi": 6,
      "Dimanche": 7,
    };

    int targetDayIndex = daysOfWeek[targetDay]!;
    int currentDayIndex = startDate.weekday;

    int daysToAdd = (targetDayIndex - currentDayIndex + 7) % 7;
    return startDate.add(Duration(days: daysToAdd));
  }

  Future<void> saveDatesToSharedPreferences(List<DateTime> dates) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> dateStrings = dates.map((date) => date.toIso8601String()).toList();
    await prefs.setStringList('programDates', dateStrings);
  }

  Future<List<DateTime>?> getDatesFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? dateStrings = prefs.getStringList('programDates');
    if (dateStrings != null) {
      return dateStrings.map((dateString) => DateTime.parse(dateString)).toList();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: mainColor,
        centerTitle: true,
        title: const TextComponent(
          text: "Cuisse Jambe Fessier",
          color: Colors.white,
          size: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 15,
          children: [
            InkWell(
              onTap: () {
                clearProgramAndDates();
              },
              child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: AssetImage("assets/images/ventre_plat_et_abdos.jpg"),
                      fit: BoxFit.cover,
                      alignment: Alignment.center
                  ),
                ),
              ),
            ),

            TextComponent(
              text: "Jour d'entraînement",
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              size: 15,
            ),
            if (_program.isNotEmpty) ...[
              for (int week = 0; week < (_program.length / widget.joursSemaine.length).ceil(); week++)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextComponent(
                      text: "Semaine ${week + 1}",
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      size: 15,
                    ),
                    SizedBox(height: 10),

                    for (int day = 0; day < widget.joursSemaine.length; day++)
                      if ((week * widget.joursSemaine.length + day) < _program.length)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextComponent(
                              text: "Jour ${week * widget.joursSemaine.length + day + 1} (${widget.joursSemaine[day]})",
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700]!,
                              size: 14,
                            ),
                            SizedBox(height: 10),

                            ..._program[week * widget.joursSemaine.length + day].asMap().entries.map((entry) {
                              int exerciseIndex = entry.key;
                              Map<String, double> exerciseMap = entry.value;
                              String exerciseName = exerciseMap.keys.first;
                              double progress = exerciseMap[exerciseName]!;

                              return buildExerciseBox(
                                  exerciseName,
                                  week * widget.joursSemaine.length + day,
                                  exerciseIndex,
                                  progress.toInt()
                              );
                            }).toList(),

                            SizedBox(height: 10),
                          ],
                        ),
                    Divider(color: Colors.grey[300], thickness: 1),
                  ],
                ),
            ] else
              Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  Widget buildExerciseBox(String exerciseName, int dayIndex, int exerciseIndex, int progress) {
    Color circleColor = progress == 100 ? Colors.green : Colors.red;
    return exerciseName==""? Container(): InkWell(
      onTap: () async {
        String numberOfSeries = exerciseDetails[exerciseName]?["séries"] ?? "0";
        String reps = exerciseDetails[exerciseName]?["répétitions"] ?? "0";
        print(numberOfSeries);
        String jourSelectionne = "Jour ${dayIndex}";
        String second = exerciseDetails[exerciseName]?["second"] ?? "0";

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? programGenerationDate = prefs.getString('programGenerationDate');
        print("{$dayIndex ; $exerciseIndex }");
        String videoUrl = exerciseDetails[exerciseName]!["lien_video"]!;
        print(videoUrl);

        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsSeancesFromSeancePerso(
          nomExo: exerciseName,
          nombreDeSerie: numberOfSeries,
          exerciceIndex : "$exerciseIndex",
          jourIndex : "$dayIndex",
          nombreDeRepetition: reps,
          second: int.parse(second),
          videoUrls:  videoUrl,
          combinaisonId: "",
          jourSelectionne: jourSelectionne,
        )));
        // Action lorsque l'utilisateur clique sur l'exercice
      },
      child: Card(
        color: Colors.white,
        elevation: 3,
        child: Container(
          height: 70,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.all(6),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: circleColor,
                  radius: 25,
                  child: Center(
                    child: TextComponent(
                      text: "$progress%",
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                ),
                SizedBox(width: 2),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 240,
                      child: TextComponent(
                        text: exerciseName,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        maxLine: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    TextComponent(
                      text: "Progression: $progress%",
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[700]!,
                      size: 13,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  int getCurrentWeek() {
    if (prefs == null) return 1; // Valeur par défaut si prefs n'est pas initialisé

    DateTime now = DateTime.now();
    String? programGenerationDate = prefs!.getString('programGenerationDate');
    if (programGenerationDate == null) return 1; // Valeur par défaut si la date n'est pas définie

    DateTime startDate = DateTime.parse(programGenerationDate);
    int daysSinceStart = now.difference(startDate).inDays;
    return (daysSinceStart ~/ 7) + 1;
  }
  SharedPreferences? prefs;

  final Map<String, Map<String, String>> exerciseDetails = {
    "Exercice Etirements": {
      "séries": "1",
      "second": "30",
      "répétitions": "2",
      "lien_video": "https://www.youtube.com/watch?v=Peo1G4aAoNw&list=PL9GsY7tWZQwGyL7kKShJcu5yvkhsYjlT9&index=1&t=4s&pp=iAQB"
    },
    "Exercice Elevation Bassin": {
      "séries": "1",
      "second": "30",
      "répétitions": "3",
      "lien_video": "https://www.youtube.com/watch?v=g2CuzioSQ8A&list=PL9GsY7tWZQwGyL7kKShJcu5yvkhsYjlT9&index=2&t=7s&pp=iAQB"
    },
    "Exercice Fente Arrière": {
      "séries": "1",
      "second": "30",
      "répétitions": "3",
      "lien_video": "https://www.youtube.com/watch?v=RO2Ozbjdkqk&list=PL9GsY7tWZQwGyL7kKShJcu5yvkhsYjlT9&index=3&t=3s&pp=iAQB"
    },
    "Exercice Donkey Kicks": {
      "séries": "10",
      "second": "30",
      "répétitions": "4",
      "lien_video": "https://www.youtube.com/watch?v=EAvrDksneKQ&list=PL9GsY7tWZQwGyL7kKShJcu5yvkhsYjlT9&index=4&t=14s&pp=iAQB"
    },
    "Exercice Fente Arrière Croisé": {
      "séries": "10",
      "second": "30",
      "répétitions": "4",
      "lien_video": "https://www.youtube.com/watch?v=FeRSmfddOPI&list=PL9GsY7tWZQwGyL7kKShJcu5yvkhsYjlT9&index=5&t=5s&pp=iAQB4"
    },
    "Exercice Kick Back": {
      "séries": "15",
      "second": "50",
      "répétitions": "5",
      "lien_video": "https://www.youtube.com/watch?v=o6Pu-mLREo8&list=PL9GsY7tWZQwGyL7kKShJcu5yvkhsYjlT9&index=6&t=6s&pp=iAQB"
    },
    "Exercice Soulever de terre": {
      "séries": "15",
      "second": "50",
      "répétitions": "5",
      "lien_video": "https://www.youtube.com/watch?v=yefUA-Sw6qk&list=PL9GsY7tWZQwGyL7kKShJcu5yvkhsYjlT9&index=7&t=8s&pp=iAQB"
    },
    "Exercice Squat Sumo": {
      "séries": "10",
      "second": "30",
      "répétitions": "5",
      "lien_video": "https://www.youtube.com/watch?v=yefUA-Sw6qk&list=PL9GsY7tWZQwGyL7kKShJcu5yvkhsYjlT9&index=7&t=8s&pp=iAQB"
    },
    "Exercice Fente avant Fente Arriere": {
      "séries": "10",
      "second": "30",
      "répétitions": "5",
      "lien_video": "https://www.youtube.com/watch?v=_0W9dMf6oE4&list=PL9GsY7tWZQwGyL7kKShJcu5yvkhsYjlT9&index=9&pp=iAQB"
    },
    "Exercice Extension Jambes au Sol": {
      "séries": "10",
      "second": "30",
      "répétitions": "5",
      "lien_video": "https://www.youtube.com/watch?v=uhzywupv_0M&list=PL9GsY7tWZQwGyL7kKShJcu5yvkhsYjlT9&index=10&pp=iAQB"
    },
    "Exercice Squat Sauter": {
      "séries": "10",
      "second": "30",
      "répétitions": "5",
      "lien_video": "https://www.youtube.com/watch?v=EcObfSLs_NY&list=PL9GsY7tWZQwGyL7kKShJcu5yvkhsYjlT9&index=11&pp=iAQB"
    },
    "Exercice Extension Mollet": {
      "séries": "15",
      "second": "30",
      "répétitions": "5",
      "lien_video": "https://www.youtube.com/watch?v=HSRnJUCHKHA&list=PL9GsY7tWZQwGyL7kKShJcu5yvkhsYjlT9&index=12&pp=iAQB"
    },
    "Exercice Kick Squat": {
      "séries": "12",
      "second": "30",
      "répétitions": "4",
      "lien_video": "https://www.youtube.com/watch?v=zBmC7JjPFZE&list=PL9GsY7tWZQwGyL7kKShJcu5yvkhsYjlT9&index=13&pp=iAQB"
    },
    "Exercice Fire Hydrant": {
      "séries": "10",
      "second": "30",
      "répétitions": "4",
      "lien_video": "https://www.youtube.com/watch?v=e1wu8MJXFX0&list=PL9GsY7tWZQwGyL7kKShJcu5yvkhsYjlT9&index=15&pp=iAQB"
    },
    "Exercice Double Fente Avant": {
      "séries": "1",
      "second": "30",
      "répétitions": "4",
      "lien_video": "https://www.youtube.com/watch?v=WrnywzhLz-k&list=PL9GsY7tWZQwGyL7kKShJcu5yvkhsYjlT9&index=16&t=39s&pp=iAQB"
    },
    "Exercice Fentes Croisé Unilateral": {
      "séries": "12",
      "second": "30",
      "répétitions": "5",
      "lien_video": "https://www.youtube.com/watch?v=QK4qupoHXeE&list=PL9GsY7tWZQwGyL7kKShJcu5yvkhsYjlT9&index=17&pp=iAQB"
    },
    "Exercice Fente Arriere Gauche Droit": {
      "séries": "12",
      "second": "30",
      "répétitions": "5",
      "lien_video": "https://www.youtube.com/watch?v=7XDEQhIDxmU&list=PL9GsY7tWZQwGyL7kKShJcu5yvkhsYjlT9&index=18&pp=iAQB"
    },
    "Exercice Squat Tirage sur Orteils": {
      "séries": "15",
      "second": "30",
      "répétitions": "5",
      "lien_video": "https://www.youtube.com/watch?v=po_q6q1UJ7g&list=PL9GsY7tWZQwGyL7kKShJcu5yvkhsYjlT9&index=19&pp=iAQB"
    },
    "Exercice Kick Back2": {
      "séries": "15",
      "second": "50",
      "répétitions": "5",
      "lien_video": "https://www.youtube.com/watch?v=jMGmc5gwH0M&list=PL9GsY7tWZQwGyL7kKShJcu5yvkhsYjlT9&index=21&pp=iAQB"
    },
    "Exercice GoodMorning": {
      "séries": "20",
      "second": "60",
      "répétitions": "5",
      "lien_video": "https://www.youtube.com/watch?v=2GdDI782ekI&list=PL9GsY7tWZQwGyL7kKShJcu5yvkhsYjlT9&index=22&t=3s&pp=iAQB"
    },
    "Exercice Rowing a la Poulie basse": {
      "séries": "15",
      "second": "50",
      "répétitions": "5",
      "lien_video": "https://www.youtube.com/watch?v=SsYKliYZu40&list=PL9GsY7tWZQwGyL7kKShJcu5yvkhsYjlT9&index=24&t=44s&pp=iAQB"
    },
    "Exercice Squat 3": {
      "séries": "15",
      "second": "50",
      "répétitions": "5",
      "lien_video": "https://www.youtube.com/watch?v=sMWcI_zdY_U&list=PL9GsY7tWZQwGyL7kKShJcu5yvkhsYjlT9&index=25&t=5s&pp=iAQB"
    },
    "Exercice Front Squat Halteres": {
      "séries": "15",
      "second": "40",
      "répétitions": "5",
      "lien_video": "https://www.youtube.com/watch?v=8So2wdZ9rv0&list=PL9GsY7tWZQwGyL7kKShJcu5yvkhsYjlT9&index=26&pp=iAQB"
    },
    "Exercice Rotation des Hanches": {
      "séries": "20",
      "second": "60",
      "répétitions": "5",
      "lien_video": "https://www.youtube.com/watch?v=PRldGoSUP04&list=PL9GsY7tWZQwGyL7kKShJcu5yvkhsYjlT9&index=27&pp=iAQB"
    },
    "Exercice Ekevation genoux": {
      "séries": "15",
      "second": "30",
      "répétitions": "5",
      "lien_video": "https://www.youtube.com/watch?v=d-M0j9QQZBI&list=PL9GsY7tWZQwGyL7kKShJcu5yvkhsYjlT9&index=28&pp=iAQB"
    },
    "Exercice Elevation Fessier": {
      "séries": "15",
      "second": "50",
      "répétitions": "5",
      "lien_video": "https://www.youtube.com/watch?v=SoHcOvDoys4&list=PL9GsY7tWZQwGyL7kKShJcu5yvkhsYjlT9&index=30&pp=iAQB"
    },
    "Exercice Kick Back Unilateral": {
      "séries": "15",
      "second": "50",
      "répétitions": "5",
      "lien_video": "https://www.youtube.com/watch?v=1QwOkihWCzI&list=PL9GsY7tWZQwGyL7kKShJcu5yvkhsYjlT9&index=31&pp=iAQB"
    },
    "Exercice Quadriceps": {
      "séries": "20",
      "second": "60",
      "répétitions": "5",
      "lien_video": "https://www.youtube.com/watch?v=SXV3QFfh4X0&list=PL9GsY7tWZQwGyL7kKShJcu5yvkhsYjlT9&index=32&pp=iAQB"
    },
    "Exercice Crunch Abdominal Suspendu": {
      "séries": "1",
      "second": "15",
      "répétitions": "5",
      "lien_video": "https://www.youtube.com/watch?v=rRg3_ead97w&list=PL9GsY7tWZQwGyL7kKShJcu5yvkhsYjlT9&index=33&pp=iAQB"
    },
    "Exercice Gainage": {
      "séries": "1",
      "second": "20",
      "répétitions": "5",
      "lien_video": "https://www.youtube.com/watch?v=lor9ZeIeHBk&list=PL9GsY7tWZQwGyL7kKShJcu5yvkhsYjlT9&index=34&pp=iAQB"
    },
    "Exercice Tirage Oblique Haltere": {
      "séries": "15",
      "second": "50",
      "répétitions": "2",
      "lien_video": "https://www.youtube.com/watch?v=SgBqJJDSu0Y&list=PL9GsY7tWZQwGyL7kKShJcu5yvkhsYjlT9&index=35&pp=iAQB"
    },
    "Exercice Echauffement": {
      "séries": "1",
      "second": "40",
      "répétitions": "15",
      "lien_video": "https://www.youtube.com/watch?v=UD6i1ZiKNGU&list=PL9GsY7tWZQwGyL7kKShJcu5yvkhsYjlT9&index=29&ab_channel=ABFitness"
    },
  };
  double nbrManque = 0;

  Future<void> _countZeroPercentExercises() async {
    nbrManque = 0; // Réinitialiser le compteur à chaque appel
    for (int i = 0; i < _currentDayIndex; i++) {
      double count = 0;
      for (var exercise in _program[i]) {
        // Vérifiez si la valeur est de type double
        if (exercise.values.first == 0.0) {
          count++;
        }
      }
      // Stockez le compteur dans la dernière entrée du programmePowerBand du jour
      _program[i].last["countZeroPercent"] = count;

      // Ajoutez le count au total
      nbrManque += count; // Accumulez le nombre total d'exercices à 0 %
      print("*******ICICICICIICICICI :**********");
      print(nbrManque);
    }
    await saveNbrManqueToSharedPreferences(nbrManque);
  }
  Future<void> saveNbrManqueToSharedPreferences(double nbrManque) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('nbrManque', nbrManque);
  }

  Future<void> clearProgramAndDates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('threeMonthsProgram');
    await prefs.remove('programDates');
    await prefs.remove('daysCompleted');
    await prefs.remove('programGenerationDate');

    // Réinitialiser les variables d'état
    setState(() {
      _program = [];
      datesAssociees = [];
      _currentDayIndex = -1;
      _daysCompleted = [];
    });
  }
}