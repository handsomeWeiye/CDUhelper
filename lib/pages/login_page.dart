import 'package:flutter/material.dart';
import 'package:cdu_helper/provides/login_page_provide.dart';
import 'package:provide/provide.dart';
import 'dart:typed_data';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //三个输入框的控制器
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController checkCodeController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1500)..init(context);
    // Provide.value<LoginPageProvide>(context).initConfig();
    return FutureBuilder(
      future: Provide.value<LoginPageProvide>(context).getCookiesAndCheckCode(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
      return Provide<LoginPageProvide>(builder: (context,child,val){
      return Scaffold(
        appBar: AppBar(
          title: Text('登录正方系统'),
        ),
        body: Column(children: <Widget>[
          TextField(
            decoration: InputDecoration(
              labelText: '学号',
            ),
            controller: idController,
          ),
          TextField(
            decoration: InputDecoration(labelText: '密码'),
            controller: passwordController,
          ),
          TextField(
            decoration: InputDecoration(labelText: '验证码'),
            controller: checkCodeController,
          ),
          InkWell(
            child: (val.checkCodeData != null)?Image.memory(Uint8List.fromList(val.checkCodeData)):null,
            onTap: (){
                Provide.value<LoginPageProvide>(context).reloadCheackCode();
            },
          ),
          RaisedButton(
            onPressed: () async {
                Provide.value<LoginPageProvide>(context).login(idController.text,passwordController.text,checkCodeController.text,context);
            },
            child: Text('登录'),
          ),
        ]));

    },);
      }
    );
    
  }
}