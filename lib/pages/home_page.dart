import 'package:alan_voice/alan_voice.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/model/radio.dart';
import 'package:flame/pages/login.dart';
import 'package:flame/utils/ai_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<MyRadio>? radios;
  MyRadio? _selectedRadio;
  MyRadio? _runningRadio;
  Color? _selectedColor;
  bool _isPlaying = false;
  final sugg = [
    "Play",
    "🔥"
  ];

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState()  {
    setupAlan();
    fetchRadios();
    _audioPlayer.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.PLAYING) {
        _isPlaying = true;
      } else {
        _isPlaying = false;
      }
      setState(() {});
    });
    super.initState();
  }


   signOut() async {
    _auth.signOut();
    AlanVoice.hideButton();
    AlanVoice.removeButton();
    _audioPlayer.stop();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()));
  }
  setupAlan() {
    AlanVoice.addButton("71c45709290622d6a05baac4ef3486e32e956eca572e1d8b807a3e2338fdd0dc/stage",
        buttonAlign: AlanVoice.BUTTON_ALIGN_RIGHT);
    AlanVoice.callbacks.add((command) => _handleCommand(command.data));
  }

  _handleCommand(Map<String, dynamic> response) {
    switch (response["command"]) {
      case "play":
        _playMusic(_selectedRadio!.url);
        break;

      case "play_channel":
        final id = response["id"];
        // _audioPlayer.pause();
        MyRadio newRadio = radios!.firstWhere((element) => element.id == id);
        radios!.remove(newRadio);
        radios!.insert(0, newRadio);
        _playMusic(newRadio.url);
        break;

      case "stop":
        _audioPlayer.stop();
        break;
      case "next":
        int index = _selectedRadio!.id;
        MyRadio newRadio;
        if (index + 1 > radios!.length) {
          newRadio = radios!.firstWhere((element) => element.id == 1);
          radios!.remove(newRadio);
          radios!.insert(0, newRadio);
        } else { 
          final newindex= index+1;
          newRadio = radios!.firstWhere((element) => element.id == newindex);
          radios!.remove(newRadio);
          radios!.insert(0, newRadio);
        }
        _playMusic(newRadio.url);
        break;

      case "prev":
        int index = _selectedRadio!.id;
        MyRadio newRadio;
        if (index - 1 <= 0) {
          newRadio = radios!.firstWhere((element) => element.id == 1);
          radios!.remove(newRadio);
          radios!.insert(0, newRadio);
        } else {
          final newindex = index-1;
          newRadio = radios!.firstWhere((element) => element.id == newindex);
          radios!.remove(newRadio);
          radios!.insert(0, newRadio);
        }
        _playMusic(newRadio.url);
        break;
      default:
        break;
    }
  }

  fetchRadios() async {
    final radioJson = await rootBundle.loadString("assets/radio.json");
    radios = MyRadioList.fromJson(radioJson).radios;
    _selectedRadio = radios![0];
    _runningRadio = _selectedRadio;
    int number = int.parse(_selectedRadio!.color);
    _selectedColor =  Color(number);
    setState(() {});
  }

  _playMusic(String url) {
    _audioPlayer.play(url);
    _selectedRadio = radios!.firstWhere((element) => element.url == url);
    int number = int.parse(_selectedRadio!.color);
    _selectedColor = Color(number);
    _runningRadio = _selectedRadio;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: _selectedColor,
          child: radios != null
              ? [
                  100.heightBox,
                  "All Channels".text.xl.white.semiBold.make().px16(),
                  20.heightBox,
                  ListView(
                    padding: Vx.m0,
                    shrinkWrap: true,
                    children: radios
                        !.map((e) => ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(e.icon),
                              ),
                              title: "${e.name} FM".text.white.make(),
                              subtitle: e.tagline.text.white.make(),
                            ))
                        .toList(),
                  ).expand()
                ].vStack(crossAlignment: CrossAxisAlignment.start)
              : const Offstage(),
        ),
      ),
      body: Stack(
        children: [
          VxAnimatedBox()
              .size(context.screenWidth, context.screenHeight)
              .withGradient(
                LinearGradient(
                  colors: [
                    AIColors.primaryColor2,
                    _selectedColor ??  AIColors.primaryColor1
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              )
              .make(),
          [
            AppBar(
              title: "   FLAME 🔥".text.xl5.bold.white.italic.make().shimmer(
                  primaryColor: Vx.red400, 
                  secondaryColor: Colors.orange.shade400),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              centerTitle: true,
              actions:  [
                IconButton(onPressed: (){signOut();}, icon: const Icon(Icons.logout_outlined,size: 30,color: Colors.white,))
                
                ],
             
            ).h(100.0).p12(),
            "AI base Radio Player".text.xl2.italic.semiBold.white.make(),
            10.heightBox,
            // VxSwiper.builder(
            //   itemCount: sugg.length,
            //   height: 50.0,
            //   viewportFraction: 0.35,
            //   autoPlay: true,
            //   autoPlayAnimationDuration: 3.seconds,
            //   autoPlayCurve: Curves.linear,
            //   enableInfiniteScroll: true,
            //   itemBuilder: (context, index) {
            //     final s = sugg[index];
            //     return Chip(
            //       label: s.text.make(),
            //       backgroundColor: Vx.randomColor,
            //     );
            //   },
            // )
          ].vStack(alignment: MainAxisAlignment.start),
          30.heightBox,
          radios != null
              ? VxSwiper.builder(
                  itemCount: radios!.length,
                  aspectRatio: context.mdWindowSize == VxWindowSize.xsmall
                      ? 1.0
                      : context.mdWindowSize == VxWindowSize.medium
                          ? 2.0
                          : 3.0,
                  enlargeCenterPage: true,
                  onPageChanged: (index) {
                    _selectedRadio = radios![index];
                    final colorHex = int.parse(radios![index].color) ;
                    _selectedColor = Color(colorHex);
                    setState(() {});
                  },
                  itemBuilder: (context, index) {
                    final rad = radios![index];

                    return VxBox(
                            child: ZStack(
                      [
                        Positioned(
                          top: 0.0,
                          right: 0.0,
                          child: VxBox(
                            child:
                                rad.category.text.uppercase.white.make().px16(),
                          )
                              .height(40)
                              .black
                              .alignCenter
                              .withRounded(value: 10.0)
                              .make(),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: VStack(
                            [
                              rad.name.text.xl3.white.bold.make(),
                              5.heightBox,
                              rad.tagline.text.sm.white.semiBold.make(),
                            ],
                            crossAlignment: CrossAxisAlignment.center,
                          ),
                        ),
                        Align(
                            alignment: Alignment.center,
                            child: [
                              const Icon(
                                CupertinoIcons.play_circle,
                                color: Colors.white,
                              ),
                              10.heightBox,
                              "Double tap to play".text.gray300.make(),
                            ].vStack())
                      ],
                    ))
                        .clip(Clip.antiAlias)
                        .bgImage(
                          DecorationImage(
                              image: NetworkImage(rad.image),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.3),
                                  BlendMode.darken)),
                        )
                        .border(color: Colors.black, width: 5.0)
                        .withRounded(value: 60.0)
                        .make()
                        .onInkDoubleTap(() {
                      _playMusic(rad.url);
                    }).p16();
                  },
                ).centered()
              : const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                ),
          Align(
            alignment: Alignment.bottomCenter,
            child: [
              if (_isPlaying)
                "Playing Now - ${_runningRadio!.name} FM"
                    .text
                    .white
                    .makeCentered().px32(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                 Icons.skip_previous,
                color: Colors.white,
                size: 50.0,
                ).onInkTap(() {
                int index = _selectedRadio!.id;
                MyRadio newRadio;
                if (index - 1 <= 0) {
                  newRadio = radios!.firstWhere((element) => element.id == 1);
                  radios!.remove(newRadio);
                  radios!.insert(0, newRadio);
                } else {
                  final newindex = index-1;
                  newRadio = radios!.firstWhere((element) => element.id == newindex);
                  radios!.remove(newRadio);
                  radios!.insert(0, newRadio);
                }
                _playMusic(newRadio.url);
              }),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Icon(
                  _isPlaying
                      ? CupertinoIcons.stop_circle
                      : CupertinoIcons.play_circle,
                  color: Colors.white,
                  size: 80.0,
                ).onInkTap(() {
                  if (_isPlaying) {
                    _audioPlayer.stop();
                  } else {
                    _runningRadio = _selectedRadio;
                    _playMusic(_selectedRadio!.url);
                  }
                  
                }).shimmer(primaryColor: Vx.red400, 
                  secondaryColor: Colors.orange.shade400),
              ),
              const Icon(
                Icons.skip_next,
                color: Colors.white,
                size: 50.0,
              ).onInkTap(() {
                int index = _selectedRadio!.id;
                MyRadio newRadio;
                if (index + 1 > radios!.length) {
                  newRadio = radios!.firstWhere((element) => element.id == 1);
                  radios!.remove(newRadio);
                  radios!.insert(0, newRadio);
                } else {
                  final newindex = index+1;
                  newRadio = radios!.firstWhere((element) => element.id == newindex);
                  radios!.remove(newRadio);
                  radios!.insert(0, newRadio);
                }
                _playMusic(newRadio.url);
                
              })
                ],
              )
            ].vStack(),
          ).pOnly(bottom: context.percentHeight * 12)
        ],
        fit: StackFit.expand,
        clipBehavior: Clip.antiAlias,
      ),
    );
  }
}