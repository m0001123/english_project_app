// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i22;
import 'package:flutter/material.dart' as _i23;

import '../page/customArticle_practice_sentence/custom_article_practice_sentence.dart'
    as _i13;
import '../page/customArticle_practice_sentence/custom_article_practice_sentence_learn_auto_page.dart'
    as _i14;
import '../page/customArticle_practice_sentence/custom_article_practice_sentence_learn_manual_page.dart'
    as _i15;
import '../page/index/index_page.dart' as _i2;
import '../page/learning/learning_auto_generic_page.dart' as _i16;
import '../page/learning/learning_manual_vocabulary_practice_word_page.dart'
    as _i17;
import '../page/login/sign_in_page.dart' as _i1;
import '../page/minimal_pair/minimal_pair_index_page.dart' as _i10;
import '../page/minimal_pair/minimal_pair_learn_auto_page.dart' as _i11;
import '../page/minimal_pair/minimal_pair_learn_manual_page.dart' as _i12;
import '../page/new_template/grammar_correction_main_page.dart' as _i20;
import '../page/new_template/index_learn_record_index_page.dart' as _i21;
import '../page/new_template/index_vocabulary_test_level_select_page.dart'
    as _i18;
import '../page/new_template/index_vocabulary_test_questing_page.dart' as _i19;
import '../page/vocabulary_practice_sentence/vocabulary_practice_sentence_index_page.dart'
    as _i3;
import '../page/vocabulary_practice_sentence/vocabulary_practice_sentence_learn_auto_page.dart'
    as _i4;
import '../page/vocabulary_practice_sentence/vocabulary_practice_sentence_learn_manual_page.dart'
    as _i5;
import '../page/vocabulary_practice_word/vocabulary_practice_word_index_page.dart'
    as _i6;
import '../page/vocabulary_practice_word/vocabulary_practice_word_learn_auto_page.dart'
    as _i8;
import '../page/vocabulary_practice_word/vocabulary_practice_word_learn_manual_page.dart'
    as _i9;
import '../page/vocabulary_practice_word/vocabulary_practice_word_list_page.dart'
    as _i7;

class AppRouter extends _i22.RootStackRouter {
  AppRouter([_i23.GlobalKey<_i23.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i22.PageFactory> pagesMap = {
    SignInRoute.name: (routeData) {
      return _i22.MaterialPageX<dynamic>(
          routeData: routeData, child: _i1.SignInPage());
    },
    IndexRoute.name: (routeData) {
      return _i22.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.IndexPage());
    },
    VocabularyPracticeSentenceIndexRoute.name: (routeData) {
      return _i22.MaterialPageX<dynamic>(
          routeData: routeData,
          child: const _i3.VocabularyPracticeSentenceIndexPage());
    },
    VocabularyPracticeSentenceLearnAutoRoute.name: (routeData) {
      final args =
          routeData.argsAs<VocabularyPracticeSentenceLearnAutoRouteArgs>(
              orElse: () =>
                  const VocabularyPracticeSentenceLearnAutoRouteArgs());
      return _i22.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i4.VocabularyPracticeSentenceLearnAutoPage(
              key: args.key,
              topicClass: args.topicClass,
              topicName: args.topicName,
              sentencesIDData: args.sentencesIDData,
              quizID: args.quizID,
              wordSet: args.wordSet));
    },
    VocabularyPracticeSentenceLearnManualRoute.name: (routeData) {
      final args =
          routeData.argsAs<VocabularyPracticeSentenceLearnManualRouteArgs>(
              orElse: () =>
                  const VocabularyPracticeSentenceLearnManualRouteArgs());
      return _i22.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i5.VocabularyPracticeSentenceLearnManualPage(
              key: args.key,
              topicClass: args.topicClass,
              topicName: args.topicName));
    },
    VocabularyPracticeWordIndexRoute.name: (routeData) {
      return _i22.MaterialPageX<dynamic>(
          routeData: routeData,
          child: const _i6.VocabularyPracticeWordIndexPage());
    },
    VocabularyPracticeWordListRoute.name: (routeData) {
      final args = routeData.argsAs<VocabularyPracticeWordListRouteArgs>();
      return _i22.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i7.VocabularyPracticeWordListPage(
              key: args.key, vocabularyList: args.vocabularyList));
    },
    VocabularyPracticeWordLearnAutoRoute.name: (routeData) {
      final args = routeData.argsAs<VocabularyPracticeWordLearnAutoRouteArgs>();
      return _i22.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i8.VocabularyPracticeWordLearnAutoPage(
              key: args.key, wordRankingList: args.wordRankingList));
    },
    VocabularyPracticeWordLearnManualRoute.name: (routeData) {
      final args =
          routeData.argsAs<VocabularyPracticeWordLearnManualRouteArgs>();
      return _i22.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i9.VocabularyPracticeWordLearnManualPage(
              key: args.key, word: args.word));
    },
    MinimalPairIndexRoute.name: (routeData) {
      return _i22.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i10.MinimalPairIndexPage());
    },
    MinimalPairLearnAutoRoute.name: (routeData) {
      final args = routeData.argsAs<MinimalPairLearnAutoRouteArgs>(
          orElse: () => const MinimalPairLearnAutoRouteArgs());
      return _i22.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i11.MinimalPairLearnAutoPage(
              key: args.key,
              IPA1: args.IPA1,
              IPA2: args.IPA2,
              word: args.word));
    },
    MinimalPairLearnManualRoute.name: (routeData) {
      final args = routeData.argsAs<MinimalPairLearnManualRouteArgs>(
          orElse: () => const MinimalPairLearnManualRouteArgs());
      return _i22.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i12.MinimalPairLearnManualPage(
              key: args.key,
              IPA1: args.IPA1,
              IPA2: args.IPA2,
              word: args.word));
    },
    CustomArticlePracticeSentenceIndexRoute.name: (routeData) {
      return _i22.MaterialPageX<dynamic>(
          routeData: routeData,
          child: const _i13.CustomArticlePracticeSentenceIndexPage());
    },
    CustomArticlePracticeSentenceLearnAutoRoute.name: (routeData) {
      final args =
          routeData.argsAs<CustomArticlePracticeSentenceLearnAutoRouteArgs>();
      return _i22.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i14.CustomArticlePracticeSentenceLearnAutoPage(
              key: args.key, questionList: args.questionList));
    },
    CustomArticlePracticeSentenceLearnManualRoute.name: (routeData) {
      final args =
          routeData.argsAs<CustomArticlePracticeSentenceLearnManualRouteArgs>();
      return _i22.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i15.CustomArticlePracticeSentenceLearnManualPage(
              key: args.key,
              questionList: args.questionList,
              questionIPAList: args.questionIPAList));
    },
    LearningAutoGenericRoute.name: (routeData) {
      final args = routeData.argsAs<LearningAutoGenericRouteArgs>();
      return _i22.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i16.LearningAutoGenericPage(
              key: args.key,
              contentList: args.contentList,
              ipaList: args.ipaList,
              translateList: args.translateList));
    },
    LearningManualVocabularyPraticeWordRoute.name: (routeData) {
      final args =
          routeData.argsAs<LearningManualVocabularyPraticeWordRouteArgs>();
      return _i22.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i17.LearningManualVocabularyPraticeWordPage(
              key: args.key,
              vocabularyList: args.vocabularyList,
              vocabularySentenceList: args.vocabularySentenceList));
    },
    IndexVocabularyTestLevelSelectRoute.name: (routeData) {
      return _i22.MaterialPageX<dynamic>(
          routeData: routeData,
          child: const _i18.IndexVocabularyTestLevelSelectPage());
    },
    IndexVocabularyTestQuestingRoute.name: (routeData) {
      return _i22.MaterialPageX<dynamic>(
          routeData: routeData,
          child: const _i19.IndexVocabularyTestQuestingPage());
    },
    GrammarCorrectionMainRoute.name: (routeData) {
      return _i22.MaterialPageX<dynamic>(
          routeData: routeData, child: _i20.GrammarCorrectionMainPage());
    },
    IndexLearnRecordIndexRoute.name: (routeData) {
      return _i22.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i21.IndexLearnRecordIndexPage());
    }
  };

  @override
  List<_i22.RouteConfig> get routes => [
        _i22.RouteConfig(SignInRoute.name, path: '/'),
        _i22.RouteConfig(IndexRoute.name, path: '/index'),
        _i22.RouteConfig(VocabularyPracticeSentenceIndexRoute.name,
            path: '/voabulary_practice_sentence_index'),
        _i22.RouteConfig(VocabularyPracticeSentenceLearnAutoRoute.name,
            path: '/voabulary_practice_sentence_auto'),
        _i22.RouteConfig(VocabularyPracticeSentenceLearnManualRoute.name,
            path: '/voabulary_practice_sentence_manual'),
        _i22.RouteConfig(VocabularyPracticeWordIndexRoute.name,
            path: '/voabulary_practice_word_index'),
        _i22.RouteConfig(VocabularyPracticeWordListRoute.name,
            path: '/voabulary_practice_word_list'),
        _i22.RouteConfig(VocabularyPracticeWordLearnAutoRoute.name,
            path: '/voabulary_practice_word_auto'),
        _i22.RouteConfig(VocabularyPracticeWordLearnManualRoute.name,
            path: '/voabulary_practice_word_manual'),
        _i22.RouteConfig(MinimalPairIndexRoute.name,
            path: '/minimal_pair_index'),
        _i22.RouteConfig(MinimalPairLearnAutoRoute.name,
            path: '/minimal_pair_auto'),
        _i22.RouteConfig(MinimalPairLearnManualRoute.name,
            path: '/minimal_pair_manual'),
        _i22.RouteConfig(CustomArticlePracticeSentenceIndexRoute.name,
            path: '/customArticle_practice_sentence_index'),
        _i22.RouteConfig(CustomArticlePracticeSentenceLearnAutoRoute.name,
            path: '/customArticle_practice_sentence_auto'),
        _i22.RouteConfig(CustomArticlePracticeSentenceLearnManualRoute.name,
            path: '/customArticle_practice_sentence_manual'),
        _i22.RouteConfig(LearningAutoGenericRoute.name,
            path: '/learnig_auto_generic'),
        _i22.RouteConfig(LearningManualVocabularyPraticeWordRoute.name,
            path: '/learning_manual_vocabulary_practice_word'),
        _i22.RouteConfig(IndexVocabularyTestLevelSelectRoute.name,
            path: '/vocabulary_test_select_level'),
        _i22.RouteConfig(IndexVocabularyTestQuestingRoute.name,
            path: '/vocabulary_test_questing'),
        _i22.RouteConfig(GrammarCorrectionMainRoute.name,
            path: '/grammar_correction_main_page'),
        _i22.RouteConfig(IndexLearnRecordIndexRoute.name,
            path: '/vocabulary_record_index_page')
      ];
}

/// generated route for
/// [_i1.SignInPage]
class SignInRoute extends _i22.PageRouteInfo<void> {
  const SignInRoute() : super(SignInRoute.name, path: '/');

  static const String name = 'SignInRoute';
}

/// generated route for
/// [_i2.IndexPage]
class IndexRoute extends _i22.PageRouteInfo<void> {
  const IndexRoute() : super(IndexRoute.name, path: '/index');

  static const String name = 'IndexRoute';
}

/// generated route for
/// [_i3.VocabularyPracticeSentenceIndexPage]
class VocabularyPracticeSentenceIndexRoute extends _i22.PageRouteInfo<void> {
  const VocabularyPracticeSentenceIndexRoute()
      : super(VocabularyPracticeSentenceIndexRoute.name,
            path: '/voabulary_practice_sentence_index');

  static const String name = 'VocabularyPracticeSentenceIndexRoute';
}

/// generated route for
/// [_i4.VocabularyPracticeSentenceLearnAutoPage]
class VocabularyPracticeSentenceLearnAutoRoute
    extends _i22.PageRouteInfo<VocabularyPracticeSentenceLearnAutoRouteArgs> {
  VocabularyPracticeSentenceLearnAutoRoute(
      {_i23.Key? key,
      String topicClass = '',
      String topicName = '',
      List<int> sentencesIDData = const [],
      int quizID = 0,
      Map<String, dynamic> wordSet = const {
        'learningClassification': '',
        'learningPhase': ''
      }})
      : super(VocabularyPracticeSentenceLearnAutoRoute.name,
            path: '/voabulary_practice_sentence_auto',
            args: VocabularyPracticeSentenceLearnAutoRouteArgs(
                key: key,
                topicClass: topicClass,
                topicName: topicName,
                sentencesIDData: sentencesIDData,
                quizID: quizID,
                wordSet: wordSet));

  static const String name = 'VocabularyPracticeSentenceLearnAutoRoute';
}

class VocabularyPracticeSentenceLearnAutoRouteArgs {
  const VocabularyPracticeSentenceLearnAutoRouteArgs(
      {this.key,
      this.topicClass = '',
      this.topicName = '',
      this.sentencesIDData = const [],
      this.quizID = 0,
      this.wordSet = const {
        'learningClassification': '',
        'learningPhase': ''
      }});

  final _i23.Key? key;

  final String topicClass;

  final String topicName;

  final List<int> sentencesIDData;

  final int quizID;

  final Map<String, dynamic> wordSet;

  @override
  String toString() {
    return 'VocabularyPracticeSentenceLearnAutoRouteArgs{key: $key, topicClass: $topicClass, topicName: $topicName, sentencesIDData: $sentencesIDData, quizID: $quizID, wordSet: $wordSet}';
  }
}

/// generated route for
/// [_i5.VocabularyPracticeSentenceLearnManualPage]
class VocabularyPracticeSentenceLearnManualRoute
    extends _i22.PageRouteInfo<VocabularyPracticeSentenceLearnManualRouteArgs> {
  VocabularyPracticeSentenceLearnManualRoute(
      {_i23.Key? key, String topicClass = '', String topicName = ''})
      : super(VocabularyPracticeSentenceLearnManualRoute.name,
            path: '/voabulary_practice_sentence_manual',
            args: VocabularyPracticeSentenceLearnManualRouteArgs(
                key: key, topicClass: topicClass, topicName: topicName));

  static const String name = 'VocabularyPracticeSentenceLearnManualRoute';
}

class VocabularyPracticeSentenceLearnManualRouteArgs {
  const VocabularyPracticeSentenceLearnManualRouteArgs(
      {this.key, this.topicClass = '', this.topicName = ''});

  final _i23.Key? key;

  final String topicClass;

  final String topicName;

  @override
  String toString() {
    return 'VocabularyPracticeSentenceLearnManualRouteArgs{key: $key, topicClass: $topicClass, topicName: $topicName}';
  }
}

/// generated route for
/// [_i6.VocabularyPracticeWordIndexPage]
class VocabularyPracticeWordIndexRoute extends _i22.PageRouteInfo<void> {
  const VocabularyPracticeWordIndexRoute()
      : super(VocabularyPracticeWordIndexRoute.name,
            path: '/voabulary_practice_word_index');

  static const String name = 'VocabularyPracticeWordIndexRoute';
}

/// generated route for
/// [_i7.VocabularyPracticeWordListPage]
class VocabularyPracticeWordListRoute
    extends _i22.PageRouteInfo<VocabularyPracticeWordListRouteArgs> {
  VocabularyPracticeWordListRoute(
      {_i23.Key? key, required List<dynamic> vocabularyList})
      : super(VocabularyPracticeWordListRoute.name,
            path: '/voabulary_practice_word_list',
            args: VocabularyPracticeWordListRouteArgs(
                key: key, vocabularyList: vocabularyList));

  static const String name = 'VocabularyPracticeWordListRoute';
}

class VocabularyPracticeWordListRouteArgs {
  const VocabularyPracticeWordListRouteArgs(
      {this.key, required this.vocabularyList});

  final _i23.Key? key;

  final List<dynamic> vocabularyList;

  @override
  String toString() {
    return 'VocabularyPracticeWordListRouteArgs{key: $key, vocabularyList: $vocabularyList}';
  }
}

/// generated route for
/// [_i8.VocabularyPracticeWordLearnAutoPage]
class VocabularyPracticeWordLearnAutoRoute
    extends _i22.PageRouteInfo<VocabularyPracticeWordLearnAutoRouteArgs> {
  VocabularyPracticeWordLearnAutoRoute(
      {_i23.Key? key, required List<dynamic> wordRankingList})
      : super(VocabularyPracticeWordLearnAutoRoute.name,
            path: '/voabulary_practice_word_auto',
            args: VocabularyPracticeWordLearnAutoRouteArgs(
                key: key, wordRankingList: wordRankingList));

  static const String name = 'VocabularyPracticeWordLearnAutoRoute';
}

class VocabularyPracticeWordLearnAutoRouteArgs {
  const VocabularyPracticeWordLearnAutoRouteArgs(
      {this.key, required this.wordRankingList});

  final _i23.Key? key;

  final List<dynamic> wordRankingList;

  @override
  String toString() {
    return 'VocabularyPracticeWordLearnAutoRouteArgs{key: $key, wordRankingList: $wordRankingList}';
  }
}

/// generated route for
/// [_i9.VocabularyPracticeWordLearnManualPage]
class VocabularyPracticeWordLearnManualRoute
    extends _i22.PageRouteInfo<VocabularyPracticeWordLearnManualRouteArgs> {
  VocabularyPracticeWordLearnManualRoute({_i23.Key? key, required String word})
      : super(VocabularyPracticeWordLearnManualRoute.name,
            path: '/voabulary_practice_word_manual',
            args: VocabularyPracticeWordLearnManualRouteArgs(
                key: key, word: word));

  static const String name = 'VocabularyPracticeWordLearnManualRoute';
}

class VocabularyPracticeWordLearnManualRouteArgs {
  const VocabularyPracticeWordLearnManualRouteArgs(
      {this.key, required this.word});

  final _i23.Key? key;

  final String word;

  @override
  String toString() {
    return 'VocabularyPracticeWordLearnManualRouteArgs{key: $key, word: $word}';
  }
}

/// generated route for
/// [_i10.MinimalPairIndexPage]
class MinimalPairIndexRoute extends _i22.PageRouteInfo<void> {
  const MinimalPairIndexRoute()
      : super(MinimalPairIndexRoute.name, path: '/minimal_pair_index');

  static const String name = 'MinimalPairIndexRoute';
}

/// generated route for
/// [_i11.MinimalPairLearnAutoPage]
class MinimalPairLearnAutoRoute
    extends _i22.PageRouteInfo<MinimalPairLearnAutoRouteArgs> {
  MinimalPairLearnAutoRoute(
      {_i23.Key? key, String IPA1 = '', String IPA2 = '', String word = ''})
      : super(MinimalPairLearnAutoRoute.name,
            path: '/minimal_pair_auto',
            args: MinimalPairLearnAutoRouteArgs(
                key: key, IPA1: IPA1, IPA2: IPA2, word: word));

  static const String name = 'MinimalPairLearnAutoRoute';
}

class MinimalPairLearnAutoRouteArgs {
  const MinimalPairLearnAutoRouteArgs(
      {this.key, this.IPA1 = '', this.IPA2 = '', this.word = ''});

  final _i23.Key? key;

  final String IPA1;

  final String IPA2;

  final String word;

  @override
  String toString() {
    return 'MinimalPairLearnAutoRouteArgs{key: $key, IPA1: $IPA1, IPA2: $IPA2, word: $word}';
  }
}

/// generated route for
/// [_i12.MinimalPairLearnManualPage]
class MinimalPairLearnManualRoute
    extends _i22.PageRouteInfo<MinimalPairLearnManualRouteArgs> {
  MinimalPairLearnManualRoute(
      {_i23.Key? key, String IPA1 = '', String IPA2 = '', String word = ''})
      : super(MinimalPairLearnManualRoute.name,
            path: '/minimal_pair_manual',
            args: MinimalPairLearnManualRouteArgs(
                key: key, IPA1: IPA1, IPA2: IPA2, word: word));

  static const String name = 'MinimalPairLearnManualRoute';
}

class MinimalPairLearnManualRouteArgs {
  const MinimalPairLearnManualRouteArgs(
      {this.key, this.IPA1 = '', this.IPA2 = '', this.word = ''});

  final _i23.Key? key;

  final String IPA1;

  final String IPA2;

  final String word;

  @override
  String toString() {
    return 'MinimalPairLearnManualRouteArgs{key: $key, IPA1: $IPA1, IPA2: $IPA2, word: $word}';
  }
}

/// generated route for
/// [_i13.CustomArticlePracticeSentenceIndexPage]
class CustomArticlePracticeSentenceIndexRoute extends _i22.PageRouteInfo<void> {
  const CustomArticlePracticeSentenceIndexRoute()
      : super(CustomArticlePracticeSentenceIndexRoute.name,
            path: '/customArticle_practice_sentence_index');

  static const String name = 'CustomArticlePracticeSentenceIndexRoute';
}

/// generated route for
/// [_i14.CustomArticlePracticeSentenceLearnAutoPage]
class CustomArticlePracticeSentenceLearnAutoRoute extends _i22
    .PageRouteInfo<CustomArticlePracticeSentenceLearnAutoRouteArgs> {
  CustomArticlePracticeSentenceLearnAutoRoute(
      {_i23.Key? key, required List<dynamic> questionList})
      : super(CustomArticlePracticeSentenceLearnAutoRoute.name,
            path: '/customArticle_practice_sentence_auto',
            args: CustomArticlePracticeSentenceLearnAutoRouteArgs(
                key: key, questionList: questionList));

  static const String name = 'CustomArticlePracticeSentenceLearnAutoRoute';
}

class CustomArticlePracticeSentenceLearnAutoRouteArgs {
  const CustomArticlePracticeSentenceLearnAutoRouteArgs(
      {this.key, required this.questionList});

  final _i23.Key? key;

  final List<dynamic> questionList;

  @override
  String toString() {
    return 'CustomArticlePracticeSentenceLearnAutoRouteArgs{key: $key, questionList: $questionList}';
  }
}

/// generated route for
/// [_i15.CustomArticlePracticeSentenceLearnManualPage]
class CustomArticlePracticeSentenceLearnManualRoute extends _i22
    .PageRouteInfo<CustomArticlePracticeSentenceLearnManualRouteArgs> {
  CustomArticlePracticeSentenceLearnManualRoute(
      {_i23.Key? key,
      required List<dynamic> questionList,
      required List<dynamic> questionIPAList})
      : super(CustomArticlePracticeSentenceLearnManualRoute.name,
            path: '/customArticle_practice_sentence_manual',
            args: CustomArticlePracticeSentenceLearnManualRouteArgs(
                key: key,
                questionList: questionList,
                questionIPAList: questionIPAList));

  static const String name = 'CustomArticlePracticeSentenceLearnManualRoute';
}

class CustomArticlePracticeSentenceLearnManualRouteArgs {
  const CustomArticlePracticeSentenceLearnManualRouteArgs(
      {this.key, required this.questionList, required this.questionIPAList});

  final _i23.Key? key;

  final List<dynamic> questionList;

  final List<dynamic> questionIPAList;

  @override
  String toString() {
    return 'CustomArticlePracticeSentenceLearnManualRouteArgs{key: $key, questionList: $questionList, questionIPAList: $questionIPAList}';
  }
}

/// generated route for
/// [_i16.LearningAutoGenericPage]
class LearningAutoGenericRoute
    extends _i22.PageRouteInfo<LearningAutoGenericRouteArgs> {
  LearningAutoGenericRoute(
      {_i23.Key? key,
      required List<String> contentList,
      required List<String> ipaList,
      required List<String> translateList})
      : super(LearningAutoGenericRoute.name,
            path: '/learnig_auto_generic',
            args: LearningAutoGenericRouteArgs(
                key: key,
                contentList: contentList,
                ipaList: ipaList,
                translateList: translateList));

  static const String name = 'LearningAutoGenericRoute';
}

class LearningAutoGenericRouteArgs {
  const LearningAutoGenericRouteArgs(
      {this.key,
      required this.contentList,
      required this.ipaList,
      required this.translateList});

  final _i23.Key? key;

  final List<String> contentList;

  final List<String> ipaList;

  final List<String> translateList;

  @override
  String toString() {
    return 'LearningAutoGenericRouteArgs{key: $key, contentList: $contentList, ipaList: $ipaList, translateList: $translateList}';
  }
}

/// generated route for
/// [_i17.LearningManualVocabularyPraticeWordPage]
class LearningManualVocabularyPraticeWordRoute
    extends _i22.PageRouteInfo<LearningManualVocabularyPraticeWordRouteArgs> {
  LearningManualVocabularyPraticeWordRoute(
      {_i23.Key? key,
      required List<dynamic> vocabularyList,
      required List<dynamic> vocabularySentenceList})
      : super(LearningManualVocabularyPraticeWordRoute.name,
            path: '/learning_manual_vocabulary_practice_word',
            args: LearningManualVocabularyPraticeWordRouteArgs(
                key: key,
                vocabularyList: vocabularyList,
                vocabularySentenceList: vocabularySentenceList));

  static const String name = 'LearningManualVocabularyPraticeWordRoute';
}

class LearningManualVocabularyPraticeWordRouteArgs {
  const LearningManualVocabularyPraticeWordRouteArgs(
      {this.key,
      required this.vocabularyList,
      required this.vocabularySentenceList});

  final _i23.Key? key;

  final List<dynamic> vocabularyList;

  final List<dynamic> vocabularySentenceList;

  @override
  String toString() {
    return 'LearningManualVocabularyPraticeWordRouteArgs{key: $key, vocabularyList: $vocabularyList, vocabularySentenceList: $vocabularySentenceList}';
  }
}

/// generated route for
/// [_i18.IndexVocabularyTestLevelSelectPage]
class IndexVocabularyTestLevelSelectRoute extends _i22.PageRouteInfo<void> {
  const IndexVocabularyTestLevelSelectRoute()
      : super(IndexVocabularyTestLevelSelectRoute.name,
            path: '/vocabulary_test_select_level');

  static const String name = 'IndexVocabularyTestLevelSelectRoute';
}

/// generated route for
/// [_i19.IndexVocabularyTestQuestingPage]
class IndexVocabularyTestQuestingRoute extends _i22.PageRouteInfo<void> {
  const IndexVocabularyTestQuestingRoute()
      : super(IndexVocabularyTestQuestingRoute.name,
            path: '/vocabulary_test_questing');

  static const String name = 'IndexVocabularyTestQuestingRoute';
}

/// generated route for
/// [_i20.GrammarCorrectionMainPage]
class GrammarCorrectionMainRoute extends _i22.PageRouteInfo<void> {
  const GrammarCorrectionMainRoute()
      : super(GrammarCorrectionMainRoute.name,
            path: '/grammar_correction_main_page');

  static const String name = 'GrammarCorrectionMainRoute';
}

/// generated route for
/// [_i21.IndexLearnRecordIndexPage]
class IndexLearnRecordIndexRoute extends _i22.PageRouteInfo<void> {
  const IndexLearnRecordIndexRoute()
      : super(IndexLearnRecordIndexRoute.name,
            path: '/vocabulary_record_index_page');

  static const String name = 'IndexLearnRecordIndexRoute';
}
