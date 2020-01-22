import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:gbk2utf8/gbk2utf8.dart';
import 'package:html/parser.dart';

class HomePageProvide with ChangeNotifier{
  Map<String, String> header = {
    'X-Bmob-Application-Id':'160a9b19cb9a1bedce5c0f48d2fd8ce5',
    'X-Bmob-REST-API-Key':'63e64b5539026cfe34ac1f38542cda9e',
    'Content-Type':'application/json'
  };
  Dio dio = Dio();
  Response response;

  String swiperApi = 'https://api2.bmob.cn/1/classes/swiper';
  String categoryApi = 'https://api2.bmob.cn/1/classes/category';
  String thingDateApi = 'https://api2.bmob.cn/1/classes/thingDate'+ '?'+'order=thingDate';


   void initConfig() async {
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.findProxy = (uri) => "PROXY 192.168.1.9:8888";
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return true;
      };
    };
  }

    getSwiperData()async{
      response = await dio.get(swiperApi,options: Options(headers: header));
      return response;
    }

    
    getCategoryData()async{
      response = await dio.get(categoryApi,options: Options(headers: header));
      return response;
    }

      getThingDate()async{
      response = await dio.get(thingDateApi,options: Options(headers: header));
      return response;
    }


}