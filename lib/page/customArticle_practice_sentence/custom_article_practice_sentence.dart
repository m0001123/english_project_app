import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:alicsnet_app/page/customArticle_practice_sentence/pie_chart_widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:alicsnet_app/router/router.gr.dart';
import 'package:alicsnet_app/model/sentence_example_data.dart';
import 'package:alicsnet_app/page/login/fade_animation.dart';
import 'package:alicsnet_app/util/api_util.dart';
import 'package:alicsnet_app/page/page_theme.dart';

class CustomArticlePracticeSentenceIndexPage extends StatefulWidget {
  const CustomArticlePracticeSentenceIndexPage({Key? key}) : super(key: key);

  @override
  _CustomArticlePracticeSentenceIndexPage createState() =>
      _CustomArticlePracticeSentenceIndexPage();
}

class _CustomArticlePracticeSentenceIndexPage
    extends State<CustomArticlePracticeSentenceIndexPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  TextEditingController _controller = new TextEditingController();
  final r = RegExp(r'[a-zA-Z]+');
  final r2 = RegExp(r'[.]');
  String text = "";
  int maxLength = 500;
  List sentencelist = [];
  List sentenceIPAlist = [];
  bool isloading = false;
  bool practice_auto = true;
  int inputWordCount = 0;
  List<TextSpan> outOfRangeWord = [];
  List<Widget> topicList = [];
  List pieChartData = [];
  @override
  void initState() {
    super.initState();
    creatTopic();
  }

  @override
  void dispose() {
    //SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.dispose();
  }

  //創建topiWidget
  void creatTopic() async {
    sentenceExampleData.sentence.keys.forEach((key) {
      topicList.add(
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: SizedBox(
            height: 24,
            child: ElevatedButton(
              onPressed: () {
                int count = 0;
                for (var i = 0;
                    i < sentenceExampleData.sentence[key].split(" ").length;
                    i++) {
                  if (r.hasMatch(
                      sentenceExampleData.sentence[key].split(" ")[i])) {
                    count += 1;
                  }
                }
                setState(() {
                  inputWordCount = count;
                });
                _controller.text = sentenceExampleData.sentence[key];
              },
              child: Text('${key}'),
              style:
                  ElevatedButton.styleFrom(primary: PageTheme.app_theme_blue),
            ),
          ),
        ),
      );
    });
  }

  //將輸入文章做作文法校正、分句、文章分析
  void articleAnalyze() async {
    print(_controller.text);
    setState(() {
      pieChartData = [];
      sentenceIPAlist = [];
      isloading = true;
      sentencelist = [];
      outOfRangeWord = [];
    });
    var sentenceSegmentation;
    var ipa;
    var getStatitics;
    try {
      if (_controller.text != "" && inputWordCount > 0) {
        String grammar_response =
            await APIUtil.checkGrammar(_controller.text.replaceAll("\n", " "));
        var checkedGrammar = jsonDecode(grammar_response);
        if (checkedGrammar['apiStatus'] == 'success') {
          sentenceSegmentation = await APIUtil.getSentenceSegmentation(
              checkedGrammar['data']['sentenceTextChecked']);
          getStatitics = await APIUtil.getStatitics(
              checkedGrammar['data']['sentenceTextChecked']);
        } else {
          setState(() {
            isloading = false;
          });
          final text = "文章內容包含除英文之外的字元";
          final snackbar = SnackBar(
            content: Text(text),
          );
          //_scaffoldKey.currentState?.showSnackBar(snackbar);
        }
        if (sentenceSegmentation['apiStatus'] == 'success' &&
            getStatitics['apiStatus'] == 'success') {
          print(sentenceSegmentation['data']);
          ipa = await APIUtil.getSentenceIPA(sentenceSegmentation['data']);
          if (ipa['apiStatus'] == 'success') {
            print(getStatitics['data']['statitics']);
            setState(() {
              pieChartData = getStatitics['data']['statitics'];
              sentenceIPAlist = ipa['data'];
              isloading = false;
              sentencelist = sentenceSegmentation['data'];
            });
            if (getStatitics['data']['word'] != null) {
              List w = getStatitics['data']['word'];
              w.forEach((element) {
                outOfRangeWord.add(TextSpan(
                    text: element,
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        decoration: TextDecoration.underline)));
                outOfRangeWord.add(TextSpan(text: ", "));
              });
            } else {
              List w = ['null'];
              w.forEach((element) {
                outOfRangeWord.add(TextSpan(
                  text: element,
                ));
              });
            }
          } else {
            final text = "發生異常";
            final snackbar = SnackBar(
              content: Text(text),
            );
            //_scaffoldKey.currentState?.showSnackBar(snackbar);
            setState(() {
              isloading = false;
            });
          }
        } else {
          final text = "發生異常";
          final snackbar = SnackBar(
            content: Text(text),
          );
          //_scaffoldKey.currentState?.showSnackBar(snackbar);
          setState(() {
            isloading = false;
          });
        }
      } else {
        setState(() {
          isloading = false;
        });
        final text = "請輸入文章";
        final snackbar = SnackBar(
          content: Text(text),
        );
        //_scaffoldKey.currentState?.showSnackBar(snackbar);
      }
    } catch (error) {
      setState(() {
        isloading = false;
      });
      final text = "發生異常";
      final snackbar = SnackBar(
        content: Text(text),
      );
      //_scaffoldKey.currentState?.showSnackBar(snackbar);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white, //Color(0xffffdef5),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: PageTheme.app_theme_black,
          title: AutoSizeText(
            '學習者提供教材',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              letterSpacing: 3.0,
              color: Color(0xFFFEFEFE),
            ),
            maxLines: 1,
          ),
        ),
        body: ListView(
          padding: EdgeInsets.only(
            top: 16,
            bottom: 62,
          ),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text("Example Article",
                      style: TextStyle(
                          color: PageTheme.cutom_article_practice_background,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text("範例文章",
                      style: TextStyle(
                          color: PageTheme.cutom_article_practice_background
                              .withOpacity(0.8),
                          fontSize: 14,
                          height: 1.0,
                          fontWeight: FontWeight.bold)),
                ),
                Container(
                  height: 3,
                  margin: EdgeInsets.only(right: 10, left: 10, top: 5),
                  decoration: BoxDecoration(
                      color: PageTheme.cutom_article_practice_background,
                      borderRadius: BorderRadius.circular(15)),
                ),
              ],
            ),
            Container(
                height: 24,
                margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: topicList,
                )),
            /*Padding(
              padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
              child: Wrap(
                runSpacing: 5.0,
                children: topicList,
              ),
            ),*/
            Container(
                margin: const EdgeInsets.only(
                    top: 10, left: 20, right: 20, bottom: 5),
                padding: const EdgeInsets.only(left: 10, right: 10),
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    width: 2,
                    color: PageTheme.cutom_article_practice_background
                        .withOpacity(0.5),
                  ),
                ),
                child: ListView(
                  children: [
                    TextField(
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: "請輸入一段文章或著點擊上方範例文章",
                          border: InputBorder.none,
                        ),
                        maxLines: null,
                        minLines: 1,
                        controller: _controller,
                        onChanged: (String newVal) {
                          String article =
                              _controller.text.replaceAll("\n", " ");
                          int count = 0;
                          String pastText = "";
                          for (var i = 0; i < article.split(" ").length; i++) {
                            if (r.hasMatch(article.split(' ')[i])) {
                              count += 1;
                            }
                          }
                          if (count <= maxLength) {
                            setState(() {
                              inputWordCount = count;
                            });
                            setState(() {
                              _controller.value = TextEditingValue(
                                text: article,
                                selection: TextSelection.fromPosition(
                                  TextPosition(offset: newVal.length),
                                  
                                )
                              );
                            });
                          } else {
                            List period =[];
                            for (var i = 0; i < 500; i++) {
                              if(r.hasMatch(article.split(' ')[i])){
                                pastText += article.split(' ')[i] + " ";
                              }
                            }
                            period =  pastText.split(' ');
                            for(var i =pastText.split(' ').length-1;i>0;i--){
                              if(r2.hasMatch(pastText.split(' ')[i])){
                                period.removeRange(i+1, pastText.split(' ').length);
                                break;
                              }
                            }
                            showDialog(
                                context: context,
                                builder: (context) => wordCountDialog());
                            setState(() {
                              inputWordCount = period.length;
                              _controller.text = period.join(" ");
                            });
                          }
                        })
                  ],
                )),
            Row(
              children: [
                Expanded(child: Container()),
                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: Text(
                    '${inputWordCount}/500',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 20, bottom: 30),
              child: Row(
                children: [
                  Expanded(child: Container()),
                  isloading
                      ? Container(
                          padding: EdgeInsets.all(3),
                          height: 40,
                          width: 100,
                          child: Center(
                              child: CircularProgressIndicator(
                            color: PageTheme.cutom_article_practice_background,
                            strokeWidth: 4.0,
                          )))
                      : GestureDetector(
                          onTap: () {
                            articleAnalyze();
                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');
                          },
                          child: Container(
                            padding: EdgeInsets.all(3),
                            height: 40,
                            width: 100,
                            decoration: BoxDecoration(
                                color:
                                    PageTheme.cutom_article_practice_background,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: const Offset(0, 1),
                                  ),
                                ]),
                            child: Center(
                                child: Text(
                              "提交",
                              style: TextStyle(color: Colors.white),
                            )),
                          ),
                        ),
                ],
              ),
            ),
            if (sentencelist.length >= 1 && !isloading)
              FadeAnimation(
                1,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Row(
                          children: [
                            Text("Word Grade Level Distribution",
                                style: TextStyle(
                                    color: PageTheme
                                        .cutom_article_practice_background,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(
                              width: 2,
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => CustomAlertDialog());
                              },
                              icon: Icon(
                                Icons.help_outline_outlined,
                                color:
                                    PageTheme.cutom_article_practice_background,
                              ),
                            )
                          ],
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Text("單字級別分佈",
                          style: TextStyle(
                              color: PageTheme.cutom_article_practice_background
                                  .withOpacity(0.8),
                              fontSize: 14,
                              height: 1.0,
                              fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      height: 3,
                      margin: EdgeInsets.only(
                          right: 10, left: 10, top: 3, bottom: 10),
                      decoration: BoxDecoration(
                          color: PageTheme.cutom_article_practice_background,
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    PieChartWidget(
                      data: pieChartData,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      child: Text.rich(
                        TextSpan(
                          text: 'Out of 10K range：',
                          style: TextStyle(
                            color: Colors.black54,
                            fontStyle: FontStyle.italic,
                          ),
                          children: outOfRangeWord,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Text("Sentence Shadow Speaking",
                          style: TextStyle(
                              color:
                                  PageTheme.cutom_article_practice_background,
                              fontSize: 18,
                              height: 1.0,
                              fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: Row(
                        children: [
                          Text("句子跟讀",
                              style: TextStyle(
                                  color: PageTheme
                                      .cutom_article_practice_background
                                      .withOpacity(0.8),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold)),
                          Expanded(child: Container()),
                        ],
                      ),
                    ),
                    Container(
                      height: 3,
                      margin: EdgeInsets.only(right: 10, left: 10, top: 3),
                      decoration: BoxDecoration(
                          color: PageTheme.cutom_article_practice_background,
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(child: Container()),
                        SizedBox(
                          height: 30,
                          width: 100,
                          child: ElevatedButton(
                              onPressed: () async {
                                if (!practice_auto) {
                                  AutoRouter.of(context).push(
                                      CustomArticlePracticeSentenceLearnManualRoute(
                                    questionList: sentencelist,
                                    questionIPAList: sentenceIPAlist,
                                  ));
                                } else {
                                  AutoRouter.of(context).push(
                                      CustomArticlePracticeSentenceLearnAutoRoute(
                                    questionList: sentencelist,
                                  ));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: PageTheme
                                      .cutom_article_practice_background),
                              child: Text('口語練習')),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text("Auto：",
                            style: TextStyle(
                                color:
                                    PageTheme.cutom_article_practice_background,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                        Switch(
                          value: practice_auto,
                          onChanged: (value) {
                            setState(() {
                              practice_auto = !practice_auto;
                            });
                          },
                          activeColor:
                              PageTheme.cutom_article_practice_background,
                          activeTrackColor: Color(0xffcbdaff),
                        ),
                        Expanded(child: Container()),
                      ],
                    )
                  ],
                ),
              ),
            for (var i = 0; i < sentencelist.length; i++)
              FadeAnimation(
                1.0,
                Card(
                  margin: EdgeInsets.only(top: 15, left: 20, right: 20),
                  color: Color(0xffcbdaff),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ListTile(
                      title: Text(
                        "${sentencelist[i]}",
                        style: TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ));
  }
}
//文章分析說明dialog


class wordCountDialog extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 12,
            ),
            Text(
              '提醒',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              '您輸入的文章字數已超過500字，將自動刪除多餘的字',
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0))),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Stack(
          //overflow: Overflow.visible,
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: 420,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 40, 10, 10),
                child: Column(
                  children: [
                    Text(
                      '文章分析',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '此功能是在分析您輸入的文章分別由哪些單字等級所組成',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    Divider(
                      color: Colors.black54,
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text.rich(
                      TextSpan(
                        text: 'Alics各等級單字分配如下\n',
                        style: TextStyle(color: Colors.black54, height: 1.5),
                        children: [
                          TextSpan(
                              text: '◎ 國小：11.74%，共1087個\n',
                              style: TextStyle(height: 2)),
                          TextSpan(
                              text: '◎ 國中：13.55%，共1255個\n',
                              style: TextStyle(height: 1.5)),
                          TextSpan(
                              text: '◎ 高中(1)：22.76%，共2117個\n',
                              style: TextStyle(height: 1.5)),
                          TextSpan(
                              text: '◎ 高中(2)：23.28%，共2156個\n',
                              style: TextStyle(height: 1.5)),
                          TextSpan(
                              text: '◎ 全民英檢：4.78%，共443個\n',
                              style: TextStyle(height: 1.5)),
                          TextSpan(
                              text: '◎ 多益：11.56%，共1071個\n',
                              style: TextStyle(height: 1.5)),
                          TextSpan(
                              text: '◎ 托福：12.22%，共1132個\n',
                              style: TextStyle(height: 1.5)),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                      style: ElevatedButton.styleFrom(
                          primary: PageTheme.cutom_article_practice_background),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
                top: -30,
                child: CircleAvatar(
                  backgroundColor: PageTheme.cutom_article_practice_background,
                  radius: 30,
                  child: Icon(
                    Icons.question_mark,
                    color: Colors.white,
                    size: 18,
                  ),
                )),
          ],
        ));
  }
}
