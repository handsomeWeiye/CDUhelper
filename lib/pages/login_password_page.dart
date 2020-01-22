import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPasswordPage extends StatefulWidget {
  @override
  _LoginPasswordPageState createState() => _LoginPasswordPageState();
}

class _LoginPasswordPageState extends State<LoginPasswordPage> {
  String password = '';
  bool isOcured = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1500)..init(context);
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            SizedBox(
              width: 20,
              height: 100,
            ),
            title(),
            titleLine(),
            smsTitle(),
            passwordInputCase(),
            loginWithSms(),
            confirmBotton(),
          ],
        ),
      ),
    );
  }

  Widget title() {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        width: ScreenUtil().setWidth(350),
        child: Image.asset('lib/images/loginAndRegister/title.png'),
      ),
    );
  }

  Widget titleLine() {
    return Center(
      child: Container(
        width: ScreenUtil().setWidth(350),
        child: Image.asset('lib/images/loginAndRegister/titleLine.png'),
      ),
    );
  }

  Widget smsTitle() {
    return Container(
      padding: EdgeInsets.only(left: 30, top: 20, bottom: 20),
      child: Row(
        children: <Widget>[
          Icon(Icons.lock),
          SizedBox(
            width: ScreenUtil().setWidth(20),
          ),
          Text(
            '密码',
            style: TextStyle(
                fontFamily: 'HuaWenXinWei', fontSize: ScreenUtil().setSp(45)),
          )
        ],
      ),
    );
  }

  Widget passwordInputCase() {

        return Container(
            width: ScreenUtil().setWidth(700),
            height: ScreenUtil().setHeight(150),
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    width: ScreenUtil().setWidth(650),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: '密码',
                        suffixIcon: InkWell(
                          onTap: () {
                           
                            setState(() {
                              isOcured = !isOcured;
                            });
                          },
                          child: isOcured
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility),
                        ),
                      ),
                      obscureText: isOcured,
                      onChanged: (String val){
                        password = val;
                        print(password);
                      },
                    ),
                  ),
            ],
          ),
        ));
  }

  Widget loginWithSms(){
    return Container(
      padding: EdgeInsets.only(left:ScreenUtil().setWidth(500)),
      width: ScreenUtil().setWidth(80),
      height: ScreenUtil().setHeight(50),
      child: InkWell(
        onTap: (){},
        child: Text('以验证码登陆',style: TextStyle(color: Colors.amber,fontFamily:'HuaWenXinWei',fontSize: ScreenUtil().setSp(35) ),),
      ),
    );
  }

  Widget confirmBotton() {
    return Center(
        child: Container(
            padding: EdgeInsets.only(top: 50),
            child: ButtonTheme(
              child: RaisedButton(
                color: Color.fromRGBO(209, 11, 11, 1),
                onPressed: () {
                  // Provide.value<LoginTestPageProvide>(context)
                  //     .reSendSms(context, phoneNum);
                  
                   _formKey.currentState.validate();
                  if(password !='' ){
                    if(password.length < 8){
                      Fluttertoast.showToast(msg: '密码不能小于8位');
                    }else{
                      Fluttertoast.showToast(msg: '尝试登陆');
                    }
                  }else{ Fluttertoast.showToast(msg: '密码不能为空');}
                },
                child: Text(
                  '确定',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: ScreenUtil().setSp(50),
                      fontFamily: 'HuaWenXinWei'),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(70)),
                ),
              ),
              minWidth: ScreenUtil().setWidth(408),
              height: ScreenUtil().setHeight(140),
            )));
  }

}