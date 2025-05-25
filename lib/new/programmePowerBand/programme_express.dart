import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gofitnext/new/LectureVideoExo/lectureVideosExoFromProgramme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/components/text_components.dart';
import '../../modules/monCompte/controller/controller.dart';
import '../../utils/colors.dart';
import '../LectureVideoExo/lectureVideosExo.dart';
import '../instruction/presentationPowerBand.dart';
import '../instruction/presentationPowerBandPgExpress.dart';

class ProgrammeExpress extends StatefulWidget {
  String path;
  bool isFromAccueil;

  ProgrammeExpress({required this.path,required this.isFromAccueil});

  @override
  State<ProgrammeExpress> createState() => _ProgrammeExpressState();
}

class _ProgrammeExpressState extends State<ProgrammeExpress> {

  late SharedPreferences _prefs;
  final Set<String> _completedSessions = {};

  @override
  void initState() {
    super.initState();
    _initializePreferences();
  }

  Future<void> _initializePreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _loadCompletedSessions();
  }

  void _loadCompletedSessions() {
    Set<String> completedSessions = _prefs.getStringList('completedSessions_pg_express_powerband')?.toSet() ?? {};
    setState(() {
      _completedSessions.addAll(completedSessions);
    });
  }

  void _markSessionAsCompleted(String sessionName) {
    setState(() {
      _completedSessions.add(sessionName);
      _prefs.setStringList('completedSessions_pg_express_powerband', _completedSessions.toList());
    });
  }


  bool _isSessionCompleted(String sessionName) {
    return _completedSessions.contains(sessionName);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: Screen.height(context) / 2,
              child: Stack(
                children: [
                  Container(
                    height: 400,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF333333),
                          Color(0xFF0A0D15),
                          Color(0xFF434040),
                        ],
                        stops: [0.0, 0.8, 10],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 50,
                    child: Column(
                      spacing: 10,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                  onTap: () {Navigator.pop(context);},
                                  child: Icon(Icons.arrow_back_ios,
                                      color: Colors.white)),
                            ],
                          ),
                        ),
                        Container(
                          height: 200,width: Screen.width(context),
                          margin: EdgeInsets.only(left: 20,right: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(image: AssetImage("assets/images/${widget.path}"),fit: BoxFit.cover,alignment: Alignment.center)
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 30,
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10000, sigmaY: 10000),
                          child: Container(
                            width: Screen.width(context) / 1.05,
                            padding: EdgeInsets.only(top: 15,bottom: 15,right: 10,left: 10),
                            height: 160,
                            decoration: BoxDecoration(
                              color: Colors.white12.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            child: Row(
                              spacing: 5,
                              children: [
                                Container(
                                  color: mainColor,
                                  width: 5,
                                  height: 250,
                                ),
                                Column(crossAxisAlignment: CrossAxisAlignment.start,spacing: 10,
                                  children: [
                                    Container(
                                        width: Screen.width(context) / 1.3,
                                        child: TextComponent(textAlign: TextAlign.start,text: "Express",fontWeight: FontWeight.bold,color: Colors.white,)),

                                    Container(
                                      width: Screen.width(context) / 1.2,
                                      child: Row(mainAxisAlignment: MainAxisAlignment.center,spacing: 20,
                                        children: [
                                          Column(
                                            children: [
                                              Container(
                                                height: 60,width: 60,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(image: AssetImage("assets/images/objectifs.png"))
                                                ),
                                              ),
                                              // Icon(Icons.flag_circle_rounded,color: mainColor,size: 35,),
                                              TextComponent(text: "Objectifs",color: Colors.white70,fontWeight: FontWeight.bold,),
                                              TextComponent(text: "Perte de poids",color: Colors.white.withOpacity(0.7),)
                                            ],
                                          ),Column(
                                            children: [
                                              Container(
                                                height: 60,width: 60,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(image: AssetImage("assets/images/level.png"))
                                                ),
                                              ),
                                              // Icon(Icons.flag_circle_rounded,color: mainColor,size: 35,),
                                              TextComponent(text: "Niveau",color: Colors.white70,fontWeight: FontWeight.bold,),
                                              TextComponent(text: "Debutant",color: Colors.white.withOpacity(0.7),)
                                            ],
                                          ),Column(
                                            children: [
                                              Container(
                                                height: 60,width: 60,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(image: AssetImage("assets/images/duree.png"))
                                                ),
                                              ),
                                              // Icon(Icons.flag_circle_rounded,color: mainColor,size: 35,),
                                              TextComponent(text: "Durée",color: Colors.white70,fontWeight: FontWeight.bold,),
                                              TextComponent(text: "8 semaines",color: Colors.white.withOpacity(0.7),)
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,spacing: 12,
                children: [
                  TextComponent(text: "Contenu",fontWeight: FontWeight.bold,color: mainColor,size: 14,),
                  InkWell(
                    onTap : (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => InstructionPowerBandPgExpress(producName: "Express", path: "power1.png")));
                    },
                    child: Card(
                      color: Colors.white,
                      child: Container(
                        height: 80,
                        width: Screen.width(context),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          spacing: 20,
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(image: AssetImage("assets/images/s1.png"),fit: BoxFit.cover)
                              ),
                            ),
                            Expanded(
                              child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 3,
                                children: [
                                  TextComponent(text: "Instruction complète",fontWeight: FontWeight.bold,),
                                ],
                              ),
                            ),
                            Icon( Icons.play_circle_sharp, color: mainColor, size: 35),
                          ],
                        ),
                      ),
                    ),
                  ),
                  TextComponent(text: "Semaine 1",fontWeight: FontWeight.bold,color: mainColor,size: 14,),

                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LectureVideosExoFromProgram(
                        onComplete: () => _markSessionAsCompleted('semaine1_seance1'),
                        path: widget.path, pg : "powerband_pgexpress",
                        exercice: [
                          Exercice(
                            titre: "Developpé Debout à la poulie",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 60,
                            linkVideo: "https://www.youtube.com/watch?v=4uo_CMqRwa0&list=PL27ZZQGb4Vdx5_B92jJXP0oarRXPp5J_1&index=46&pp=iAQB0gcJCYQJAYcqIYzv",
                          ),
                          Exercice(
                            titre: "Overhead Press",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 60,
                            linkVideo: "https://www.youtube.com/watch?v=Wr82oq7BDiw&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=20&t=7s&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Elevation Laterales",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=9xgOBbFmSYE&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=28&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Triceps KickBack",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=fm2dGhQLGYY&list=PL27ZZQGb4Vdx5_B92jJXP0oarRXPp5J_1&index=10&pp=iAQB0gcJCYQJAYcqIYzv",
                          ),
                          Exercice(
                            titre: "Front Squat",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 60,
                            linkVideo: "https://www.youtube.com/watch?v=Mbua4MPlX4I&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=24&pp=iAQB",
                          ),
                        ],
                      )));
                    },
                    child: Box(1,"s1.png", 1, "Full Body Push",false),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LectureVideosExoFromProgram(
                        onComplete: () => _markSessionAsCompleted('semaine1_seance2'),
                        path: widget.path, pg : "powerband_pgexpress",
                        exercice: [
                          Exercice(
                            titre: "Soulevé de terre",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 90,
                            linkVideo: "https://www.youtube.com/watch?v=ZjAMtITHkRA&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=34&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Rowing Buste Penché",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 60,
                            linkVideo: "https://www.youtube.com/watch?v=L-Ada7ypMpo&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=17&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Biceps Curl Poulie Basse",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=lJZqNu8jJEw&list=PL27ZZQGb4Vdx5_B92jJXP0oarRXPp5J_1&index=30&pp=iAQB0gcJCYQJAYcqIYzv",
                          ),
                          Exercice(
                            titre: "Leg Curl",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=YjzWXDSyUsI&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=5&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Extension Mollet Unilatérale",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 30,
                            linkVideo: "https://www.youtube.com/watch?v=uMMv5GdkLV8&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=4&pp=iAQB",
                          ),
                        ],
                      )));
                    },
                    child: Box(1,"s2.png", 2, "Full Body Pull",false),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LectureVideosExoFromProgram(
                        onComplete: () => _markSessionAsCompleted('semaine1_seance3'),
                        path: widget.path, pg : "powerband_pgexpress",
                        exercice: [
                          Exercice(
                            titre: "Developpé Debout à la poulie",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 60,
                            linkVideo: "https://www.youtube.com/watch?v=4uo_CMqRwa0&list=PL27ZZQGb4Vdx5_B92jJXP0oarRXPp5J_1&index=46&pp=iAQB0gcJCYQJAYcqIYzv",
                          ),
                          Exercice(
                            titre: "Overhead Press",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 60,
                            linkVideo: "https://www.youtube.com/watch?v=Wr82oq7BDiw&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=20&t=7s&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Triceps Extension Poulie Haute",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=OKr0saA8AXs&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=43&pp=iAQB0gcJCYQJAYcqIYzv",
                          ),
                          Exercice(
                            titre: "Squat",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 60,
                            linkVideo: "https://www.youtube.com/watch?v=5bgm8P0Orc4&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=16&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Fentes",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=bMghA7DYexI&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=25&pp=iAQB",
                          ),
                        ],
                      )));
                    },
                    child: Box(1,"s3.png", 3, "Full Body Push",false),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LectureVideosExoFromProgram(
                        onComplete: () => _markSessionAsCompleted('semaine1_seance4'),
                        path: widget.path, pg : "powerband_pgexpress",
                        exercice: [
                          Exercice(
                            titre: "Soulevé de Terre",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 90,
                            linkVideo: "https://www.youtube.com/watch?v=ZjAMtITHkRA&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=34&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Tirage Horizontal Unilatéral",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 60,
                            linkVideo: "https://www.youtube.com/watch?v=6KVKMIbUH-Y&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=15&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Face Pull au sol",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=g7_9dPjXbI4&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=36&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Biceps Curl Pronation",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=VKZBNQCYebM&list=PL27ZZQGb4Vdx5_B92jJXP0oarRXPp5J_1&index=44&pp=iAQB0gcJCYQJAYcqIYzv",
                          ),
                          Exercice(
                            titre: "Extension Mollet Unilatéral",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 30,
                            linkVideo: "https://www.youtube.com/watch?v=uMMv5GdkLV8&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=4&pp=iAQB",
                          ),
                        ],
                      )));
                    },
                    child: Box(1,"s1.png", 4, "Full Body Pull",false),
                  ),

                  TextComponent(text: "Semaine 2",fontWeight: FontWeight.bold,color: mainColor,size: 14,),

                  InkWell(
                    onTap: () {
                      widget.isFromAccueil? showToast(context, "Cette vidéo est Bloquée", Colors.red): Navigator.push(context, MaterialPageRoute(builder: (context) => LectureVideosExoFromProgram(
                        onComplete: () => _markSessionAsCompleted('semaine2_seance1'),
                        path: widget.path, pg : "powerband_pgexpress",
                        exercice: [
                          Exercice(
                            titre: "Développé Debout à la poulie",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 60,
                            linkVideo: "https://www.youtube.com/watch?v=4uo_CMqRwa0&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=31&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Overhead Press",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 60,
                            linkVideo: "https://www.youtube.com/watch?v=Wr82oq7BDiw&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=20&t=7s&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Ecarté Unilatéral",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=zAfnnw1-3rc&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=37&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Triceps KickBack",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=fm2dGhQLGYY&list=PL27ZZQGb4Vdx5_B92jJXP0oarRXPp5J_1&index=10&pp=iAQB0gcJCYQJAYcqIYzv",
                          ),
                          Exercice(
                            titre: "Fentes",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 60,
                            linkVideo: "https://www.youtube.com/watch?v=bMghA7DYexI&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=25&pp=iAQB",
                          ),
                        ],
                      )));
                    },
                    child: Box(2,"s1.png", 1, "Full Body Push",true),
                  ),
                  InkWell(
                    onTap: () {
                      widget.isFromAccueil? showToast(context, "Cette vidéo est Bloquée", Colors.red): Navigator.push(context, MaterialPageRoute(builder: (context) => LectureVideosExoFromProgram(
                        onComplete: () => _markSessionAsCompleted('semaine2_seance2'),
                        path: widget.path, pg : "powerband_pgexpress",
                        exercice: [
                          Exercice(
                            titre: "Soulevé de Terre",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 90,
                            linkVideo: "https://www.youtube.com/watch?v=ZjAMtITHkRA&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=34&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Rowing Buste Penché",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 60,
                            linkVideo: "https://www.youtube.com/watch?v=L-Ada7ypMpo&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=17&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Biceps Curl Poulie Basse",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=lJZqNu8jJEw&list=PL27ZZQGb4Vdx5_B92jJXP0oarRXPp5J_1&index=30&pp=iAQB0gcJCYQJAYcqIYzv",
                          ),
                          Exercice(
                            titre: "Leg Curl",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=YjzWXDSyUsI&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=5&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Extension Mollet Unilatéral",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 30,
                            linkVideo: "https://www.youtube.com/watch?v=uMMv5GdkLV8&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=4&pp=iAQB",
                          ),
                        ],
                      )));
                    },
                    child: Box(2,"s2.png", 2, "Full Body Pull",true),
                  ),
                  InkWell(
                    onTap: () {
                      widget.isFromAccueil? showToast(context, "Cette vidéo est Bloquée", Colors.red): Navigator.push(context, MaterialPageRoute(builder: (context) => LectureVideosExoFromProgram(
                        onComplete: () => _markSessionAsCompleted('semaine2_seance3'),
                        path: widget.path, pg : "powerband_pgexpress",
                        exercice: [
                          Exercice(
                            titre: "Développé Debout à la poulie",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 60,
                            linkVideo: "https://www.youtube.com/watch?v=4uo_CMqRwa0&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=31&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Overhead Press",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 60,
                            linkVideo: "https://www.youtube.com/watch?v=Wr82oq7BDiw&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=20&t=7s&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Triceps Extension Poulie Haute",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=OKr0saA8AXs&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=43&pp=iAQB0gcJCYQJAYcqIYzv",
                          ),
                          Exercice(
                            titre: "Triceps Extension Vertical",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=RbA_omOwd34&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=42&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Squat",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 90,
                            linkVideo: "https://www.youtube.com/watch?v=5bgm8P0Orc4&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=16&pp=iAQB",
                          ),
                        ],
                      )));
                    },
                    child: Box(2,"s3.png", 3, "Full Body Push",true),
                  ),
                  InkWell(
                    onTap: () {
                      widget.isFromAccueil? showToast(context, "Cette vidéo est Bloquée", Colors.red): Navigator.push(context, MaterialPageRoute(builder: (context) => LectureVideosExoFromProgram(
                        onComplete: () => _markSessionAsCompleted('semaine2_seance4'),
                        path: widget.path, pg : "powerband_pgexpress",
                        exercice: [
                          Exercice(
                            titre: "Soulevé de Terre",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 90,
                            linkVideo: "https://www.youtube.com/watch?v=ZjAMtITHkRA&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=34&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Tirage Horizontal Unilatéral",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 60,
                            linkVideo: "https://www.youtube.com/watch?v=6KVKMIbUH-Y&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=15&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Face Pull au sol",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=g7_9dPjXbI4&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=36&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Biceps Curl Prise Marteau",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=tL0ihj9VtlM&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=23&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Extension Mollet Unilatérale",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 30,
                            linkVideo: "https://www.youtube.com/watch?v=uMMv5GdkLV8&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=4&pp=iAQB",
                          ),
                        ],
                      )));
                    },
                    child: Box(2,"s1.png", 4, "Full Body Pull",true),
                  ),

                  TextComponent(text: "Semaine 3",fontWeight: FontWeight.bold,color: mainColor,size: 14,),

                  InkWell(
                    onTap: () {
                      widget.isFromAccueil? showToast(context, "Cette vidéo est Bloquée", Colors.red): Navigator.push(context, MaterialPageRoute(builder: (context) => LectureVideosExoFromProgram(
                        onComplete: () => _markSessionAsCompleted('semaine3_seance1'),
                        path: widget.path, pg : "powerband_pgexpress",
                        exercice: [
                          Exercice(
                            titre: "Développé Debout à la poulie",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 75,
                            linkVideo: "https://www.youtube.com/watch?v=4uo_CMqRwa0&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=31&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Overhead Press",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 75,
                            linkVideo: "https://www.youtube.com/watch?v=Wr82oq7BDiw&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=20&t=7s&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Elevation Laterales",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=9xgOBbFmSYE&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=28&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Triceps KickBack",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=fm2dGhQLGYY&list=PL27ZZQGb4Vdx5_B92jJXP0oarRXPp5J_1&index=10&pp=iAQB0gcJCYQJAYcqIYzv",
                          ),
                          Exercice(
                            titre: "Front Squat",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 90,
                            linkVideo: "https://www.youtube.com/watch?v=Mbua4MPlX4I&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=24&pp=iAQB",
                          ),
                        ],
                      )));
                    },
                    child: Box(3,"s1.png", 1, "Full Body Push",true),
                  ),
                  InkWell(
                    onTap: () {
                      widget.isFromAccueil? showToast(context, "Cette vidéo est Bloquée", Colors.red): Navigator.push(context, MaterialPageRoute(builder: (context) => LectureVideosExoFromProgram(
                        onComplete: () => _markSessionAsCompleted('semaine3_seance2'),
                        path: widget.path, pg : "powerband_pgexpress",
                        exercice: [
                          Exercice(
                            titre: "Soulevé de Terre",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 120, // Repos augmenté
                            linkVideo: "https://www.youtube.com/watch?v=ZjAMtITHkRA&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=34&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Rowing Buste Penché",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 75,
                            linkVideo: "https://www.youtube.com/watch?v=L-Ada7ypMpo&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=17&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Biceps Curl Poulie Basse",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=lJZqNu8jJEw&list=PL27ZZQGb4Vdx5_B92jJXP0oarRXPp5J_1&index=30&pp=iAQB0gcJCYQJAYcqIYzv",
                          ),
                          Exercice(
                            titre: "Leg Curl",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=YjzWXDSyUsI&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=5&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Extension Mollet Unilatéral",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 30,
                            linkVideo: "https://www.youtube.com/watch?v=uMMv5GdkLV8&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=4&pp=iAQB",
                          ),
                        ],
                      )));
                    },
                    child: Box(3,"s2.png", 2, "Full Body Pull",true),
                  ),
                  InkWell(
                    onTap: () {
                      widget.isFromAccueil? showToast(context, "Cette vidéo est Bloquée", Colors.red): Navigator.push(context, MaterialPageRoute(builder: (context) => LectureVideosExoFromProgram(
                        onComplete: () => _markSessionAsCompleted('semaine3_seance3'),
                        path: widget.path, pg : "powerband_pgexpress",
                        exercice: [
                          Exercice(
                            titre: "Développé Debout à la poulie",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 75,
                            linkVideo: "https://www.youtube.com/watch?v=4uo_CMqRwa0&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=31&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Overhead Press",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 75,
                            linkVideo: "https://www.youtube.com/watch?v=Wr82oq7BDiw&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=20&t=7s&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Triceps Extension Poulie Haute",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=OKr0saA8AXs&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=43&pp=iAQB0gcJCYQJAYcqIYzv",
                          ),
                          Exercice(
                            titre: "Squat",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 90,
                            linkVideo: "https://www.youtube.com/watch?v=5bgm8P0Orc4&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=16&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Fentes",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 60,
                            linkVideo: "https://www.youtube.com/watch?v=bMghA7DYexI&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=25&pp=iAQB",
                          ),
                        ],
                      )));
                    },
                    child: Box(3,"s3.png", 3, "Full Body Push",true),
                  ),
                  InkWell(
                    onTap: () {
                      widget.isFromAccueil? showToast(context, "Cette vidéo est Bloquée", Colors.red): Navigator.push(context, MaterialPageRoute(builder: (context) => LectureVideosExoFromProgram(
                        onComplete: () => _markSessionAsCompleted('semaine3_seance4'),
                        path: widget.path, pg : "powerband_pgexpress",
                        exercice: [
                          Exercice(
                            titre: "Soulevé de Terre",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 120,
                            linkVideo: "https://www.youtube.com/watch?v=ZjAMtITHkRA&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=34&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Tirage Horizontal Unilatéral",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 75,
                            linkVideo: "https://www.youtube.com/watch?v=6KVKMIbUH-Y&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=15&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Face Pull au sol",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=g7_9dPjXbI4&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=36&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Biceps Curl Prise Pronation",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=VKZBNQCYebM&list=PL27ZZQGb4Vdx5_B92jJXP0oarRXPp5J_1&index=44&pp=iAQB0gcJCYQJAYcqIYzv",
                          ),
                          Exercice(
                            titre: "Extension Mollet Unilatéral",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 30,
                            linkVideo: "https://www.youtube.com/watch?v=uMMv5GdkLV8&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=4&pp=iAQB",
                          ),
                        ],
                      )));
                    },
                    child: Box(3,"s1.png", 4, "Full Body Pull",true),
                  ),

                  TextComponent(text: "Semaine 4",fontWeight: FontWeight.bold,color: mainColor,size: 14,),
                  InkWell(
                    onTap: () {
                      widget.isFromAccueil? showToast(context, "Cette vidéo est Bloquée", Colors.red): Navigator.push(context, MaterialPageRoute(builder: (context) => LectureVideosExoFromProgram(
                        onComplete: () => _markSessionAsCompleted('semaine4_seance1'),
                        path: widget.path, pg : "powerband_pgexpress",
                        exercice: [
                          Exercice(
                            titre: "Développé Debout",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 60,
                            linkVideo: "https://www.youtube.com/watch?v=4uo_CMqRwa0&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=31&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Overhead Press",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 60,
                            linkVideo: "https://www.youtube.com/watch?v=Wr82oq7BDiw&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=20&t=7s&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Ecarté Unilatéral",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=zAfnnw1-3rc&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=37&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Triceps KickBack",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=fm2dGhQLGYY&list=PL27ZZQGb4Vdx5_B92jJXP0oarRXPp5J_1&index=10&pp=iAQB0gcJCYQJAYcqIYzv",
                          ),
                          Exercice(
                            titre: "Fentes",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 60,
                            linkVideo: "https://www.youtube.com/watch?v=bMghA7DYexI&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=25&pp=iAQB",
                          ),
                        ],
                      )));
                    },
                    child: Box(4,"s1.png", 1, "Full Body Push",true),
                  ),
                  InkWell(
                    onTap: () {
                      widget.isFromAccueil? showToast(context, "Cette vidéo est Bloquée", Colors.red): Navigator.push(context, MaterialPageRoute(builder: (context) => LectureVideosExoFromProgram(
                        onComplete: () => _markSessionAsCompleted('semaine4_seance2'),
                        path: widget.path, pg : "powerband_pgexpress",
                        exercice: [
                          Exercice(
                            titre: "Soulevé de Terre",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 90,
                            linkVideo: "https://www.youtube.com/watch?v=ZjAMtITHkRA&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=34&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Rowing Buste Penché",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 60,
                            linkVideo: "https://www.youtube.com/watch?v=L-Ada7ypMpo&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=17&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Biceps Curl Poulie Basse",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=lJZqNu8jJEw&list=PL27ZZQGb4Vdx5_B92jJXP0oarRXPp5J_1&index=30&pp=iAQB0gcJCYQJAYcqIYzv",
                          ),
                          Exercice(
                            titre: "Leg Curl",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=YjzWXDSyUsI&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=5&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Extension Mollet Unilatéral",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 30,
                            linkVideo: "https://www.youtube.com/watch?v=uMMv5GdkLV8&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=4&pp=iAQB",
                          ),
                        ],
                      )));
                    },
                    child: Box(4,"s2.png", 2, "Full Body Pull",true),
                  ),
                  InkWell(
                    onTap: () {
                      widget.isFromAccueil? showToast(context, "Cette vidéo est Bloquée", Colors.red): Navigator.push(context, MaterialPageRoute(builder: (context) => LectureVideosExoFromProgram(
                        onComplete: () => _markSessionAsCompleted('semaine4_seance3'),
                        path: widget.path, pg : "powerband_pgexpress",
                        exercice: [
                          Exercice(
                            titre: "Développé Debout à la poulie",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 60,
                            linkVideo: "https://www.youtube.com/watch?v=4uo_CMqRwa0&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=31&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Overhead Press",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 60,
                            linkVideo: "https://www.youtube.com/watch?v=Wr82oq7BDiw&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=20&t=7s&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Triceps Extension Poulie Haute",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=OKr0saA8AXs&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=43&pp=iAQB0gcJCYQJAYcqIYzv",
                          ),
                          Exercice(
                            titre: "Triceps Extension Vertical",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=RbA_omOwd34&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=42&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Squat",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 90,
                            linkVideo: "https://www.youtube.com/watch?v=5bgm8P0Orc4&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=16&pp=iAQB",
                          ),
                        ],
                      )));
                    },
                    child: Box(4,"s3.png", 3, "Full Body Push",true),
                  ),
                  InkWell(
                    onTap: () {
                      widget.isFromAccueil? showToast(context, "Cette vidéo est Bloquée", Colors.red): Navigator.push(context, MaterialPageRoute(builder: (context) => LectureVideosExoFromProgram(
                        onComplete: () => _markSessionAsCompleted('semaine4_seance4'),
                        path: widget.path, pg : "powerband_pgexpress",
                        exercice: [
                          Exercice(
                            titre: "Soulevé de Terre",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 90,
                            linkVideo: "https://www.youtube.com/watch?v=ZjAMtITHkRA&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=34&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Tirage Horizontal Unilatéral",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 60,
                            linkVideo: "https://www.youtube.com/watch?v=6KVKMIbUH-Y&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=15&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Face Pull au sol",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=g7_9dPjXbI4&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=36&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Biceps Curl Prise Marteau",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=tL0ihj9VtlM&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=23&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Extension Mollet Unilatéral",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 30,
                            linkVideo: "https://www.youtube.com/watch?v=uMMv5GdkLV8&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=4&pp=iAQB",
                          ),
                        ],
                      )));
                    },
                    child: Box(4,"s1.png", 4, "Full Body Pull",true),
                  ),

                  TextComponent(text: "Semaine 5",fontWeight: FontWeight.bold,color: mainColor,size: 14,),
                  InkWell(
                    onTap: () {
                      widget.isFromAccueil? showToast(context, "Cette vidéo est Bloquée", Colors.red): Navigator.push(context, MaterialPageRoute(builder: (context) => LectureVideosExoFromProgram(
                        onComplete: () => _markSessionAsCompleted('semaine5_seance1'),
                        path: widget.path, pg : "powerband_pgexpress",
                        exercice: [
                          Exercice(
                            titre: "Développé Debout à la poulie",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 60,
                            linkVideo: "https://www.youtube.com/watch?v=4uo_CMqRwa0&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=31&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Overhead Press",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 60,
                            linkVideo: "https://www.youtube.com/watch?v=Wr82oq7BDiw&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=20&t=7s&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Elevation Laterale",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=9xgOBbFmSYE&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=28&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Triceps KickBack",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=fm2dGhQLGYY&list=PL27ZZQGb4Vdx5_B92jJXP0oarRXPp5J_1&index=10&pp=iAQB0gcJCYQJAYcqIYzv",
                          ),
                          Exercice(
                            titre: "Front Squat",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 60,
                            linkVideo: "https://www.youtube.com/watch?v=Mbua4MPlX4I&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=24&pp=iAQB",
                          ),
                        ],
                      )));
                    },
                    child: Box(5,"s1.png", 1, "Full Body Push",true),
                  ),
                  InkWell(
                    onTap: () {
                      widget.isFromAccueil? showToast(context, "Cette vidéo est Bloquée", Colors.red): Navigator.push(context, MaterialPageRoute(builder: (context) => LectureVideosExoFromProgram(
                        onComplete: () => _markSessionAsCompleted('semaine5_seance2'),
                        path: widget.path, pg : "powerband_pgexpress",
                        exercice: [
                          Exercice(
                            titre: "Soulevé de Terre",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 90,
                            linkVideo: "https://www.youtube.com/watch?v=ZjAMtITHkRA&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=34&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Rowing Buste Penché",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 60,
                            linkVideo: "https://www.youtube.com/watch?v=L-Ada7ypMpo&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=17&pp=iAQB",
                          ),
                          Exercice(
                            titre: "F-Biceps Curl Poulie Basse",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=lJZqNu8jJEw&list=PL27ZZQGb4Vdx5_B92jJXP0oarRXPp5J_1&index=30&pp=iAQB0gcJCYQJAYcqIYzv",
                          ),
                          Exercice(
                            titre: "Leg Curl",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=YjzWXDSyUsI&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=5&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Extension Mollet Unilatéral",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 30,
                            linkVideo: "https://www.youtube.com/watch?v=uMMv5GdkLV8&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=4&pp=iAQB",
                          ),
                        ],
                      )));
                    },
                    child: Box(5,"s2.png", 2, "Full Body Pull",true),
                  ),
                  InkWell(
                    onTap: () {
                      widget.isFromAccueil? showToast(context, "Cette vidéo est Bloquée", Colors.red): Navigator.push(context, MaterialPageRoute(builder: (context) => LectureVideosExoFromProgram(
                        onComplete: () => _markSessionAsCompleted('semaine5_seance3'),
                        path: widget.path, pg : "powerband_pgexpress",
                        exercice: [
                          Exercice(
                            titre: "Développé Debout à la poulie",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 60,
                            linkVideo: "https://www.youtube.com/watch?v=4uo_CMqRwa0&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=31&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Overhead Press",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 60,
                            linkVideo: "https://www.youtube.com/watch?v=Wr82oq7BDiw&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=20&t=7s&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Triceps Extension Poulie Haute",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=OKr0saA8AXs&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=43&pp=iAQB0gcJCYQJAYcqIYzv",
                          ),
                          Exercice(
                            titre: "Squat",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 90,
                            linkVideo: "https://www.youtube.com/watch?v=5bgm8P0Orc4&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=16&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Fentes",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 60,
                            linkVideo: "https://www.youtube.com/watch?v=bMghA7DYexI&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=25&pp=iAQB",
                          ),
                        ],
                      )));
                    },
                    child: Box(5,"s3.png", 3, "Full Body Push",true),
                  ),
                  InkWell(
                    onTap: () {
                      widget.isFromAccueil? showToast(context, "Cette vidéo est Bloquée", Colors.red): Navigator.push(context, MaterialPageRoute(builder: (context) => LectureVideosExoFromProgram(
                        onComplete: () => _markSessionAsCompleted('semaine5_seance4'),
                        path: widget.path, pg : "powerband_pgexpress",
                        exercice: [
                          Exercice(
                            titre: "Soulevé de Terre",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 90,
                            linkVideo: "https://www.youtube.com/watch?v=ZjAMtITHkRA&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=34&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Tirage Horizontal Unilatéral",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 60,
                            linkVideo: "https://www.youtube.com/watch?v=6KVKMIbUH-Y&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=15&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Face Pull",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=g7_9dPjXbI4&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=36&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Biceps Curl Prise Pronation",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=VKZBNQCYebM&list=PL27ZZQGb4Vdx5_B92jJXP0oarRXPp5J_1&index=44&pp=iAQB0gcJCYQJAYcqIYzv",
                          ),
                          Exercice(
                            titre: "Extension Mollet Unilatéral",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 30,
                            linkVideo: "https://www.youtube.com/watch?v=uMMv5GdkLV8&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=4&pp=iAQB",
                          ),
                        ],
                      )));
                    },
                    child: Box(5,"s1.png", 4, "Full Body Pull",true),
                  ),

                  TextComponent(text: "Semaine 6",fontWeight: FontWeight.bold,color: mainColor,size: 14,),
                  InkWell(
                    onTap: () {
                      widget.isFromAccueil? showToast(context, "Cette vidéo est Bloquée", Colors.red): Navigator.push(context, MaterialPageRoute(builder: (context) => LectureVideosExoFromProgram(
                        onComplete: () => _markSessionAsCompleted('semaine6_seance1'),
                        path: widget.path, pg : "powerband_pgexpress",
                        exercice: [
                          Exercice(
                            titre: "Développé Debout",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 60,
                            linkVideo: "https://www.youtube.com/watch?v=4uo_CMqRwa0&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=31&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Overhead Press",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 60,
                            linkVideo: "https://www.youtube.com/watch?v=Wr82oq7BDiw&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=20&t=7s&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Ecarté Unilatéral",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=zAfnnw1-3rc&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=37&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Triceps KickBack",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=fm2dGhQLGYY&list=PL27ZZQGb4Vdx5_B92jJXP0oarRXPp5J_1&index=10&pp=iAQB0gcJCYQJAYcqIYzv",
                          ),
                          Exercice(
                            titre: "Fentes",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 60,
                            linkVideo: "https://www.youtube.com/watch?v=bMghA7DYexI&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=25&pp=iAQB",
                          ),
                        ],
                      )));
                    },
                    child: Box(6,"s1.png", 1, "Full Body Push",true),
                  ),
                  InkWell(
                    onTap: () {
                      widget.isFromAccueil? showToast(context, "Cette vidéo est Bloquée", Colors.red): Navigator.push(context, MaterialPageRoute(builder: (context) => LectureVideosExoFromProgram(
                        onComplete: () => _markSessionAsCompleted('semaine6_seance2'),
                        path: widget.path, pg : "powerband_pgexpress",
                        exercice: [
                          Exercice(
                            titre: "Soulevé de Terre",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 90,
                            linkVideo: "https://www.youtube.com/watch?v=ZjAMtITHkRA&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=34&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Rowing Buste Penché",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 60,
                            linkVideo: "https://www.youtube.com/watch?v=L-Ada7ypMpo&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=17&pp=iAQB",
                          ),
                          Exercice(
                            titre: "F-Biceps Curl Poulie Basse",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=lJZqNu8jJEw&list=PL27ZZQGb4Vdx5_B92jJXP0oarRXPp5J_1&index=30&pp=iAQB0gcJCYQJAYcqIYzv",
                          ),
                          Exercice(
                            titre: "Leg Curl",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=YjzWXDSyUsI&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=5&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Extension Mollet Unilatéral",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 30,
                            linkVideo: "https://www.youtube.com/watch?v=uMMv5GdkLV8&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=4&pp=iAQB",
                          ),
                        ],
                      )));
                    },
                    child: Box(6,"s2.png", 2, "Full Body Pull",true),
                  ),
                  InkWell(
                    onTap: () {
                      widget.isFromAccueil? showToast(context, "Cette vidéo est Bloquée", Colors.red): Navigator.push(context, MaterialPageRoute(builder: (context) => LectureVideosExoFromProgram(
                        onComplete: () => _markSessionAsCompleted('semaine6_seance3'),
                        path: widget.path, pg : "powerband_pgexpress",
                        exercice: [
                          Exercice(
                            titre: "Développé Debout à la poulie",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 60,
                            linkVideo: "https://www.youtube.com/watch?v=4uo_CMqRwa0&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=31&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Overhead Press",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 60,
                            linkVideo: "https://www.youtube.com/watch?v=Wr82oq7BDiw&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=20&t=7s&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Triceps Extension Poulie Haute",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=OKr0saA8AXs&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=43&pp=iAQB0gcJCYQJAYcqIYzv",
                          ),
                          Exercice(
                            titre: "Triceps Extension Vertical",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=RbA_omOwd34&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=42&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Squat",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 90,
                            linkVideo: "https://www.youtube.com/watch?v=5bgm8P0Orc4&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=16&pp=iAQB",
                          ),
                        ],
                      )));
                    },
                    child: Box(6,"s3.png", 3, "Full Body Push",true),
                  ),
                  InkWell(
                    onTap: () {
                      widget.isFromAccueil? showToast(context, "Cette vidéo est Bloquée", Colors.red): Navigator.push(context, MaterialPageRoute(builder: (context) => LectureVideosExoFromProgram(
                        onComplete: () => _markSessionAsCompleted('semaine6_seance4'),
                        path: widget.path, pg : "powerband_pgexpress",
                        exercice: [
                          Exercice(
                            titre: "Soulevé de Terre",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 90,
                            linkVideo: "https://www.youtube.com/watch?v=ZjAMtITHkRA&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=34&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Tirage Horizontal Unilatéral",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 60,
                            linkVideo: "https://www.youtube.com/watch?v=6KVKMIbUH-Y&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=15&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Face Pull au sol",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=g7_9dPjXbI4&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=36&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Biceps Curl Prise Marteau",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=tL0ihj9VtlM&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=23&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Extension Mollet Unilatéral",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 30,
                            linkVideo: "https://www.youtube.com/watch?v=uMMv5GdkLV8&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=4&pp=iAQB",
                          ),
                        ],
                      )));
                    },
                    child: Box(6,"s1.png", 4, "Full Body Pull",true),
                  ),

                  TextComponent(text: "Semaine 7",fontWeight: FontWeight.bold,color: mainColor,size: 14,),
                  InkWell(
                    onTap: () {
                      widget.isFromAccueil? showToast(context, "Cette vidéo est Bloquée", Colors.red): Navigator.push(context, MaterialPageRoute(builder: (context) => LectureVideosExoFromProgram(
                        onComplete: () => _markSessionAsCompleted('semaine7_seance1'),
                        path: widget.path, pg : "powerband_pgexpress",
                        exercice: [
                          Exercice(
                            titre: "Développé Debout à la poulie",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 75,
                            linkVideo: "https://www.youtube.com/watch?v=4uo_CMqRwa0&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=31&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Overhead Press",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 75,
                            linkVideo: "https://www.youtube.com/watch?v=Wr82oq7BDiw&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=20&t=7s&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Elevation Laterales",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=9xgOBbFmSYE&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=28&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Triceps KickBack",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=fm2dGhQLGYY&list=PL27ZZQGb4Vdx5_B92jJXP0oarRXPp5J_1&index=10&pp=iAQB0gcJCYQJAYcqIYzv",
                          ),
                          Exercice(
                            titre: "Front Squat",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 90,
                            linkVideo: "https://www.youtube.com/watch?v=Mbua4MPlX4I&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=24&pp=iAQB",
                          ),
                        ],
                      )));
                    },
                    child: Box(7,"s1.png", 1, "Full Body Push",true),
                  ),
                  InkWell(
                    onTap: () {
                      widget.isFromAccueil? showToast(context, "Cette vidéo est Bloquée", Colors.red): Navigator.push(context, MaterialPageRoute(builder: (context) => LectureVideosExoFromProgram(
                        onComplete: () => _markSessionAsCompleted('semaine7_seance2'),
                        path: widget.path, pg : "powerband_pgexpress",
                        exercice: [
                          Exercice(
                            titre: "Soulevé de Terre",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 120,
                            linkVideo: "https://www.youtube.com/watch?v=ZjAMtITHkRA&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=34&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Rowing Buste Penché",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 75,
                            linkVideo: "https://www.youtube.com/watch?v=L-Ada7ypMpo&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=17&pp=iAQB",
                          ),
                          Exercice(
                            titre: "F-Biceps Curl Poulie Basse",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=lJZqNu8jJEw&list=PL27ZZQGb4Vdx5_B92jJXP0oarRXPp5J_1&index=30&pp=iAQB0gcJCYQJAYcqIYzv",
                          ),
                          Exercice(
                            titre: "Leg Curl",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=YjzWXDSyUsI&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=5&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Extension Mollet Unilatérale",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 30,
                            linkVideo: "https://www.youtube.com/watch?v=uMMv5GdkLV8&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=4&pp=iAQB",
                          ),
                        ],
                      )));
                    },
                    child: Box(7,"s2.png", 2, "Full Body Pull",true),
                  ),
                  InkWell(
                    onTap: () {
                      widget.isFromAccueil? showToast(context, "Cette vidéo est Bloquée", Colors.red): Navigator.push(context, MaterialPageRoute(builder: (context) => LectureVideosExoFromProgram(
                        onComplete: () => _markSessionAsCompleted('semaine7_seance3'),
                        path: widget.path, pg : "powerband_pgexpress",
                        exercice: [
                          Exercice(
                            titre: "Développé Debout à la poulie",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 75,
                            linkVideo: "https://www.youtube.com/watch?v=4uo_CMqRwa0&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=31&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Overhead Press",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 75,
                            linkVideo: "https://www.youtube.com/watch?v=Wr82oq7BDiw&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=20&t=7s&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Triceps Extension Poulie Haute",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=OKr0saA8AXs&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=43&pp=iAQB0gcJCYQJAYcqIYzv",
                          ),
                          Exercice(
                            titre: "Squat",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 90,
                            linkVideo: "https://www.youtube.com/watch?v=5bgm8P0Orc4&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=16&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Fentes",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 60,
                            linkVideo: "https://www.youtube.com/watch?v=bMghA7DYexI&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=25&pp=iAQB",
                          ),
                        ],
                      )));
                    },
                    child: Box(7,"s3.png", 3, "Full Body Push",true),
                  ),
                  InkWell(
                    onTap: () {
                      widget.isFromAccueil? showToast(context, "Cette vidéo est Bloquée", Colors.red): Navigator.push(context, MaterialPageRoute(builder: (context) => LectureVideosExoFromProgram(
                        onComplete: () => _markSessionAsCompleted('semaine7_seance4'),
                        path: widget.path, pg : "powerband_pgexpress",
                        exercice: [
                          Exercice(
                            titre: "Soulevé de Terre",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 120,
                            linkVideo: "https://www.youtube.com/watch?v=ZjAMtITHkRA&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=34&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Tirage Horizontal Unilatéral",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 75,
                            linkVideo: "https://www.youtube.com/watch?v=6KVKMIbUH-Y&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=15&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Face Pull au sol",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=g7_9dPjXbI4&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=36&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Biceps Curl Prise Pronation",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=VKZBNQCYebM&list=PL27ZZQGb4Vdx5_B92jJXP0oarRXPp5J_1&index=44&pp=iAQB0gcJCYQJAYcqIYzv",
                          ),
                          Exercice(
                            titre: "Extension Mollet Unilatéral",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 30,
                            linkVideo: "https://www.youtube.com/watch?v=uMMv5GdkLV8&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=4&pp=iAQB",
                          ),
                        ],
                      )));
                    },
                    child: Box(7,"s1.png", 4, "Full Body Pull",true),
                  ),

                  TextComponent(text: "Semaine 8",fontWeight: FontWeight.bold,color: mainColor,size: 14,),
                  InkWell(
                    onTap: () {
                      widget.isFromAccueil? showToast(context, "Cette vidéo est Bloquée", Colors.red): Navigator.push(context, MaterialPageRoute(builder: (context) => LectureVideosExoFromProgram(
                        onComplete: () => _markSessionAsCompleted('semaine8_seance1'),
                        path: widget.path, pg : "powerband_pgexpress",
                        exercice: [
                          Exercice(
                            titre: "Développé Debout à la poulie",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 75,
                            linkVideo: "https://www.youtube.com/watch?v=4uo_CMqRwa0&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=31&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Overhead Press",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 75,
                            linkVideo: "https://www.youtube.com/watch?v=Wr82oq7BDiw&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=20&t=7s&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Ecarté Unilatéral",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=zAfnnw1-3rc&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=37&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Triceps KickBack",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=fm2dGhQLGYY&list=PL27ZZQGb4Vdx5_B92jJXP0oarRXPp5J_1&index=10&pp=iAQB0gcJCYQJAYcqIYzv",
                          ),
                          Exercice(
                            titre: "Fentes",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 60,
                            linkVideo: "https://www.youtube.com/watch?v=bMghA7DYexI&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=25&pp=iAQB",
                          ),
                        ],
                      )));
                    },
                    child: Box(8,"s1.png", 1, "Full Body Push",true),
                  ),
                  InkWell(
                    onTap: () {
                      widget.isFromAccueil? showToast(context, "Cette vidéo est Bloquée", Colors.red): Navigator.push(context, MaterialPageRoute(builder: (context) => LectureVideosExoFromProgram(
                        onComplete: () => _markSessionAsCompleted('semaine8_seance2'),
                        path: widget.path, pg : "powerband_pgexpress",
                        exercice: [
                          Exercice(
                            titre: "Soulevé de Terre",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 120,
                            linkVideo: "https://www.youtube.com/watch?v=ZjAMtITHkRA&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=34&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Rowing Buste Penché",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 75,
                            linkVideo: "https://www.youtube.com/watch?v=L-Ada7ypMpo&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=17&pp=iAQB",
                          ),
                          Exercice(
                            titre: "F-Biceps Curl Poulie Basse",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=lJZqNu8jJEw&list=PL27ZZQGb4Vdx5_B92jJXP0oarRXPp5J_1&index=30&pp=iAQB0gcJCYQJAYcqIYzv",
                          ),
                          Exercice(
                            titre: "Leg Curl",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=YjzWXDSyUsI&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=5&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Extension Mollet Unilatéral",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 30,
                            linkVideo: "https://www.youtube.com/watch?v=uMMv5GdkLV8&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=4&pp=iAQB",
                          ),
                        ],
                      )));
                    },
                    child: Box(8,"s2.png", 2, "Full Body Pull",true),
                  ),
                  InkWell(
                    onTap: () {
                      widget.isFromAccueil? showToast(context, "Cette vidéo est Bloquée", Colors.red): Navigator.push(context, MaterialPageRoute(builder: (context) => LectureVideosExoFromProgram(
                        onComplete: () => _markSessionAsCompleted('semaine8_seance3'),
                        path: widget.path, pg : "powerband_pgexpress",
                        exercice: [
                          Exercice(
                            titre: "Développé Debout à la poulie",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 75,
                            linkVideo: "https://www.youtube.com/watch?v=4uo_CMqRwa0&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=31&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Overhead Press",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 75,
                            linkVideo: "https://www.youtube.com/watch?v=Wr82oq7BDiw&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=20&t=7s&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Triceps Extension Poulie Haute",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=OKr0saA8AXs&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=43&pp=iAQB0gcJCYQJAYcqIYzv",
                          ),
                          Exercice(
                            titre: "Triceps Extension Vertical",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=RbA_omOwd34&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=42&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Squat",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 90,
                            linkVideo: "https://www.youtube.com/watch?v=5bgm8P0Orc4&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=16&pp=iAQB",
                          ),
                        ],
                      )));
                    },
                    child: Box(8,"s3.png", 3, "Full Body Push",true),
                  ),
                  InkWell(
                    onTap: () {
                      widget.isFromAccueil? showToast(context, "Cette vidéo est Bloquée", Colors.red): Navigator.push(context, MaterialPageRoute(builder: (context) => LectureVideosExoFromProgram(
                        onComplete: () => _markSessionAsCompleted('semaine8_seance4'),
                        path: widget.path, pg : "powerband_pgexpress",
                        exercice: [
                          Exercice(
                            titre: "Soulevé de Terre",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 120,
                            linkVideo: "https://www.youtube.com/watch?v=ZjAMtITHkRA&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=34&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Tirage Horizontal Unilatéral",
                           nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 75,
                            linkVideo: "https://www.youtube.com/watch?v=6KVKMIbUH-Y&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=15&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Face Pull au sol",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=g7_9dPjXbI4&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=36&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Biceps Curl Prise Marteau",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 45,
                            linkVideo: "https://www.youtube.com/watch?v=tL0ihj9VtlM&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=23&pp=iAQB",
                          ),
                          Exercice(
                            titre: "Extension Mollet Unilatéral",
                            nombreTotalSerie: 1,
                            seriesConfigs: [
                              SerieConfig(repetitions: 15),
                            ],
                            repos: 30,
                            linkVideo: "https://www.youtube.com/watch?v=uMMv5GdkLV8&list=PL27ZZQGb4VdxOai2h3x24ZeM3Xy5Aovym&index=4&pp=iAQB",
                          ),
                        ],
                      )));
                    },
                    child: Box(8,"s1.png", 4, "Full Body Pull",true),
                  ), 

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget Box(int semaine,String img, int seance, titre, bool isLocked){
    if(!widget.isFromAccueil){
      isLocked = false;
    }
    return Card(
      color: Colors.white,
      child: Container(
        height: 80,
        width: Screen.width(context),
        padding: EdgeInsets.all(10),
        child: Row(
          spacing: 20,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(image: AssetImage("assets/images/$img"),fit: BoxFit.cover)
              ),
            ),
            Expanded(
              child: Column(mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 3,
                children: [
                  TextComponent(text: "Séance $seance",fontWeight: FontWeight.bold,),
                  TextComponent(text: titre,textAlign: TextAlign.start,)
                ],
              ),
            ),
            Icon(_isSessionCompleted('semaine${semaine}_seance$seance') ? Icons.check_circle : isLocked ? Icons.lock : Icons.check_circle_outline, color: mainColor, size: 35),
          ],
        ),
      ),
    );
  }
}
