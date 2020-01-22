import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:oktoast/oktoast.dart';
import 'package:cdu_helper/provides/login_test_page_provide.dart';
import 'package:provide/provide.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

class ConfimSmsPage extends StatefulWidget {
  @override
  _ConfimSmsPageState createState() => _ConfimSmsPageState();
}

class _ConfimSmsPageState extends State<ConfimSmsPage> {
  final _formKey = GlobalKey<FormState>();
  String phoneNum = '';
  bool isAbled = true;
  Timer _timer;
  int _countdownTime = 0;

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
            inputCase(),
            confirmBotton(),
          ],
        ),
      ),
    );
  }

  Widget inputCase() {
    return Container(
        // decoration: BoxDecoration(
        //   border: Border.all(color:Colors.black),
        //   borderRadius: BorderRadius.circular(10)),

        padding: EdgeInsets.only(left: 60, right: 60),
        height: ScreenUtil().setHeight(100),
        child: PinInputTextFormField(
          pinLength: 4,
          decoration: BoxLooseDecoration(
              gapSpace: 40,
              radius: Radius.circular(10),
              strokeColor: Colors.black,
              solidColor: Colors.black12),
          textInputAction: TextInputAction.go,
          onSubmit: (String pin) {
            Provide.value<LoginTestPageProvide>(context)
                .submitSms(context, pin);
          },
        ));

    //   Center(
    //     child:TextField(
    //     decoration:null,
    //     cursorWidth: ScreenUtil().setWidth(4),
    //     cursorColor: Colors.black,
    //     style: TextStyle(fontSize: 35),
    //     maxLengthEnforced: true,
    //     maxLength: 1,
    //     textAlign: TextAlign.center,
    //     keyboardType: TextInputType.number
    //   ),
    // ));
  }

  Widget positonCmd(
    Widget _widget,
    double top,
    double left,
  ) {
    return Positioned(
      child: _widget,
      top: ScreenUtil().setHeight(top),
      left: ScreenUtil().setWidth(left),
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
          Icon(Icons.check),
          SizedBox(
            width: ScreenUtil().setWidth(20),
          ),
          Text(
            '验证码',
            style: TextStyle(
                fontFamily: 'HuaWenXinWei', fontSize: ScreenUtil().setSp(45)),
          )
        ],
      ),
    );
  }

  Widget confirmBotton() {
    return Center(
        child: Container(
            padding: EdgeInsets.only(top: 50),
            child: ButtonTheme(
              child: isAbled
                  ? RaisedButton(
                      color: Color.fromRGBO(209, 11, 11, 1),
                      onPressed: () {
                        Provide.value<LoginTestPageProvide>(context)
                            .reSendSms(context, phoneNum);
                        _countdownTime = 60;
                        countDown();
                        setState(() {
                          isAbled = false;                          
                        });
                      },
                      child: Text(
                        '重新发送',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(50),
                            fontFamily: 'HuaWenXinWei'),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(70)),
                      ),
                    )
                  : diabledOnraisedBotton(),
              minWidth: ScreenUtil().setWidth(408),
              height: ScreenUtil().setHeight(140),
            )));
  }

  Widget diabledOnraisedBotton() {
    return RaisedButton(
      color: Colors.grey,
      onPressed: (){},
      child: Text(
        '重新发送($_countdownTime)',
        style: TextStyle(
          color: Colors.white,
          fontSize: ScreenUtil().setSp(40),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(70)),
      ),
    );
  }

  Widget countDown() {
    const oneSec = const Duration(seconds: 1);
    Function callback = (Timer timer) {
          setState(() {
            if (_countdownTime < 1) {
              _timer.cancel();
              isAbled = true;
            } else {
              _countdownTime = _countdownTime - 1;
              print(_countdownTime);
            }
          });
        };

    _timer = Timer.periodic(oneSec, callback);
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }
}
