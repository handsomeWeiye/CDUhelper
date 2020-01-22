import 'package:flutter/material.dart';
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
    //使用正则表达式或者是使用html，这个库类似于joup
    // RegExp reg = RegExp(r"\w{19}\+\w{27}");
    // Match match = reg.firstMatch(response.data);

    //然后使用html进行数据得的解析
    Document document = parse(data); //获得了dom树
    getParm(document); //获取了基本的学生信息

    //  var viewstateTag = document.getElementsByTagName("input")[2];
    //  print(viewstateTag);

    // var a  = document.getElementById("Table1").text.toString();
    // // print(a);

    List<Map> _list3 = [];
    Map<String, dynamic> _data = {};

    //获取了所有的课程信息
    var trs = document.getElementsByTagName("tr");
    // for (int i = 0; i < trs.length; i++){
    //   if (i == 4 || i == 6 || i == 8 || i == 10 || i == 12 || i == 16) {
    //     print(trs[i].text.toString());
    //     for (int j = 1; j <= 7; j++) {
    //       if(j>2){
    //         print(j);
    //       }else{
    //         print('小于等于2');
    //       }
    //     }
    //   }
    // }
    //把课程信息的每一行进行遍历


      String parmer(String msg,String reg,int index){
      RegExp regExp = RegExp(reg);
      var match = regExp.allMatches(msg);
      List<RegExpMatch> _list = [];
      match.forEach((f) => {_list.add(f)});
      var result = _list[index].group(0).toString();
      print(result);
      print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
      return result;
    }
    for (int i = 0; i < trs.length; i++) {
      print(i);
      //如果是有课程信息的特定行，那么就进行列操作
      if (i == 4 || i == 6 || i == 8 || i == 10 || i == 12 || i == 16) {
        print(trs[i].text.toString());
        //在本行里找出所有的列元素
        var tds = trs[i].getElementsByTagName("td");
        // print('$i' +
        //     '?????????????????????????????????????????????????????aaaaa');
        //把特定行的首个元素进行清理，便于之后的数据分析
        if (i == 4 || i == 8 || i == 12) {
          //先清除显示上午、下午、晚上的一行
          tds.removeAt(0);
          // print('$i' + '?????????????????????????????????????????????????????');
        }

        //遍历行中的每一列，进行数据分析
        for (int j = 1; j <= 7; j++) {
          // print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
          //开始处理某一个点位的字符数据
          String mag = tds[j].text;
          // print(mag.toString());

          //使用正则表达式匹配 这个模块出现了几次周* 得到应该循环几次
          RegExp timesRugular = RegExp(r'周[\u4e00-\u9fa5]');
          var match6 = timesRugular.allMatches(mag); //找到匹配到的第一个字符
          // print(match6.length);


          if (match6.length > 1) {
            for (int k = 0; k < match6.length; k++) {
              
              parmer(mag,r"[\u4e00-\u9fa5]{2,15}(?=周)",k);
              //使用正则表达式匹配课程的名称
              RegExp coursesNameReg =
                  RegExp(r"[\u4e00-\u9fa5]{2,15}(?=周)"); //匹配周字之前的中文字符
              var match = coursesNameReg.allMatches(mag); //找到匹配到的第一个字符
              List<RegExpMatch> _list = [];
              match.forEach((f) => {_list.add(f)});
              var data2 = _list[k].group(0).toString();
              print(data2);
              _data['coursesName'] = data2;

              //使用正则表达式匹配该课程所在的时间索引
              RegExp coursesIndex = RegExp(r'\d.{2,5}(?=节)');
              match = coursesIndex.allMatches(mag); //找到匹配到的第一个字符
              _list = [];
              match.forEach((f) => {_list.add(f)});
              var match2 = _list[k].group(0).toString();
              List<String> _list1 = match2.split(',');
              _data['coursesIndex'] = _list1;

              //使用正则表达式匹配该课程所在的周数
              RegExp coursesWeeks = RegExp(r'\d{1,2}-\d{1,2}');
              var match3 = coursesWeeks.allMatches(mag); //找到匹配到的第一个字符
              _list = [];
              match3.forEach((f) => _list.add(f));
              var data1 = _list[k].group(0).toString();
              List<int> _weeks = [];
              var data = data1.split('-');
              for (int l = int.parse(data[0]); l <= int.parse(data[1]); l++) {
                _weeks.add(l);
              }
              print(_weeks);
              _data['coursesWeeks'] = _weeks;

              //使用正则表达式匹配该课程所在的教室
              RegExp coursesRoom = RegExp(r'\d{4}');
              var match4 = coursesRoom.allMatches(mag); //找到匹配到的第一个字符
              _list = [];
              match4.forEach((f) => _list.add(f));
              data1 = _list[k].group(0).toString();
              print(data1);
              _data['coursesRoom'] = data1;

              //使用正则表达式匹配该课程的老师姓名
              RegExp coursesTeacher = RegExp(r'[\u4e00-\u9fa5]{2,3}(?=\d{4})');
              var match5 = coursesTeacher.allMatches(mag); //找到匹配到的第一个字符
              _list = [];
              match5.forEach((f) => _list.add(f));
              data1 = _list[k].group(0).toString();
              print(data1);
              _data['coursesTeacher'] = data1;

              //使用正则表达式匹配该课程所在的天
              RegExp coursesDay = RegExp(r'周[\u4e00-\u9fa5]');
              var match7 = coursesDay.allMatches(mag); //找到匹配到的第一个字符
              _list = [];
              match7.forEach((f) => _list.add(f));
              data1 = _list[k].group(0).toString();
              print(data1);
              _data['coursesDay'] = data1;

              print(_data);
              _list3.add(_data);
            }
            // print('ccccccccccccccccccccccccccccccc');
          } else {
            // print('dddddddddddddddddddddddddddddddddddddd');
            //使用正则表达式匹配课程的名称
            RegExp coursesNameReg = RegExp(".{2,15}(?=周)"); //匹配周字之前的中文字符
            var match = coursesNameReg.firstMatch(mag); //找到匹配到的第一个字符
            print(match.group(0).toString()); //将其转化为字符串
            _data['coursesName'] = match.group(0).toString();

            //使用正则表达式匹配该课程所在的时间索引
            RegExp coursesIndex = RegExp(r'\d.{2,5}(?=节)');
            var match1 = coursesIndex.firstMatch(mag); //找到匹配到的第一个字符
            var match2 = match1.group(0).toString(); //将其1,2转化为数字，并且保存在列表中
            //将字符串转化为列表的形式
            // print(match2);
            List<String> _list = match2.split(',');
            print(_list);
            _data['coursesIndex'] = _list;

            //使用正则表达式匹配该课程所在的周数
            RegExp coursesWeeks = RegExp(r'\d{1,2}-\d{1,2}');
            var match3 =
                coursesWeeks.firstMatch(mag).group(0).toString(); //找到匹配到的第一个字符
            List<int> _weeks = [];
            var data = match3.split('-');
            for (int i = int.parse(data[0]); i <= int.parse(data[1]); i++) {
              _weeks.add(i);
            }
            print(_weeks);
            _data['coursesWeeks'] = _weeks;

            // print(match3);
            //使用正则表达式匹配该课程所在的教室
            RegExp coursesRoom = RegExp(r'\d{4}');
            var match4 =
                coursesRoom.firstMatch(mag).group(0).toString(); //找到匹配到的第一个字符
            print(match4);
            _data['coursesRoom'] = match4;

            //使用正则表达式匹配该课程的老师姓名
            RegExp coursesTeacher = RegExp(r'[\u4e00-\u9fa5]{2,3}(?=\d{4})');
            var match5 = coursesTeacher
                .firstMatch(mag)
                .group(0)
                .toString(); //找到匹配到的第一个字符
            print(match5);
            _data['coursesTeacher'] = match5;
            //使用正则表达式匹配该课程所在的天
            RegExp coursesDay = RegExp(r'周[\u4e00-\u9fa5]');
            var match7 =
                coursesDay.firstMatch(mag).group(0).toString(); //找到匹配到的第一个字符
            print(match7);
            _data['coursesTeacher'] = match7;

            _list3.add(_data);
            // print('bbbbbbbbbbbbbbbbbbbbbbbbbb------------------------------------------');
          }
          break;
          // print('77777777777777777777777777');
        }
      }

    }
  notifyListeners();
  return _list3;
  }
  

}
