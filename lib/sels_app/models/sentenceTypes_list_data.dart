

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sels_app/main.dart';
import 'package:sels_app/sels_app/Utils/APIUtil.dart';

BuildContext context = navigatorKey.currentState!.overlay!.context;
class SentenceTypesListData {

  SentenceTypesListData({
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
  //static final Map<String, Map<String, dynamic>> topicListData =  APIUtil.getSentenceTopicData();
  /*
  static Map<String, Map<String, dynamic>> topicListData = {
    "Animals": {
      "startColor": "#FA7D82",
      "endColor": "#FFB295",
      "Title": ["Animals", "Animals", "Birds", "Fish and shellfish", "Insects, worms, etc."],
      "Descrip": ["Animals", "Animals", "Birds", "Fish and shellfish", "Insects, worms, etc."],
    },
    "Appearance": {
      "startColor": "#738AE6",
      "endColor": "#5C5EDD",
      "Title": ["Appearance", "Appearance", "Body", "Clothes and Fashion", "Colours and Shapes"],
      "Descrip": ["Appearance", "Appearance", "Body", "Clothes and Fashion", "Colours and Shapes"],
    },
    "Communication": {
      "startColor": "#FE95B6",
      "endColor": "#FF5287",
      "Title": ["Communication", "Language", "Phones, email and the internet"],
      "Descrip": ["Communication", "Language", "Phones, email and the internet"],
    },
    "Culture": {
      "startColor": "#6F72CA",
      "endColor": "#1E1466",
      "Title": ["Culture", "Art", "Film and theatre", "Literature and writing", "Music", "TV, radio and news"],
      "Descrip": ["Culture", "Art", "Film and theatre", "Literature and writing", "Music", "TV, radio and news"],
    },
    "Food_and_drink": {
      "startColor": "#FF69F0AE",
      "endColor": "#FF4CAF50",
      "Title": ["Food and drink", "Cooking and eating", "Drinks", "Food"],
      "Descrip": ["Food and drink", "Cooking and eating", "Drinks", "Food"],
    },
    "Functions": {
      "startColor": "#FA7D82",
      "endColor": "#FFB295",
      "Title": ["Functions", "Discussion and agreement", "Doubt, guessing and certainty", "Opinion and argument", "Permission and obligation", "Preferences and decisions", "Suggestions and advice"],
      "Descrip": ["Functions", "Discussion and agreement", "Doubt, guessing and certainty", "Opinion and argument", "Permission and obligation", "Preferences and decisions", "Suggestions and advice"],
    },
    "Health": {
      "startColor": "#738AE6",
      "endColor": "#5C5EDD",
      "Title": ["Health", "Health and Fitness", "Illness", "Medicine"],
      "Descrip": ["Health", "Health and Fitness", "Illness", "Medicine"],
    },
    "Homes_and_buildings": {
      "startColor": "#FE95B6",
      "endColor": "#FF5287",
      "Title": ["Homes and buildings", "Buildings", "Gardens", "Houses and homes"],
      "Descrip": ["Homes and buildings", "Buildings", "Gardens", "Houses and homes"],
    },
    "Leisure": {
      "startColor": "#6F72CA",
      "endColor": "#1E1466",
      "Title": ["Leisure", "Games and toys", "Hobbies", "Shopping"],
      "Descrip": ["Leisure", "Games and toys", "Hobbies", "Shopping"],
    },
    "Notions": {
      "startColor": "#FF69F0AE",
      "endColor": "#FF4CAF50",
      "Title": ["Notions", "Change, cause and effect", "Danger", "Difficulty and failure", "Success"],
      "Descrip": ["Notions", "Change, cause and effect", "Danger", "Difficulty and failure", "Success"],
    },
    "People": {
      "startColor": "#FA7D82",
      "endColor": "#FFB295",
      "Title": ["People", "Education", "Family and relationships", "Feelings", "Life stages", "Personal qualities"],
      "Descrip": ["People", "Education", "Family and relationships", "Feelings", "Life stages", "Personal qualities"],
    },
    "Politics_and_society": {
      "startColor": "#738AE6",
      "endColor": "#5C5EDD",
      "Title": ["Politics and society", "Crime and punishment", "Law and justice", "People in society", "Politics", "Religion and festivals", "Social issues", "War and conflict"],
      "Descrip": ["Politics and society", "Crime and punishment", "Law and justice", "People in society", "Politics", "Religion and festivals", "Social issues", "War and conflict"],
    },
    "Science_and_technology": {
      "startColor": "#FE95B6",
      "endColor": "#FF5287",
      "Title": ["Science and technology", "Biology", "Computers", "Engineering", "Maths and measurement", "Physics and chemistry", "Scientific research"],
      "Descrip": ["Science and technology", "Biology", "Computers", "Engineering", "Maths and measurement", "Physics and chemistry", "Scientific research"],
    },
    "Sport": {
      "startColor": "#6F72CA",
      "endColor": "#1E1466",
      "Title": ["Sport", "Sports: ball and racket sports", "Sports: other sports", "Sports: water sports"],
      "Descrip": ["Sport", "Sports: ball and racket sports", "Sports: other sports", "Sports: water sports"],
    },
    "The_natural_world": {
      "startColor": "#FF69F0AE",
      "endColor": "#FF4CAF50",
      "Title": ["The natural world", "Farming", "Geography", "Plants and trees", "The environment", "Weather", "History", "Space", "Time"],
      "Descrip": ["The natural world", "Farming", "Geography", "Plants and trees", "The environment", "Weather", "History", "Space", "Time"],
    },
    "Time_and_space": {
      "startColor": "#FA7D82",
      "endColor": "#FFB295",
      "Title": ["Time and space", "History", "Space", "Time"],
      "Descrip": ["Time and space", "History", "Space", "Time"],
    },
    "Travel": {
      "startColor": "#738AE6",
      "endColor": "#5C5EDD",
      "Title": ["Travel", "Holidays", "Transport by air", "Transport by bus and train", "Transport by car or lorry", "Transport by water", "Business", "Jobs", "Money", "Working life"],
      "Descrip": ["Travel", "Holidays", "Transport by air", "Transport by bus and train", "Transport by car or lorry", "Transport by water", "Business", "Jobs", "Money", "Working life"],
    }
  };

   */

 static Future<List<SentenceTypesListData>?> getSentenceTypesListData({String key:''}) async {

   EasyLoading.show(status: '正在讀取資料，請稍候......');
   String topicListDataJSON = await APIUtil.getSentenceTopicData();
   var topicListData = jsonDecode(topicListDataJSON.toString());
   print(topicListData);

   EasyLoading.dismiss();

   if(key == ''){
     List<SentenceTypesListData> list = [];
     topicListData['data'].forEach((key, value) {
       list.add(
         SentenceTypesListData(
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
     List<SentenceTypesListData> list = [];

     for (int i = 1; i < topicListData[key]!['title']!.length; i++) {
       list.add(
         SentenceTypesListData(
           imagePath: 'assets/sels_app/' + topicListData[key]!['appIcon']![i] + '.png',
           titleTxt: topicListData[key]!['title']![i],
           descripTxt: topicListData[key]!['descrip']![i],
           onTapFunction: (){

           },
           startColor: topicListData[key]!['appStartColor']![i],
           endColor: topicListData[key]!['appEndColor']![i],
         ),
       );
     }
     return list;
   }
   //return listDataNew[key];
  }


}
