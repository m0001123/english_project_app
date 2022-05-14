import 'dart:convert';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:alicsnet_app/page/page_theme.dart';
import 'package:alicsnet_app/router/router.gr.dart';
import 'package:alicsnet_app/util/api_util.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter_tts/flutter_tts.dart';

class VocabularyPracticeWordIndexPage extends StatefulWidget {
  const VocabularyPracticeWordIndexPage({Key? key}) : super(key: key);

  @override
  _VocabularyPracticeWordIndexPageState createState() => _VocabularyPracticeWordIndexPageState();
}

enum TtsState { playing, stopped, paused, continued }

class _VocabularyPracticeWordIndexPageState extends State<VocabularyPracticeWordIndexPage> {
  TextEditingController _editingController = TextEditingController();
  List<Widget> listViews = <Widget>[];
  int _sliderMin = 1;
  int _sliderMax = 9991;
  int _sliderIndex = 1;
  String _sliderEducationLevel = '國小';

  Map<String, dynamic> _wordSetData = {
    'wordSetClassification': '',
    'learningClassificationName': '',
    'wordSetTotal': 1,
    'averageScore': 0,
    'wordSetArray': [],
  };
  List<dynamic> _wordData = [];


  // flutter_tts
  late FlutterTts flutterTts;
  String? ttsLanguage;
  String? ttsEngine;
  double ttsVolume = 1;
  double ttsPitch = 1.0;
  double ttsRate = 0.5;
  bool ttsRateSlow = false;
  bool ttsIsCurrentLanguageInstalled = false;
  String? _newVoiceText;
  int? _inputLength;
  TtsState ttsState = TtsState.stopped;
  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;
  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWeb => kIsWeb;


  @override
  void initState() {
    initTts();
    super.initState();
    //initWordSetTotalList();
    initWordList();
    _adjustSliderEducationLevel();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> initWordList() async {
    EasyLoading.show(status: '正在讀取資料，請稍候......');
    try{
      var getWordList;
      List<dynamic> wordData;
      do {
        String getWordListJSON = await APIUtil.getWordList(_sliderIndex.toString(), dataLimit: '10');
        getWordList = jsonDecode(getWordListJSON.toString());
        print('getWordSetTotalList 2 apiStatus:' + getWordList['apiStatus'] + ' apiMessage:' + getWordList['apiMessage']);
        if(getWordList['apiStatus'] != 'success') {
          sleep(Duration(seconds:1));
        }
      } while (getWordList['apiStatus'] != 'success');

      wordData = getWordList['data'];

      print(wordData);

      setState(() {
        _wordData = wordData;
        //_sliderMax = wordSetData['wordSetTotal'];
      });

      if(_wordSetData['wordSetArray'].length == 0){
        //addWordSet();
      }
    } catch(e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('連線發生錯誤，請稍候再重試'),
      ));
    }
    EasyLoading.dismiss();


  }



  initTts() async {
    flutterTts = FlutterTts();

    if (isAndroid) {
      _getDefaultEngine();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        ttsState = TtsState.stopped;
      });
    });

    if (isWeb || isIOS) {
      flutterTts.setPauseHandler(() {
        setState(() {
          print("Paused");
          ttsState = TtsState.paused;
        });
      });

      flutterTts.setContinueHandler(() {
        setState(() {
          print("Continued");
          ttsState = TtsState.continued;
        });
      });
    }

    if (isIOS) {
      await flutterTts
          .setIosAudioCategory(IosTextToSpeechAudioCategory.playback, [
        IosTextToSpeechAudioCategoryOptions.allowBluetooth,
        IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
        IosTextToSpeechAudioCategoryOptions.mixWithOthers,
        IosTextToSpeechAudioCategoryOptions.defaultToSpeaker
      ]);
    }


    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: PageTheme.vocabulary_practice_total_background,
        title: Column(
          children: <Widget>[
            Text(
              '口語句子練習',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                letterSpacing: 3.0,
                color: Color(0xFFFEFEFE),
              ),
            ),
            Text(
              'Sentence Voabulary Practice',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                letterSpacing: 3.0,
                color: Color(0xFFFEFEFE),
              ),
            ),
          ],
        ),


      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onSubmitted: (value) async {
                  //EasyLoading.show(status: '正在讀取資料，請稍候......');
                  try{
                    var getWordRowIndex;
                    List<dynamic> wordData;
                    String getWordRowIndexJSON = await APIUtil.getWordRowIndex(value);
                    getWordRowIndex = jsonDecode(getWordRowIndexJSON.toString());
                    print('getWordSetTotalList 2 apiStatus:' + getWordRowIndex['apiStatus'] + ' apiMessage:' + getWordRowIndex['apiMessage']);

                    if (getWordRowIndex['apiStatus'] == 'success') {
                      if (int.tryParse(getWordRowIndex['data']['index'].toString()) != null) {
                        _adjustSliderIndex(int.tryParse(getWordRowIndex['data']['index'].toString())! - _sliderIndex);
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(getWordRowIndex['apiMessage']),
                      ));
                    }
                  } catch(e) {
                    print('Error: $e');
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('連線發生錯誤，請稍候再重試'),
                    ));
                  }
                  //EasyLoading.dismiss();
                },
                controller: _editingController,
                decoration: const InputDecoration(
                    labelText: "搜尋單詞",
                    hintText: "搜尋單詞",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0))
                    )
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: PageTheme.vocabulary_practice_total_background,
                  borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                ),
                child: Column(
                  children: <Widget>[
                    Slider(
                      autofocus: false,
                      onChanged: (value) {
                        setState(() {
                          _sliderIndex = value.toInt();
                        });
                        _adjustSliderEducationLevel();
                      },
                      onChangeEnd: (value) {
                        setState(() {
                          _sliderIndex = value.toInt();
                        });
                        initWordList();
                        _adjustSliderEducationLevel();
                      },
                      min: _sliderMin.toDouble(),
                      max: _sliderMax.toDouble(),
                      activeColor: PageTheme.vocabulary_practice_total_green_1,
                      inactiveColor: Colors.white,
                      divisions: (_sliderMax - _sliderMin),
                      //value: _applicationSettingsDataTtsRate,
                      value: _sliderIndex.toDouble(),
                      //label: 'Ranking ${_sliderIndex * 10 - 9} ~ ${_sliderIndex * 10}',
                      label: 'Index ${_sliderIndex} ~ ${_sliderIndex + 9}',
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                              flex: 5,
                              child: AutoSizeText(
                                '${_sliderEducationLevel}\n(${_sliderIndex} ~ ${_sliderIndex + 9})',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                                maxLines: 2,
                              )
                          ),
                          Expanded(
                              flex: 3,
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(4),
                                    child: Center(
                                      child: CircleAvatar(
                                        backgroundColor: PageTheme.vocabulary_practice_total_green_1,
                                        radius: 20.0,
                                        child: IconButton(
                                          icon: Icon(Icons.remove),
                                          color: Colors.white,
                                          onPressed: () async {
                                            _adjustSliderIndex(-1);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(4),
                                    child: Center(
                                      child: CircleAvatar(
                                        backgroundColor: PageTheme.vocabulary_practice_total_green_1,
                                        radius: 20.0,
                                        child: IconButton(
                                          icon: Icon(Icons.add),
                                          color: Colors.white,
                                          onPressed: () async {
                                            _adjustSliderIndex(1);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                          ),
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: TextEditingController(text: _sliderIndex.toString()),
                              onSubmitted: (value) {
                                if (int.tryParse(value) != null) {
                                  _adjustSliderIndex(int.tryParse(value)! - _sliderIndex);
                                }
                              },
                              decoration: const InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(25.0))
                                  )
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),



                  ],
                ),
              ),


            ),
            Container(
              padding: const EdgeInsets.all(0),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: _wordData.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: <Widget>[

                        Row(
                          children: <Widget>[
                            Expanded(
                                flex: 1,
                                child: IconButton(
                                  icon: Icon(Icons.volume_up),
                                  color: Colors.black,
                                  onPressed: () async {
                                    //_adjustSliderIndex(-1);
                                    print(_wordData[index]['word']);
                                    ttsRateSlow = !ttsRateSlow;
                                    await _ttsSpeak(_wordData[index]['word'], 'en-US');
                                  },
                                )
                            ),
                            Expanded(
                                flex: 3,
                                child: Column(
                                  children: <Widget>[
                                    AutoSizeText(
                                      _wordData[index]['word'],
                                      style: const TextStyle(
                                        fontSize: 24,
                                      ),
                                      maxLines: 1,
                                    ),
                                    AutoSizeText(
                                      '[${_wordData[index]['wordIPA']}]',
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ],
                                )
                            ),
                            Expanded(
                              flex: 2,
                              child: OutlinedButton(
                                style: ButtonStyle(
                                    side: MaterialStateProperty.all(
                                        BorderSide(

                                            color: PageTheme.vocabulary_practice_total_green_1,
                                            width: 1.0,
                                            style: BorderStyle.solid)
                                    ),
                                    foregroundColor: MaterialStateProperty.all(PageTheme.vocabulary_practice_total_green_1,),
                                    textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 18))
                                ),
                                child: const Text('手動'),
                                onPressed: () {
                                  AutoRouter.of(context).push(VocabularyPracticeWordLearnManualRoute(word:_wordData[index]['word']));
                                },
                              ),
                            ),



                          ],
                        ),
                        const Divider(
                          thickness: 2,
                          color: Colors.black,
                        ),
                        /*
                        AutoSizeText(
                          'Index(${_wordData[index]['index']}); Ranking(${_wordData[index]['wordRanking']}); ${_wordData[index]['classificationName']}(${_wordData[index]['orderNo']}); ${_wordData[index]['wordLevel']}',
                          maxLines: 1,
                        ),
                        */

                        ListView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemCount: _wordData[index]['wordMeaningList'].length,
                            itemBuilder: (context, index2) {
                              return Center(
                                  child: AutoSizeText(
                                    '[${_wordData[index]['wordMeaningList'][index2]['pos']}] ${_wordData[index]['wordMeaningList'][index2]['meaning']}',
                                    maxLines: 1,
                                  )
                              );
                            }
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index){
                  return const Divider(
                    thickness: 2,
                    color: PageTheme.vocabulary_practice_total_green_1,
                  );
                },
              ),
            ),




          ],
        ),
      ),
    );
  }


  /* tts 相關 */
  Future<dynamic> _getLanguages() => flutterTts.getLanguages;

  Future<dynamic> _getEngines() => flutterTts.getEngines;

  Future _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      print(engine);
    }
  }
  Future _ttsSpeak(String speakMessage, String speakLanguage) async {

    await flutterTts.setLanguage(speakLanguage);
    if(ttsRateSlow){
      await flutterTts.setSpeechRate(ttsRate * 0.22);
    } else {
      await flutterTts.setSpeechRate(ttsRate);
    }
    await flutterTts.setVolume(ttsVolume);
    await flutterTts.setPitch(ttsPitch);

    if (speakMessage.isNotEmpty) {
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.speak(speakMessage);
    }
  }

  Future _ttsStop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  Future _ttsPause() async {
    var result = await flutterTts.pause();
    if (result == 1) setState(() => ttsState = TtsState.paused);
  }



  /*
  other
   */

  void _adjustSliderIndex(int value) {

    int sliderIndex = _sliderIndex + value;

    if( (sliderIndex >= _sliderMin) && (sliderIndex <= _sliderMax) ){
      setState(() => _sliderIndex = sliderIndex);
      initWordList();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Opps: 已超出範圍'),
      ));
    }

  }

  void _adjustSliderEducationLevel() {

    String sliderEducationLevel = '國小';
    if (_sliderIndex > 6000) {
      sliderEducationLevel = '大學';
    } else if (_sliderIndex > 2000) {
      sliderEducationLevel = '高中';
    } else if (_sliderIndex > 900) {
      sliderEducationLevel = '國中';
    }
    setState(() => _sliderEducationLevel = sliderEducationLevel);
  }

}