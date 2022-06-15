
import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:alicsnet_app/util/api_util.dart';

class SentenceTypeListData {

  SentenceTypeListData({
    this.imagePath = '',
    this.titleTxt = '',
    this.descripTxt = '',
    this.startColor = '',
    this.endColor = '',
    this.sentenceTypes,
    this.onTapFunction,
  });

  String imagePath;
  String titleTxt;
  String descripTxt;
  String startColor;
  String endColor;
  List<String>? sentenceTypes;
  Function()? onTapFunction;

  static Future<List<SentenceTypeListData>?> getSentenceTypeListData({String key:''}) async {

    EasyLoading.show(status: '正在讀取資料，請稍候......');
    String topicListDataJSON = await APIUtil.getSentenceTopicData();
    var topicListData = jsonDecode(topicListDataJSON.toString());
    //print(topicListData);

    EasyLoading.dismiss();
print(topicListData['data']);
    if(key == ''){
      List<SentenceTypeListData> list = [];
      topicListData['data'].forEach((key, value) {
        list.add(
            SentenceTypeListData(
              imagePath: 'assets/sels_app/' + value['appIcon']![0] + '.png',
              titleTxt: value['title']![0],
              descripTxt: '目前有' + value['sentnceCount']![0].toString() + '個句子\n' + value['descrip']![0],
              onTapFunction: (){

              },
              startColor: value['appStartColor']![0],
              endColor: value['appEndColor']![0],
            )
        );

      });
      return list;
    }else{
      List<SentenceTypeListData> list = [];

      for (int i = 1; i < topicListData['data'][key]!['title']!.length; i++) {
        list.add(
          SentenceTypeListData(
            imagePath: 'assets/sels_app/' + topicListData['data'][key]!['appIcon']![i] + '.png',
            titleTxt: topicListData['data'][key]!['title']![i],
            descripTxt: topicListData['data'][key]!['descrip']![i],
            onTapFunction: (){

            },
            startColor: topicListData['data'][key]!['appStartColor']![i],
            endColor: topicListData['data'][key]!['appEndColor']![i],
          ),
        );
      }
      return list;
    }
  }


}