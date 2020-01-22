import '../routers/application.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPageProvide with ChangeNotifier {
  //是否会跳转
  bool isNavigate = false;

  //模拟登录需要请求的地址
  String mainurl = 'http://202.115.80.211/default2.aspx';
  String checkCodeUrl = 'http://202.115.80.211/CheckCode.aspx';
  String relodaCheckCodeUrl = 'http://202.115.80.211/CheckCode.aspx';
  String dataUrl = 'http://202.115.80.211/xskbcx.aspx';

  //请求头所需要的信息
  Map<String, String> header = {
    "User-Agent":
        "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.110 Safari/537.36",
  };

  String cookies;
  String userName;


  //实例化的dio与response,用于网络请求的工具
  Response response;
  Dio dio = Dio();
  

  //存放验证码图片数据
  List<int> checkCodeData;

  //post的时候所发送的表单

  Map postData = {
    '__VIEWSTATE': 'dDwxNTMxMDk5Mzc0Ozs+7tXmnHrwzlX3uyv66Sau12KSpko=',
    'txtUserName': '',
    'Textbox1': '',
    'TextBox2': '',
    'txtSecretCode': '',
    'RadioButtonList1': r'\xd1\xa7\xc9\xfa',
    'Button1': '',
    'lbLanguage': '',
    'hidPdrs': '',
    'hidsc': ''
  };

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

  //使用sharedPreferences进行登录信息的持久化
   getCookiesAndCheckCode() async {
    //获取cookies 构造有cookies的请求头
    dio.options.headers = header;
    // dio.interceptors.add(CookieManager(CookieJar()));
    response = await dio.get(mainurl);
    // print(response.headers.value("set-cookie"));
    cookies = response.headers.value("set-cookie").substring(18, 42);
    print(cookies);
    cookies = "ASP.NET_SessionId=" + cookies;
    header["Cookie"] = cookies;

    //获取所需要的验证码图片
    dio.options.responseType = ResponseType.bytes;
    dio.options.headers = header;
    response = await dio.get(checkCodeUrl);
    checkCodeData = response.data as List<int>;
    notifyListeners();
  }

   reloadCheackCode() async {
    relodaCheckCodeUrl = checkCodeUrl + '?';
    dio.options.headers = header;
    dio.options.responseType = ResponseType.bytes;
    response = await dio.get(relodaCheckCodeUrl);
    checkCodeData = response.data as List<int>;
    notifyListeners();
  }

  saveConfigInfo () async{
     //使用sharedPreferences进行登录信息的持久化
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // String loginInfo = preferences.getString('loginInfo');//查询出的是一个数据表，LIst<Map>map是一行，list就是一行一行的所有
    // var temp = loginInfo==null?[]:json.decode(loginInfo.toString());//初始化一下，如果查不到，那就为空列表，如果能够查到，那就解码填入；
    // List<Map>tempList = (temp as List).cast();//然后彻底将其转化一个List<Map>类型的数组

    //使用很简单的setstring，将有价值的值存储
    preferences.setString('cookies', header["Cookie"]);
    preferences.setString('userAgent', header["User-Agent"]);
    preferences.setString('userName', postData['txtUserName']);
    preferences.setString('password', postData['TextBox2']);
    preferences.setString('viewState1', postData["__VIEWSTATE"]);
    //测试prederrnce的运行情况
    // print(preferences.getString('cookies'));
    // print(preferences.getString('userAgent'));
    // print(preferences.getString('userName'));
    // print(preferences.getString('password'));
    // print(preferences.getString('viewState1'));
    
  }

   login(String id, String password, String checkCode,context) async {
    dio.options.contentType =
    ContentType.parse("application/x-www-form-urlencoded");
    postData['txtUserName'] = '201711533704';
    postData['TextBox2'] = '24351587uytr';
    postData['txtSecretCode'] = checkCode;
    response = await dio.post(mainurl, data: postData,options: Options(followRedirects: false,validateStatus: (status) { return status < 500; }));
    print(response.statusCode);


    if (response.statusCode == 302) {
      isNavigate = true;
      userName = postData['txtUserName'];
      dio.options.responseType = ResponseType.plain;
      header['referer'] = mainurl ;
      dio.options.headers = header;
      // response = await dio.get(mainurl + "?xh="+ userName);
      // print(response.statusCode);
      //用正则将网页中的名字解析出来，并且保存
      // RegExp reg = RegExp(r'<span id="xhxm">(.*?)</span></em>');
      // Match match = reg.firstMatch(response.data);
      // print(match);
      //把姓名的字符串保存下来
      // var name = match;
      //正则表达式提取 viewstate 
      // print(name);
      print('模拟登陆成功');
      //将学号复制给username变量，便于后面构造URL使用
      userName = postData['txtUserName'];
      //将用户的重要配置信息保存下来，便于今后的多次使用
      saveConfigInfo ();
      //访问课程，成绩页面的时候似乎要写姓名的gbk编码形式，经过测试，似乎可以不写，只够造有学号的就可以
      // var urll = dataUrl + "?xh=" + userName  +"&xm=&gnmkdm=" ;
      // header['referer'] = mainurl + "?xh="+ userName;
      // // print(header);
      // dio.options.headers = header;
      // print(urll);
      // dio.options.responseType = ResponseType.plain;
      // dio.interceptors.add(LogInterceptor(requestBody: true));
      // response = await dio.get(urll);
      // print(response.data);
      Fluttertoast.showToast(msg: "登录成功");

 
      Application.router.navigateTo(context, 'applications');
      
    } else {
      Fluttertoast.showToast(msg: "您输入的信息有误，记得再检查一遍呦");
      reloadCheackCode();
    }
    notifyListeners();
  }
}
