
import 'package:cdu_helper/pages/confirm_sms_page.dart';
import 'package:cdu_helper/pages/home_page.dart';
import 'package:cdu_helper/routers/routers.dart';
import 'package:data_plugin/bmob/bmob.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
// import 'package:cdu_helper/provides/login_page_provide.dart';
import 'package:provide/provide.dart';
import 'package:oktoast/oktoast.dart';
import 'routers/application.dart';
// import 'package:cdu_helper/provides/courses_page_provide.dart';
import 'package:cdu_helper/provides/courses1_page_provider.dart';
import 'package:cdu_helper/provides/scores_page_provide.dart';
import 'provides/credit_page_provide.dart';
import 'package:cdu_helper/provides/exam_page_provide.dart';
import 'package:cdu_helper/pages/login_test_page.dart';
import 'package:cdu_helper/pages/splash_page.dart';
import 'package:cdu_helper/provides/login_test_page_provide.dart';
import 'pages/set_password_page.dart';
import 'pages/login_password_page.dart';
import 'pages/impresve_information_page.dart';
import 'pages/people_test_page.dart';
import 'provides/home_page_provide.dart';

void main(){
    final router = Router();
    Routes.configureRoutes(router);
    Application.router = router;

  var coursesPageProvide = CoursesPageProvide();
  var provides = Providers();
  // var loginPageProvide = LoginPageProvide();
  var scoresPageProvide = ScoresPageProvide();
  var creditPageProvide = CreditPageProvide();
  var examPageProvide = ExamPageProvide();
  var homePageProvide = HomePageProvide();
  var loginTestPageProvide = LoginTestPageProvide();

  provides
    // ..provide(Provider<LoginPageProvide>.value(loginPageProvide))
    ..provide(Provider<CreditPageProvide>.value(creditPageProvide))
    ..provide(Provider<ScoresPageProvide>.value(scoresPageProvide))
    ..provide(Provider<ExamPageProvide>.value(examPageProvide))
    ..provide(Provider<LoginTestPageProvide>.value(loginTestPageProvide))
    ..provide(Provider<HomePageProvide>.value(homePageProvide))
    ..provide(Provider<CoursesPageProvide>.value(coursesPageProvide));


  runApp(ProviderNode(
    child: MyApp(),
    providers: provides,
  ));
}

class MyApp extends StatelessWidget {

  
  @override
  Widget build(BuildContext context) {
    // Bmob.initMasterKey("160a9b19cb9a1bedce5c0f48d2fd8ce5",
    //     "63e64b5539026cfe34ac1f38542cda9e", "7a8a42dd90fd20a307fa330b99153dcf");

    return OKToast(
      child: MaterialApp(
      title: 'Flutter Demo',
      onGenerateRoute: Application.router.generator,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    ),
    );
  }
}

