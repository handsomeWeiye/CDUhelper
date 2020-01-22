import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import './router_handler.dart';


class Routes {
  static String root = '/';
  static String applicationPage = '/applications';
  static String coursesPage = '/courses';
  static String scoresPage = '/scores';
  static String creditPage = '/credit';
  static String examPage = '/exam';

  static void configureRoutes(Router route){
    route.notFoundHandler  = Handler(
      handlerFunc: (BuildContext context, Map<String,List<String>> parmars){
        print('ERROR===>Route Was Not Found!!!!!');
      }
    );

    route.define(applicationPage,handler: applicationsHanderl);
    route.define(coursesPage,handler: coursesHanderl);
    route.define(scoresPage,handler: scoresHanderl);
    route.define(creditPage,handler: creditHanderl);
    route.define(examPage,handler: examHanderl);
  }

}