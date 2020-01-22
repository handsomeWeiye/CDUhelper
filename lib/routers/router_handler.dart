import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:cdu_helper/pages/applications_page.dart';
import 'package:cdu_helper/pages/courses_page.dart';
import 'package:cdu_helper/pages/scores_page.dart';
import 'package:cdu_helper/pages/credit_page.dart';
import 'package:cdu_helper/pages/exam_page.dart';


Handler applicationsHanderl = Handler(
  handlerFunc: (BuildContext context ,Map<String,List<String>> params){
    return ApplicationsPage();
  }
);

Handler coursesHanderl = Handler(
  handlerFunc: (BuildContext context ,Map<String,List<String>> params){
    return CoursesPage();
  }


);

  Handler scoresHanderl = Handler(
  handlerFunc: (BuildContext context ,Map<String,List<String>> params){
    return ScoresPage();
  });

    Handler creditHanderl = Handler(
  handlerFunc: (BuildContext context ,Map<String,List<String>> params){
    return CreditPage();
  });
      Handler examHanderl = Handler(
  handlerFunc: (BuildContext context ,Map<String,List<String>> params){
    return ExamPage();
  });