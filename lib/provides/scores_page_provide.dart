import 'package:html/dom.dart' as dom;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:gbk2utf8/gbk2utf8.dart';

import 'package:html/parser.dart';


class ScoresPageProvide with ChangeNotifier{


  String dataUrl = 'http://202.115.80.211/xscjcx.aspx';
  String mainurl = 'http://202.115.80.211/default2.aspx';
  String queryUrl = '';
  String refererUrl = '';
  String cookies = '';
  String userAgent = '';
  String userName = '';
  Map<String, String> header = {};
  Dio dio = Dio();
  Response response;
  List currentScoreData = [];


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



    Future getScoresData(schoolYear,term,) async {
    List<Map> scoresDataMapList = [];
    scoresDataMapList = [];
    // initConfig();
    //参数赋值初始化
    // dio.interceptors.add(LogInterceptor(requestBody: true));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cookies = prefs.getString('cookies');
    userAgent = prefs.getString('userAgent');
    userName = prefs.getString('userName');
    queryUrl = dataUrl + "?xh=" + userName + "&xm=&gnmkdm=";
    refererUrl = mainurl + "?xh=" + userName;
    header['referer'] = queryUrl;
    header["User-Agent"] = userAgent;
    header["Cookie"] = cookies;
    //使用dio，携带正确的请求头，请求体，响应体,请求正确的URL，获取课表的数据
    //首先配置请求头
    dio.options.contentType =
        ContentType.parse("application/x-www-form-urlencoded");
    dio.options.responseType = ResponseType.bytes;
    //安装请求头
    dio.options.headers = header;
    //发送获取课表的请求
    response = await dio.get(queryUrl);
    // print(response.data);
    //获取viewstate，在post请求数据的时候需要填写
    String data = gbk.decode(response.data);
    dom.Document document = parse(data);
    var viewstate = document.querySelector("input[name=__VIEWSTATE]").attributes['value'];
    // print(viewstate);
    Map formData = {
      '__EVENTTARGET':'',
      '__VIEWSTATE':viewstate,
      'ddlXN':schoolYear,
      '__EVENTARGUMENT':'',
      'hidLanguage':'',
      'ddlXQ':term,
      'ddl_kcxz':'',
      'btn_xn':'%D1%A7%C4%EA%B3%C9%BC%A8',
      term==''?'':'btn_xq': term==''?'':'%D1%A7%C6%DA%B3%C9%BC%A8'
    };

    response = await dio.post(queryUrl,data: formData);
    data = gbk.decode(response.data);
    document = parse(data);
    List<dom.Element> scoresData = document.getElementsByTagName("tr");
    scoresData.removeRange(0, 5);
    scoresData.removeRange(scoresData.length-7,scoresData.length);

    List _list = ['schoolYear','term','coursersCode','courseTitle','characteristics','courseBelonging','credit','point','grade','markMinor','make-upScore','ReconstructionResults','college','remark','RebuildTag'];
    
    for(int i = 0;i <scoresData.length;i++){
      List<dom.Element> list = scoresData[i].getElementsByTagName('td');
      Map<String,String> map = {};
      for (var i = 0; i < list.length; i++) {
        map[_list[i]] = list[i].text;
      }
      print(map);
      scoresDataMapList.add(map);
    }

    currentScoreData = scoresDataMapList; 
    notifyListeners();
    return currentScoreData;
    }


  

}