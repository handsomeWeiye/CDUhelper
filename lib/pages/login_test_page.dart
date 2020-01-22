import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:oktoast/oktoast.dart';
import 'package:cdu_helper/provides/login_test_page_provide.dart';
import 'package:provide/provide.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String phoneNum = '';

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1500)..init(context);
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.only(top: 70),
          children: <Widget>[
            title(),
            titleLine(),
            phoneNumInputField(context),
            confirmBotton(),
            bottomIcon()
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

  Widget phoneNumInputField(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 50),
        width: ScreenUtil().setWidth(565),
        child: TextFormField(
          onSaved: (String value) => phoneNum = value,
          validator: (String value) {
            if (value.isEmpty) {
              showToast('请输入您的手机号', position: ToastPosition.bottom, radius: 25);
            }
          },
          decoration: InputDecoration(
            icon: Icon(Icons.phone_android),
            border: OutlineInputBorder(
                gapPadding: 10.0, borderRadius: BorderRadius.circular(20.0)),
            contentPadding: EdgeInsets.all(15.0),
            fillColor: Colors.redAccent
          ),
          keyboardType: TextInputType.number,
        ),
      ),
    );
  }

  Widget confirmBotton() {
    return Center(
        child: Container(
            child: ButtonTheme(
      child: RaisedButton(
        color: Color.fromRGBO(209, 11, 11, 1),
        onPressed: () {
          _formKey.currentState.save();
          print(phoneNum);
          Provide.value<LoginTestPageProvide>(context).sendSms(context, phoneNum);
        },
        child: Text(
          '确定',
          style: TextStyle(
              color: Colors.white,
              fontSize: ScreenUtil().setSp(60),
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

  Widget bottomIcon() {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 70),
        child: Image.asset('lib/images/loginAndRegister/loginFooter.png'),
        width: ScreenUtil().setWidth(310),
      ),
    );
  }
}
