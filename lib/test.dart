// import 'dart:typed_data';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'dart:io';

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {

//   //三个输入框的控制器
//   TextEditingController idController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController checkCodeController = TextEditingController();

//   //模拟登录需要请求的地址
//   String mainurl = 'http://202.115.80.211/default2.aspx';
//   String checkCodeUrl = 'http://202.115.80.211/CheckCode.aspx';
//   String relodaCheckCodeUrl = 'http://202.115.80.211/CheckCode.aspx';

//   //模拟登录需要的请求头
//   Map<String, String> header = {
//     "User-Agent":
//         "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.110 Safari/537.36",
//   };

//   //cookies持久化
//   String cookies;

//   //实例化的dio与response
//   Response response;
//   Dio dio = Dio();


//   //存放验证码图片数据
//   List<int> checkCodeData;

  




//   //模拟登录所需要的初始化操作
//   //1.设置dio的代理便于抓包//以后可以去除
//   //2.获取cookies，并且实现cookies持久化，便于之后爬取所需要的数据
//   //3.以该cookies，请求所需要的验证码图片，并在生成模块中展现出来
//   @override
//   void initState() {
//     super.initState();
//     initConfig();
//     getCookiesAndCheckCode();
//   }



//   void initConfig() async {
//     (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
//         (HttpClient client) {
//       client.findProxy = (uri) => "PROXY 192.168.1.9:8888";
//       client.badCertificateCallback =
//           (X509Certificate cert, String host, int port) {
//         return true;
//       };
//     };
//   }



//   Future getCookiesAndCheckCode() async {
//     //获取cookies 构造有cookies的请求头
//     dio.options.headers = header;
//     // dio.interceptors.add(CookieManager(CookieJar()));
//     response = await dio.get(mainurl);
//     print(response.headers.value("set-cookie"));
//     cookies = response.headers.value("set-cookie").substring(18, 42);
//     print(cookies);
//     header["Cookie"] = "ASP.NET_SessionId=" + cookies;

//     //获取所需要的验证码图片
//     dio.options.responseType = ResponseType.bytes;
//     dio.options.headers = header;
//     response = await dio.get(checkCodeUrl);
//     var checkCode = response.data as List<int>;

//     //通知下方的生成模块的组件，刷新视图
//     setState(() {
//       checkCodeData = checkCode;
//     });
//   }

//   Future reloadCheackCode()async{
//     relodaCheckCodeUrl = checkCodeUrl + '?';
//     dio.options.headers = header;
//     dio.options.responseType = ResponseType.bytes;
//     response = await dio.get(relodaCheckCodeUrl);
//     var checkCode = response.data as List<int>;
//     setState(() {
//      checkCodeData = checkCode; 
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     //   //配置flutter全局代理
//     // void _getHttpData() async {
//     // var httpClient = new HttpClient();
//     // httpClient.findProxy = (url) {
//     //   return HttpClient.findProxyFromEnvironment(url, environment: {"http_proxy": 'http://192.168.1.9:8888',});
//     // };}

//     // _getHttpData();

//     //配置dio代

//     return Scaffold(
//         appBar: AppBar(
//           title: Text('登录正方系统'),
//         ),
//         body: Column(children: <Widget>[
//           TextField(
//             decoration: InputDecoration(
//               labelText: '学号',
//             ),
//             controller: idController,
//           ),
//           TextField(
//             decoration: InputDecoration(labelText: '密码'),
//             controller: passwordController,
//           ),
//           TextField(
//             decoration: InputDecoration(labelText: '验证码'),
//             controller: checkCodeController,
//           ),
//           InkWell(
//             child: (checkCodeData != null)?Image.memory(Uint8List.fromList(checkCodeData)):null,
//             onTap: (){
//               reloadCheackCode();
//             },
//           ),
//           RaisedButton(
//             onPressed: () async {
//               dio.options.contentType =
//                   ContentType.parse("application/x-www-form-urlencoded");
//               //构造登录使用的表单
//               Map postData = {
//                 '__VIEWSTATE':
//                     'dDwxNTMxMDk5Mzc0Ozs+7tXmnHrwzlX3uyv66Sau12KSpko=',
//                 'txtUserName': idController.text,
//                 'Textbox1': '',
//                 'TextBox2': passwordController.text,
//                 'txtSecretCode': checkCodeController.text,
//                 'RadioButtonList1': r'\xd1\xa7\xc9\xfa',
//                 'Button1': '',
//                 'lbLanguage': '',
//                 'hidPdrs': '',
//                 'hidsc': ''
//               };
//               response = await dio.post(mainurl, data: postData);
//               if (response.statusCode == 302){
//                 Fluttertoast.showToast(msg:"登录成功");
//               }
//             },
//             child: Text('登录'),
//           ),
//         ]));
//   }
// }


// // class HomePage extends StatefulWidget {
// //   @override
// //   _HomePageState createState() => _HomePageState();
// // }

// // class _HomePageState extends State<HomePage> {

// //   @override
// //   Widget build(BuildContext context) {

// //     Future getdata() async {
// //       String url = 'http://202.115.80.211/default2.aspx';
// //       Map<String, dynamic> header = {
// //         "User-Agent":
// //             "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.110 Safari/537.36",
// //       };
// //       Response response;
// //       Dio dio = Dio();
// //       // var cookieJar = CookieJar();
// //       // dio.interceptors.add(LogInterceptor());
// //       // dio.interceptors.add(CookieManager(cookieJar));
// //       // print(cookieJar.loadForRequest(Uri.parse(url)));
// //       dio.options.headers = header;
// //       response = await dio.get(url);
// //       //提取响应头中的cookies
// //       var cookies = response.headers.value("set-cookie").substring(18, 43);
// //       //正则表达式提取 viewstate 
// //       RegExp reg = RegExp(r"\w{19}\+\w{27}");
// //       Match match = reg.firstMatch(response.data);
// //       if (match != null){
// //         var viewstate = match.group(0);
// //       }


// //       //制造请求验证码的请求头
// //       header["Cookie"] = "ASP.NET_SessionId=" + cookies;
// //       print(header);
// //       dio.options.headers = header;
// //       response = await dio.get('http://202.115.80.211/CheckCode.aspx');
// //       print(response.data);

// //     }

    

// //     return Container(
// //       child: Scaffold(
// //         appBar: AppBar(
// //           title: Text('模拟登陆教务系统'),
// //         ),
// //         body: FutureBuilder(
// //           future: getdata(),
// //           builder: (BuildContext context, AsyncSnapshot snapshot) {
// //             return Center(
// //               child: Column(
// //                 children: <Widget>[
// //                   Text('${snapshot.data}')
// //                 ],
// //               ),
// //             );
// //           },
// //         ),
// //       ),
// //     );
// //   }
// // }


//   for (int i = 0; i < trs.size(); i++) {
//         //只需要处理行号为2（第一节）、4（第三节课）、6（第五节课）、8（第七节课）、10（第九节课）
//         if (i == 2 || i == 4 || i == 6 || i == 8 || i == 10) {
//             //得到显示第一节课的那一行
//             Element e1 = trs.get(i);
//             //得到所有的列
//             Elements tds = e1.getElementsByTag("td");
//             if (i==2||i==6||i==10){
//                 //先清除显示上午、下午、晚上的一行
//                 tds.remove(0);
//             }
//             tds.remove(0);
//             for (int j = 0; j < tds.size(); j++) {
//                 String msg = tds.get(j).text();
//                 //判断是否有课程
//                 if (msg.length() == 1) {
//                     //没有课程就跳过
//                     Log.i("xsx", "msg为空跳过");
//                     continue;
//                 }
//                 //处理一个td里的字符，如：计算机组成原理 2节/周(1-17) 张凤英 田师208
//                 String strings[] = msg.split(" ");
//                 //多少节
//                 int duringNum = Integer.parseInt(strings[1].substring(0, 1));
//                 int startNum = i-1;
//                 int endNum = startNum + duringNum - 1;
//                 String day = "";
//                 switch (j) {
//                     case 0:
//                         day = "星期一";
//                         break;
//                     case 1:
//                         day = "星期二";
//                         break;
//                     case 2:
//                         day = "星期三";
//                         break;
//                     case 3:
//                         day = "星期四";
//                         break;
//                     case 4:
//                         day = "星期五";
//                         break;
//                     case 5:
//                         day = "星期六";
//                         break;
//                     case 6:
//                         day = "星期天";
//                         break;
//                 }
//                 timeTableBeens.add(new TimeTableBean(strings[0], startNum, endNum, day, strings[3]));
//             }
//         }
//     }
//     return timeTableBeens;
