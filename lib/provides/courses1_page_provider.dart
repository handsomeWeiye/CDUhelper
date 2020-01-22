import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:gbk2utf8/gbk2utf8.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

class CoursesPageProvide with ChangeNotifier {
  String dataUrl = 'http://202.115.80.211/xskbcx.aspx';
  String mainurl = 'http://202.115.80.211/default2.aspx';
  String queryUrl = '';
  String refererUrl = '';
  String cookies = '';
  String userAgent = '';
  String userName = '';
  Map<String, String> header = {};
  Dio dio = Dio();
  Response response;
  // List regList = [
  //   r"[\u4e00-\u9fa5]{2,15}.{0,3}(?=周)",r'\d.{2,5}(?=节)',r'\d{1,2}-\d{1,2}',r'单周|双周',r'(?<=[\u4e00-\u9fa5]{2,3})\w{0,1}\d{3,4}',r'[\u4e00-\u9fa5]{2,3}(?=\d{4})',r'周[\u4e00-\u9fa5]'
  // ];

  Future inits() async {
    //参数赋值初始化
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cookies = prefs.getString('cookies');
    userAgent = prefs.getString('userAgent');
    userName = prefs.getString('userName');
    queryUrl = dataUrl + "?xh=" + userName + "&xm=&gnmkdm=";
    refererUrl = mainurl + "?xh=" + userName;
    header['referer'] = refererUrl;
    header["User-Agent"] = userAgent;
    header["Cookie"] = cookies;
    notifyListeners();
  }

  //获取学生的信息，然后存储到SharedPreferences里
  void getParm(Document document) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var studentNumber =
        document.getElementById("Label5").text.toString().substring(3);
    var studentName =
        document.getElementById("Label6").text.toString().substring(3);
    var collegeName =
        document.getElementById("Label7").text.toString().substring(3);
    var major = document.getElementById("Label8").text.toString().substring(3);
    var studentsClass =
        document.getElementById("Label9").text.toString().substring(3);
    prefs.setString('studentNumber', studentNumber);
    prefs.setString('studentName', studentName);
    prefs.setString('collegeName', collegeName);
    prefs.setString('major', major);
    prefs.setString('studentsClass', studentsClass);
  }

  String parmer(String msg, String reg, int index) {
    RegExp regExp = RegExp(reg);
    var match = regExp.allMatches(msg);
    List<RegExpMatch> _list = [];
    match.forEach((f) => {_list.add(f)});
    if (_list.length != 0) {
      var data = _list[index].group(0).toString();
      // print(data);
      return data;
    }
  }

  Future getCoursesData() async {
    //参数赋值初始化
    // dio.interceptors.add(LogInterceptor(requestBody: true));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cookies = prefs.getString('cookies');
    userAgent = prefs.getString('userAgent');
    userName = prefs.getString('userName');
    queryUrl = dataUrl + "?xh=" + userName + "&xm=&gnmkdm=";
    refererUrl = mainurl + "?xh=" + userName;
    header['referer'] = refererUrl;
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

    //把请求到的信息解析出来，准备存储数据
    String data = gbk.decode(response.data);

    Document document = parse(data); //获得了dom树
    getParm(document); //获取了基本的学生信息
    List<Map> _list = [];
    Map<String, dynamic> _data = {};

    var trs = document.getElementsByTagName("tr");
    for (int i = 0; i < trs.length; i++) {
      if (i == 4 || i == 6 || i == 8 || i == 10 || i == 12) {
        var tds = trs[i].getElementsByTagName("td");
        if (i == 4 || i == 8 || i == 12) {
          tds.removeAt(0);
        }
        for (int j = 1; j <= 7; j++) {
          String msg = tds[j].text;
          // print(msg);
          RegExp timesRugular = RegExp(r'周[\u4e00-\u9fa5]');
          var match = timesRugular.allMatches(msg); //找到匹配到的第一个字符
          for (int k = 0; k < match.length; k++) {
            String coursesName =
                parmer(msg, r"[\u4e00-\u9fa5]{2,15}.{0,3}(?=周)", k);
            String coursesIndex = parmer(msg, r'(?<=第).{2,8}(?=节)', k);
            String coursesWeeks = parmer(msg, r'\d{1,2}-\d{1,2}', k);
            String coursesSignlDoubleWeek = parmer(msg, r'单周|双周', k);
            String coursesRoom =
                parmer(msg, r'(?<=[\u4e00-\u9fa5]{2,3})\w{0,1}\d{3,4}', k);
            String coursesTeacher =
                parmer(msg, r'[\u4e00-\u9fa5]{2,3}(?=\d{4})', k);
            String coursesDay = parmer(msg, r'周[\u4e00-\u9fa5]', k);
            // print(coursesIndex);
            // if(coursesName == '绩效管理'){
            //   print(coursesName);
            //   print(coursesIndex);
            // }
            _data = {
              'coursesName': coursesName,
              'coursesIndex': coursesIndex,
              'coursesWeeks': coursesWeeks,
              "coursesSignlDoubleWeek": coursesSignlDoubleWeek,
              'coursesRoom': coursesRoom,
              'coursesTeacher': coursesTeacher,
              'coursesDay': coursesDay,
            };
            _list.add(_data);
          }
        }
      }
    }

    //将索引和星期转化为数组，便于之后的遍历
    for (int i = 0; i < _list.length; i++) {
      //处理棘手的单双周
      var a = _list[i]["coursesWeeks"];
      List<int> _weeks = [];
      var data = a.split('-');
      for (int l = int.parse(data[0]); l <= int.parse(data[1]); l++) {
        _weeks.add(l);
      }
      
      //条件判断，如果它有单周的属性，那么进行处理，此外如果是双周的属性，那么进行如下处理，在此外，不处理，直接赋值
    void _changeSignalDouble(){
        if(_list[i]["coursesSignlDoubleWeek"] == "单周"){
        List<int> list2 = [];
        int index ;

        for(int f = 0 ;f<_weeks.length;f ++){
          if(_weeks[f]%2 == 0){
            // print(_weeks[f]);
            index = _weeks.indexOf(_weeks[f]);
            list2.add(index);
          }
        }
        for(int i=0 ;i<list2.length;i++){
          _weeks.removeAt(i+1);
        }
      } else if(_list[i]["coursesSignlDoubleWeek"] == "双周"){
        List<int> list2 = [];
        int index ;

        for(int f = 0 ;f<_weeks.length;f ++){
          if(_weeks[f]%2 != 0){
            // print(_weeks[f]);
            index = _weeks.indexOf(_weeks[f]);
            list2.add(index);
          }
        }
        for(int i=0 ;i<list2.length;i++){
          _weeks.removeAt(i+1);
        }
      }

    }

    _changeSignalDouble();

      _list[i]["coursesWeeks"] = _weeks;

      var b = _list[i]["coursesIndex"];
      List<int> indexs = [];
      List<String> data1 = b.split(',');
      data1.forEach((f){
        indexs.add(int.parse(f));
      });
      _list[i]["coursesIndex"] =indexs;

    }

    // print(_list);
    return _list;
  }
}
