
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:io' show Platform;
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:sels_app/sels_app/utils/ChatMessageUtil.dart';
import 'package:sels_app/sels_app/utils/SharedPreferencesUtil.dart';
import 'package:sels_app/sels_app/utils/APIUtil.dart';


class PhoneticExercisesLearnAutoPage extends StatefulWidget {

  String topicClass = '';
  String topicName = '';
  List<int> sentencesIDData = const [];
  int quizID = 0;

  PhoneticExercisesLearnAutoPage({String topicClass:'', String topicName:'', List<int> sentencesIDData:const [], int quizID:0}) {
    this.topicClass = topicClass;
    this.topicName = topicName;
    this.sentencesIDData = sentencesIDData;
    this.quizID = quizID;
  }

  @override
  _PhoneticExercisesLearnAutoPage createState() => new _PhoneticExercisesLearnAutoPage(topicClass:topicClass, topicName:topicName, sentencesIDData:sentencesIDData, quizID:quizID);
}

enum TtsState { playing, stopped, paused, continued }

class _PhoneticExercisesLearnAutoPage extends State<PhoneticExercisesLearnAutoPage> {

  /* 測驗時長計時器 */
  late Timer _timer;
  late int _answerSeconds;
  bool _isActive = false;

  late double _progress;
  List<int> _sentencesIDData = [];
  List _questionsData = [];
  int _totalTestQuestions = 25;
  int _quizID = 0;
  String _applicationSettingsDataUUID = '';
  String _applicationSettingsDataListenAndSpeakLevel = '';
  double _applicationSettingsDataListenAndSpeakRanking = 0;
  String _topicClass = '';
  String _topicName = '';
  int _part = 0;
  String _questionText = '';
  _PhoneticExercisesLearnAutoPage({String topicClass:'', String topicName:'', List<int> sentencesIDData:const [],  quizID:0}) {
    this._topicClass = topicClass;
    this._topicName = topicName;
    this._sentencesIDData = sentencesIDData;
    this._quizID = quizID;
  }
  var _allowTouchButtons = {
    'reListenButton' : false,
    'speakButton' : false,
    'pauseButton' : true,
  };
  int _correctCombo = 0;
  Map _finishQuizData = {
    'sentenceIDArray' : <int>[],
    'sentenceAnswerArray' : <String>[],
    'scoreArray' : <int>[],
    'secondsArrayQ' : <int>[],
    'secondsArray' : <int>[],
  };


  final List<ChatMessageUtil> _messages = <ChatMessageUtil>[];

  


  // Speech_to_text
  bool _sttHasSpeech = false;
  double sttLevel = 0.0;
  double sttMinSoundLevel = 50000;
  double sttMaxSoundLevel = -50000;
  String sttLastWords = '';
  String sttLastError = '';
  String sttLastStatus = '';
  String _sttCurrentLocaleId = 'en_US';
  int sttResultListened = 0;
  List<LocaleName> _sttLocaleNames = [];
  final SpeechToText speechToText = SpeechToText();

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
    super.initState();
    initPhoneticExercisesLearnAutoPage();
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
    speechToText.stop();
    EasyLoading.dismiss();
    //_timer?.cancel();
    _timer.cancel();
  }

  /*
  initState() 初始化相關
   */

  initPhoneticExercisesLearnAutoPage() async {
    await initApplicationSettingsData();
    await initAnswerTimer();
    await initTts();
    await initSpeechState();
    await initTestQuestions();
    await initChatBot();
  }

  initApplicationSettingsData() {

    SharedPreferencesUtil.getData<double>('applicationSettingsDataTtsVolume').then((value) {
      setState(() => ttsVolume = value!);
    });
    SharedPreferencesUtil.getData<double>('applicationSettingsDataTtsPitch').then((value) {
      setState(() => ttsPitch = value!);
    });
    SharedPreferencesUtil.getData<double>('applicationSettingsDataTtsRate').then((value) {
      setState(() => ttsRate = value!);
    });
    SharedPreferencesUtil.getData<String>('applicationSettingsDataUUID').then((value) {
      setState(() => _applicationSettingsDataUUID = value!);
    });
    SharedPreferencesUtil.getData<String>('applicationSettingsDataListenAndSpeakLevel').then((value) {
      setState(() => _applicationSettingsDataListenAndSpeakLevel = value!);
    });
    SharedPreferencesUtil.getData<double>('applicationSettingsDataListenAndSpeakRanking').then((value) {
      setState(() => _applicationSettingsDataListenAndSpeakRanking = value!);
    });
  }

  Future<void> initSpeechState() async {
    var sttHasSpeech = await speechToText.initialize(
        onError: sttErrorListener,
        onStatus: sttStatusListener,
        debugLogging: true,
        finalTimeout: Duration(milliseconds: 0));
    if (sttHasSpeech) {
      _sttLocaleNames = await speechToText.locales();

      var systemLocale = await speechToText.systemLocale();
      //_sttCurrentLocaleId = systemLocale?.localeId ?? '';
    }

    if (!mounted) return;

    setState(() {
      _sttHasSpeech = sttHasSpeech;
    });
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

      if (Platform.isIOS) {
        await flutterTts
            .setIosAudioCategory(IosTextToSpeechAudioCategory.playback, [
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
          IosTextToSpeechAudioCategoryOptions.mixWithOthers,
          IosTextToSpeechAudioCategoryOptions.defaultToSpeaker
        ]);
      }

      flutterTts.setContinueHandler(() {
        setState(() {
          print("Continued");
          ttsState = TtsState.continued;
        });
      });
    }

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }


  Future<void> initChatBot() async {
    await sendChatMessage(false, 'Bot', [TextSpan(text: '測驗即將開始')], needSpeak:true, speakMessage:'Quiz is about to start', speakLanguage:'en-US');
    await sendChatMessage(false, 'Bot', [TextSpan(text: '請跟著我重複一次')], needSpeak:true, speakMessage:'Please repeat after me', speakLanguage:'en-US');
    await sendNextQuestion();
  }

  Future<void> initTestQuestions() async {

    List questionsData = [];
    _progress = 0;
    EasyLoading.show(status: '正在讀取資料，請稍候......');

    if(_quizID != 0){

      var getQuizDataByID;
      do {
        String getQuizDataByIDJSON = await APIUtil.getQuizDataByID(_quizID, _applicationSettingsDataUUID);
        getQuizDataByID = jsonDecode(getQuizDataByIDJSON.toString());
        print('getQuizDataByID 1 apiStatus:' + getQuizDataByID['apiStatus'] + ' apiMessage:' + getQuizDataByID['apiMessage']);
        if(getQuizDataByID['apiStatus'] != 'success') {
          await Future.delayed(Duration(seconds: 1));
        }
      } while (getQuizDataByID['apiStatus'] != 'success');
      questionsData.addAll(getQuizDataByID['data']);

      EasyLoading.dismiss();
      print('questionsData');
      print(questionsData);
      _questionsData = questionsData;
      _totalTestQuestions = questionsData.length;
      return;

    }

    if(_sentencesIDData.length != 0){
      var getSentencesByID;
      for(final sentencesID in _sentencesIDData){
        EasyLoading.showProgress(_progress, status: '正在讀取資料，請稍候......(${(_progress * 100).toStringAsFixed(0)}%)');
        _progress += ((100/_sentencesIDData.length)/100);
        do {
          String getSentencesByIDJSON = await APIUtil.getSentencesByID(sentencesID);
          getSentencesByID = jsonDecode(getSentencesByIDJSON.toString());
          print('getSentences 6 apiStatus:' + getSentencesByID['apiStatus'] + ' apiMessage:' + getSentencesByID['apiMessage']);
          await Future.delayed(Duration(seconds: 1));
        } while (getSentencesByID['apiStatus'] != 'success');
        questionsData.addAll(getSentencesByID['data']);
      }
    } else {
      var getSentences;

      // 測試用
      /*
      do {
        String getSentencesJSON = await APIUtil.getSentences(_applicationSettingsDataListenAndSpeakLevel, sentenceMaxLength:'3', dataLimit:'2', sentenceTopic :_topicName, sentenceClass:_topicClass, sentenceRanking:_applicationSettingsDataListenAndSpeakRanking.round().toString());
        getSentences = jsonDecode(getSentencesJSON.toString());
        print('getSentences 1 apiStatus:' + getSentences['apiStatus'] + ' apiMessage:' + getSentences['apiMessage']);
        if(getSentences['apiStatus'] != 'success') {
          await Future.delayed(Duration(seconds: 1));
        }
      } while (getSentences['apiStatus'] != 'success');
      questionsData.addAll(getSentences['data']);

      EasyLoading.dismiss();
      print('questionsData');
      print(questionsData);

      _questionsData = questionsData;
      _totalTestQuestions = questionsData.length;
      return;

       */

      // 獲取1~3單字數的句子7句
      do {
        String getSentencesJSON = await APIUtil.getSentences(sentenceLevel:_applicationSettingsDataListenAndSpeakLevel, sentenceMinLength:'1', sentenceMaxLength:'3', dataLimit:'7', sentenceTopic :_topicName, sentenceClass:_topicClass, sentenceRanking:_applicationSettingsDataListenAndSpeakRanking.round().toString());
        getSentences = jsonDecode(getSentencesJSON.toString());
        print('getSentences 1 apiStatus:' + getSentences['apiStatus'] + ' apiMessage:' + getSentences['apiMessage']);
        if(getSentences['apiStatus'] != 'success') {
          await Future.delayed(Duration(seconds: 1));
        }
      } while (getSentences['apiStatus'] != 'success');
      questionsData.addAll(getSentences['data']);
      // 獲取4~5單字數的句子6句
      do {
        String getSentencesJSON = await APIUtil.getSentences(sentenceLevel:_applicationSettingsDataListenAndSpeakLevel, sentenceMinLength:'4', sentenceMaxLength:'5', dataLimit:'6', sentenceTopic :_topicName, sentenceClass:_topicClass, sentenceRanking:_applicationSettingsDataListenAndSpeakRanking.round().toString());
        getSentences = jsonDecode(getSentencesJSON.toString());
        print('getSentences 2 apiStatus:' + getSentences['apiStatus'] + ' apiMessage:' + getSentences['apiMessage']);
        if(getSentences['apiStatus'] != 'success') {
          await Future.delayed(Duration(seconds: 1));
        }
      } while (getSentences['apiStatus'] != 'success');
      questionsData.addAll(getSentences['data']);
      // 獲取6~8單字數的句子5句
      do {
        String getSentencesJSON = await APIUtil.getSentences(sentenceLevel:_applicationSettingsDataListenAndSpeakLevel, sentenceMinLength:'6', sentenceMaxLength:'8', dataLimit:'5', sentenceTopic :_topicName, sentenceClass:_topicClass, sentenceRanking:_applicationSettingsDataListenAndSpeakRanking.round().toString());
        getSentences = jsonDecode(getSentencesJSON.toString());
        print('getSentences 3 apiStatus:' + getSentences['apiStatus'] + ' apiMessage:' + getSentences['apiMessage']);
        if(getSentences['apiStatus'] != 'success') {
          await Future.delayed(Duration(seconds: 1));
        }
      } while (getSentences['apiStatus'] != 'success');
      questionsData.addAll(getSentences['data']);
      // 獲取9~10單字數的句子4句
      do {
        String getSentencesJSON = await APIUtil.getSentences(sentenceLevel:_applicationSettingsDataListenAndSpeakLevel, sentenceMinLength:'9', sentenceMaxLength:'10', dataLimit:'4', sentenceTopic :_topicName, sentenceClass:_topicClass, sentenceRanking:_applicationSettingsDataListenAndSpeakRanking.round().toString());
        getSentences = jsonDecode(getSentencesJSON.toString());
        print('getSentences 4 apiStatus:' + getSentences['apiStatus'] + ' apiMessage:' + getSentences['apiMessage']);
        if(getSentences['apiStatus'] != 'success') {
          await Future.delayed(Duration(seconds: 1));
        }
      } while (getSentences['apiStatus'] != 'success');
      questionsData.addAll(getSentences['data']);
      // 獲取11~12單字數的句子3句
      do {
        String getSentencesJSON = await APIUtil.getSentences(sentenceLevel:_applicationSettingsDataListenAndSpeakLevel, sentenceMinLength:'11', sentenceMaxLength:'12', dataLimit:'3', sentenceTopic :_topicName, sentenceClass:_topicClass, sentenceRanking:_applicationSettingsDataListenAndSpeakRanking.round().toString());
        getSentences = jsonDecode(getSentencesJSON.toString());
        print('getSentences 5 apiStatus:' + getSentences['apiStatus'] + ' apiMessage:' + getSentences['apiMessage']);
        if(getSentences['apiStatus'] != 'success') {
          await Future.delayed(Duration(seconds: 1));
        }
      } while (getSentences['apiStatus'] != 'success');
      questionsData.addAll(getSentences['data']);

      // 檢查是否共_totalTestQuestions句，若否則隨機補足
      while(questionsData.length < _totalTestQuestions) {
        do {
          String getSentencesJSON = await APIUtil.getSentences(sentenceLevel:_applicationSettingsDataListenAndSpeakLevel, dataLimit:'1', sentenceTopic :_topicName, sentenceClass:_topicClass);
          getSentences = jsonDecode(getSentencesJSON.toString());
          print('getSentences 6 apiStatus:' + getSentences['apiStatus'] + ' apiMessage:' + getSentences['apiMessage']);
          if(getSentences['apiStatus'] != 'success') {
            await Future.delayed(Duration(seconds: 1));
          }
        } while (getSentences['apiStatus'] != 'success');
        questionsData.addAll(getSentences['data']);
      }
    }
    EasyLoading.dismiss();
    print('questionsData');
    print(questionsData);

    _questionsData = questionsData;
    _totalTestQuestions = questionsData.length;
    return;


  }
/*
  Future<String> createTestQuestions() async {
    final response = await http.post(
      Uri.https('sels.nfs.tw', 'API_TEST/v2/chatBot/getTestSentence/'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        'sentenceLevel': _sentenceLevel,
        'topicID': _topicID,
        'topicName': _topicName,
        'topicClass': _topicClass
      },
    );
    String json = response.body.toString();
    return json;
  }

 */

  Future<void> initAnswerTimer() async {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      handleTick();
    });
    if (Platform.isIOS) {
      _answerSeconds = -3;
    } else {
      _answerSeconds = 0;
    }
  }





  /*
  UI 介面
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: (_quizID != 0)? Text('記錄檔') : Text('(自)[${_applicationSettingsDataListenAndSpeakLevel}/${_applicationSettingsDataListenAndSpeakRanking.round().toString()}] (${_topicClass}:${_topicName})' ),
      ),
      body:

      Stack(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(color: Colors.grey, offset: Offset(1.1, 1.1), blurRadius: 10.0),
                    ],
                  ),
                  child: Container(
                      child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8, top: 8),
                              child: Divider(
                                height: 1,
                                thickness: 1,
                              ),
                            ),
                            Flexible(
                                child: ListView.builder(
                                  padding: new EdgeInsets.all(8.0),
                                  reverse: true,
                                  itemBuilder: (_, int index) => _messages[index],
                                  itemCount: _messages.length,
                                )
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8, top: 8),
                              child: Divider(
                                height: 1,
                                thickness: 1,
                              ),
                            ),

                            Container(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                      child: Column(
                                        children: [
                                          Center(
                                            child: AvatarGlow(
                                              animate: isPlaying,
                                              glowColor: Theme.of(context).primaryColor,
                                              endRadius: 30.0,
                                              duration: Duration(milliseconds: 2000),
                                              repeat: true,
                                              showTwoGlows: true,
                                              repeatPauseDuration: Duration(milliseconds: 100),
                                              child: Material(     // Replace this child with your own
                                                elevation: 8.0,
                                                shape: CircleBorder(),
                                                child: CircleAvatar(
                                                  backgroundColor: Theme.of(context).primaryColor,
                                                  radius: 20.0,
                                                  child: IconButton(
                                                    icon: Icon( (_allowTouchButtons['reListenButton']! && !speechToText.isListening ) ? (isPlaying ? Icons.volume_up : Icons.volume_up_outlined) : Icons.volume_off_outlined ),
                                                    color: (_allowTouchButtons['reListenButton']! && !speechToText.isListening ) ? Colors.white : Colors.grey ,
                                                    onPressed: () async {
                                                      if(_allowTouchButtons['reListenButton']! && !speechToText.isListening ){
                                                        ttsRateSlow = !ttsRateSlow;
                                                        await _ttsSpeak(_questionText, 'en-US');
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '再聽一次',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      )
                                  ),
                                  Expanded(
                                      child: Column(
                                        children: [
                                          Center(
                                            child: AvatarGlow(
                                              animate: speechToText.isListening,
                                              glowColor: Theme.of(context).primaryColor,
                                              endRadius: 30.0,
                                              duration: Duration(milliseconds: 2000),
                                              repeat: true,
                                              showTwoGlows: true,
                                              repeatPauseDuration: Duration(milliseconds: 100),
                                              child: Material(     // Replace this child with your own
                                                elevation: 8.0,
                                                shape: CircleBorder(),
                                                child: CircleAvatar(
                                                  backgroundColor: Theme.of(context).primaryColor,
                                                  radius: 20.0,
                                                  child: IconButton(
                                                    icon: Icon( (_allowTouchButtons['speakButton']! && !isPlaying ) ? (speechToText.isListening ? Icons.mic : Icons.mic_none) : Icons.mic_off_outlined ),
                                                    color: (_allowTouchButtons['speakButton']! && !isPlaying ) ? Colors.white : Colors.grey ,
                                                    onPressed: () async {
                                                      if(_allowTouchButtons['speakButton']! && !isPlaying ){
                                                        if( !_sttHasSpeech || speechToText.isListening ){
                                                          sttStopListening();
                                                        } else {
                                                          sttCancelListening();
                                                          await Future.delayed(Duration(milliseconds: 800));
                                                          sttStartListening();
                                                        }
                                                      }},
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            (speechToText.isListening)? '暫停回答' : '回答' ,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      )
                                  ),
                                  /*
                                  Expanded(
                                      child: Column(
                                        children: [
                                          Center(
                                            child: AvatarGlow(
                                              animate: false,
                                              glowColor: Theme.of(context).primaryColor,
                                              endRadius: 30.0,
                                              duration: Duration(milliseconds: 2000),
                                              repeat: true,
                                              showTwoGlows: true,
                                              repeatPauseDuration: Duration(milliseconds: 100),
                                              child: Material(     // Replace this child with your own
                                                elevation: 8.0,
                                                shape: CircleBorder(),
                                                child: CircleAvatar(
                                                  backgroundColor: Theme.of(context).primaryColor,
                                                  radius: 20.0,
                                                  child: IconButton(
                                                    icon: const Icon(Icons.pause),
                                                    color: Colors.white,
                                                    onPressed: () {
                                                      if(_allowTouchButtons['pauseButton']!){
                                                        _ttsStop();
                                                        sttStopListening();
                                                        //getTestQuestions();
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '暫停',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      )
                                  ),

                                   */
                                ],
                              ),
                            ),


                          ]
                      )
                  )
              )
          )
        ]
      )


      /*
      Column(
          children: <Widget>[
            Flexible(
                child: ListView.builder(
                  padding: new EdgeInsets.all(8.0),
                  reverse: true,
                  itemBuilder: (_, int index) => _messages[index],
                  itemCount: _messages.length,
                )
            ),
            Divider(
              thickness: 5,
              indent: 20,
              endIndent: 20,
            ),
            Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Column(
                          children: [
                            Center(
                              child: Ink(
                                decoration: const ShapeDecoration(
                                  color: Colors.red,
                                  shape: CircleBorder(),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.replay),
                                  color: Colors.white,
                                  onPressed: () { print('reply Button'); },
                                ),
                              ),
                            ),
                            //Text('Replay')
                          ],
                        )
                    ),
                    Expanded(
                        child: Column(
                          children: [
                            Center(
                                child: AvatarGlow(
                                  animate: speechToText.isListening,
                                  glowColor: Theme.of(context).primaryColor,
                                  endRadius: 50.0,
                                  duration: const Duration(milliseconds: 2000),
                                  repeatPauseDuration: const Duration(milliseconds: 100),
                                  repeat: true,
                                  child: Ink(
                                    decoration: const ShapeDecoration(
                                      color: Colors.red,
                                      shape: CircleBorder(),
                                    ),
                                    child: IconButton(
                                      icon: Icon(speechToText.isListening ? Icons.mic : Icons.mic_none),
                                      color: Colors.white,
                                      onPressed: (){
                                        if(_allowTouchButton){
                                          if( !_sttHasSpeech || speechToText.isListening ){
                                            sttStopListening();
                                          } else {
                                            sttStartListening();
                                          }
                                        }

                                      },
                                    ),
                                  ),
                                )
                            ),
                            //Text('Speak')
                          ],
                        )
                    )
                  ],
                )
            ),
          ]
      ),

       */
    );
  }

  /*
  speech_to_text
   */
  Future<void> sttStartListening() async {
    sttLastWords = '';
    sttLastError = '';
    speechToText.listen(
        onResult: sttResultListener,
        listenFor: Duration(seconds: 30),
        pauseFor: Duration(seconds: 3),
        partialResults: false,
        localeId: _sttCurrentLocaleId,
        onSoundLevelChange: sttSoundLevelListener,
        cancelOnError: true,
        listenMode: ListenMode.confirmation);
    setState(() {});
  }

  Future<void> sttStopListening() async {
    speechToText.stop();
    setState(() {
      sttLevel = 0.0;
    });
  }

  Future<void> sttCancelListening() async {
    await speechToText.cancel();
    setState(() {
      sttLevel = 0.0;
    });
    //await Future.delayed(Duration(seconds: 1));
    //await sttStopListening();
    //await sttStartListening();
  }

  void sttResultListener(SpeechRecognitionResult result) {
    ++sttResultListened;
    print('Result listener $sttResultListened');
    setState(() {
      sttLastWords = '${result.recognizedWords} - ${result.finalResult}';
      if(result.finalResult){
        _handleSubmitted(result.recognizedWords);
      }
      print(sttLastWords);
    });
  }

  void sttSoundLevelListener(double level) {
    sttMinSoundLevel = min(sttMinSoundLevel, level);
    sttMaxSoundLevel = max(sttMaxSoundLevel, level);
    // print("sound level $level: $minSoundLevel - $maxSoundLevel ");
    setState(() {
      this.sttLevel = level;
    });
  }

  Future<void> sttErrorListener(SpeechRecognitionError error) async {
    await sttCancelListening();
    // print("Received error status: $error, listening: ${speech.isListening}");
    setState(() {
      sttLastError = '${error.errorMsg} - ${error.permanent}';
    });
  }

  void sttStatusListener(String status) {
    // print(
    // 'Received listener status: $status, listening: ${speech.isListening}');
    setState(() {
      sttLastStatus = '$status';
    });
  }

  void _sttSwitchLang(selectedVal) {
    setState(() {
      _sttCurrentLocaleId = selectedVal;
    });
    print(selectedVal);
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

    await sttStopListening();

    await flutterTts.setLanguage(speakLanguage);
    if(ttsRateSlow){
      await flutterTts.setSpeechRate(ttsRate * 0.22);
    } else {
      await flutterTts.setSpeechRate(ttsRate);
    }
    await flutterTts.setPitch(ttsPitch);
    if (speakMessage != null) {
      if (speakMessage.isNotEmpty) {
        await flutterTts.awaitSpeakCompletion(true);
        await flutterTts.speak(speakMessage);
      }
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

  Future sendChatMessage(bool senderIsMe, String senderName, List<TextSpan> messageTextWidget, {String messageImage: '', bool needSpeak : false, String speakMessage : '', String speakLanguage : 'en-US'}) async {
    ChatMessageUtil message = new ChatMessageUtil(
      senderIsMe: senderIsMe,
      senderName: senderName,
      //messageText: messageText,
      messageTextWidget: messageTextWidget,
      messageImage: messageImage,
    );
    setState(() {
      _messages.insert(0, message);
    });

    if(needSpeak) {
      await _ttsSpeak(speakMessage, speakLanguage);
    }
  }

  void _handleSubmitted(String text) {
    sendChatMessage(true, 'Me', [TextSpan(text: text)]);
    _finishQuizData['secondsArray']!.add(_answerSeconds);
    setState(() {
      _isActive = false;
      ttsRateSlow = false;
      _allowTouchButtons['reListenButton'] = false;
      _allowTouchButtons['speakButton'] = false;
      _allowTouchButtons['pauseButton'] = false;
    });
    _responseChatBot(text);
  }


  void _responseChatBot(text) async {
    String checkSentencesJSON = await APIUtil.checkSentences(_questionText, text, correctCombo:_correctCombo);
    var checkSentences = jsonDecode(checkSentencesJSON.toString());
    //print(checkSentencesJSON.toString());

    if(checkSentences['apiStatus'] == 'success'){

      if(checkSentences['data']['ipaTextSimilarity'] == 100){
        _correctCombo++;
      } else {
        _correctCombo = 0;
      }

      ChatMessageUtil message;

      var questionTextArray = checkSentences['data']['questionText'].split(' ');
      List<TextSpan> questionTextWidget = [TextSpan(text: '第 $_part/$_totalTestQuestions 題：')];
      for (var i = 0; i < questionTextArray.length; i++) {
        if(checkSentences['data']['questionError'].containsKey(questionTextArray[i])){
          questionTextWidget.add(
              TextSpan(
                text: questionTextArray[i] + ' ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              )
          );
        } else {
          questionTextWidget.add(TextSpan(text: questionTextArray[i] + ' '));
        }
      }

      message = new ChatMessageUtil(
        senderIsMe: false,
        senderName: 'Bot',
        messageTextWidget: questionTextWidget,
      );
      setState(() {
        _messages[1] = message;
      });

      var answerTextArray = checkSentences['data']['answerText'].split(' ');
      List<TextSpan> answerTextWidget = [];

      for (var i = 0; i < answerTextArray.length; i++) {
        if(checkSentences['data']['answerError'].containsKey(answerTextArray[i])){
          answerTextWidget.add(
              TextSpan(
                text: answerTextArray[i] + ' ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              )
          );
        } else {
          answerTextWidget.add(TextSpan(text: answerTextArray[i] + ' '));
        }
      }

      message = new ChatMessageUtil(
        senderIsMe: true,
        senderName: 'Me',
        messageTextWidget: answerTextWidget,
      );
      setState(() {
        _messages[0] = message;
      });
      _finishQuizData['sentenceIDArray']!.add(_questionsData[_part - 1]['sentenceId']);
      _finishQuizData['sentenceAnswerArray']!.add(checkSentences['data']['answerText']);
      _finishQuizData['scoreArray']!.add(checkSentences['data']['scoreComment']['score']);
      print(_finishQuizData);
      await sendChatMessage(false, 'Bot', [TextSpan(text: '${checkSentences['data']['scoreComment']['text']} ${checkSentences['data']['scoreComment']['emoji']}，您花費 ${_finishQuizData['secondsArray']![_part - 1].toString()} 秒回答')], needSpeak:true, speakMessage:checkSentences['data']['scoreComment']['text'].toLowerCase(), speakLanguage:'en-US');
      await sendNextQuestion();


    } else {
      print('_responseChatBot Error apiStatus:' + checkSentences['apiStatus'] + ' apiMessage:' + checkSentences['apiMessage']);
      await Future.delayed(Duration(seconds: 1));
      _responseChatBot(text);
    }
  }


  Future<void> sendNextQuestion() async {
    await Future.delayed(Duration(milliseconds: 780));
    _part++;
    if( _part > _totalTestQuestions){
      await sendChatMessage(false, 'Bot', [TextSpan(text: '測驗結束')], needSpeak:true, speakMessage:'Quiz is over', speakLanguage:'en-US');

      //var secondsArraySum = _finishQuizData['secondsArray'].reduce((sum, element) => int.parse(sum) + int.parse(element));
      var secondsArraySum = _finishQuizData['secondsArray'].fold(0, (p, c) => p + c);



      await sendChatMessage(false, 'Bot', [
        TextSpan(text: '=== 紀錄 ===\n'),
        TextSpan(text: '答對題數/總題數：${ _finishQuizData['scoreArray'].where((score) => score == 100).toList().length } / ${ _finishQuizData['scoreArray'].length }\n'),
        TextSpan(text: '總回答秒數：${ secondsArraySum }秒\n'),
        TextSpan(text: '平均回答秒數：${ secondsArraySum / _finishQuizData['secondsArray'].length }秒\n'),

      ], needSpeak:false, speakMessage:'', speakLanguage:'en-US');

      if(_quizID != 0){
        EasyLoading.show(status: '正在儲存資料，請稍候......\nsssss');
        var updateQuizData;
        do {
          String updateQuizDataJSON = await APIUtil.updateQuizData(_applicationSettingsDataUUID, _quizID, _finishQuizData['sentenceIDArray'], _finishQuizData['sentenceAnswerArray'], _finishQuizData['scoreArray'], _finishQuizData['secondsArray']);
          updateQuizData = jsonDecode(updateQuizDataJSON.toString());
          print('updateQuizData 1 apiStatus:' + updateQuizData['apiStatus'] + ' apiMessage:' + updateQuizData['apiMessage']);
          if(updateQuizData['apiStatus'] != 'success') {
            EasyLoading.show(status: '儲存資料發生錯誤，正在重試......\n${updateQuizData['apiMessage']}');
            await Future.delayed(Duration(seconds: 1));
          }
        } while (updateQuizData['apiStatus'] != 'success');

        EasyLoading.dismiss();

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('紀錄已更新'),
        ));
      } else {
        showCupertinoDialog();
      }






    } else {
      _questionText = _questionsData[_part - 1]['sentenceContent'];
      await sendChatMessage(false, 'Bot', [TextSpan(text: '第 ${_part}/$_totalTestQuestions 題：${_questionsData[_part - 1]['sentenceChinese']}')], needSpeak:false, speakMessage:'', speakLanguage:'zh-TW');
      await sendChatMessage(false, 'Bot', [TextSpan(text: '第 ${_part}/$_totalTestQuestions 題：${_questionText}')], needSpeak:true, speakMessage:_questionText, speakLanguage:'en-US');
      await Future.delayed(Duration(milliseconds: (_part / _totalTestQuestions * 2340).round()));
      setState(() {
        _isActive = true;
      });
      await sttStartListening();
      setState(() {
        ttsRateSlow = false;
        _allowTouchButtons['reListenButton'] = true;
        _allowTouchButtons['speakButton'] = true;
        _allowTouchButtons['pauseButton'] = true;
      });
    }
  }



  void showCupertinoDialog() {
    TextEditingController textInputController = new TextEditingController();

    //textInputController..text = '[${_applicationSettingsDataListenAndSpeakLevel}/${_applicationSettingsDataListenAndSpeakRanking.round().toString()}] (${_topicClass}:${_topicName})';
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text('請問要儲存本次紀錄嗎？'),
          content: TextField(
            controller: textInputController,
            decoration: InputDecoration(hintText: '請在此輸入標題'),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('不要儲存'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text('儲存'),
              onPressed: () async {
                if(textInputController.text == ''){
                  textInputController..text = '[${_applicationSettingsDataListenAndSpeakLevel}/${_applicationSettingsDataListenAndSpeakRanking.round().toString()}] (${_topicClass}:${_topicName})';
                }

                var saveQuizData;
                do {
                  String saveQuizDataJSON = await APIUtil.saveQuizData(_applicationSettingsDataUUID, textInputController.text, _finishQuizData['sentenceIDArray'], _finishQuizData['sentenceAnswerArray'], _finishQuizData['scoreArray'], _finishQuizData['secondsArray']);
                  saveQuizData = jsonDecode(saveQuizDataJSON.toString());
                  print('saveQuizData 1 apiStatus:' + saveQuizData['apiStatus'] + ' apiMessage:' + saveQuizData['apiMessage']);
                  if(saveQuizData['apiStatus'] != 'success') {
                    await Future.delayed(Duration(seconds: 1));
                  }
                } while (saveQuizData['apiStatus'] != 'success');

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('紀錄已儲存'),
                ));

                Navigator.of(context).pop();
              },
            ),
          ],
        ));
  }

  void handleTick() {
    //print(_answerSeconds);
    if (_isActive) {
      setState(() {
        _answerSeconds += 1;
      });
    } else {
      setState(() {
        if (Platform.isIOS) {
          _answerSeconds = -3;
        } else {
          _answerSeconds = 0;
        }
      });
    }
  }

}