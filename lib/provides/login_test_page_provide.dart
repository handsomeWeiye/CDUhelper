import 'package:data_plugin/bmob/bmob.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/bmob/response/bmob_sent.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:data_plugin/utils/dialog_util.dart';
import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:data_plugin/data_plugin.dart';
import 'package:data_plugin/bmob/bmob_sms.dart';

class LoginTestPageProvide with ChangeNotifier{

    //比目云简直是太好用了
    sendSms(BuildContext context,String phoneNum) {
    BmobSms bmobSms = BmobSms();
    bmobSms.template = "注册验证码";
    bmobSms.mobilePhoneNumber = phoneNum;
    bmobSms.sendSms().then((BmobSent bmobSent) {
      showSuccess(context, "发送成功:" + bmobSent.smsId.toString());
    }).catchError((e) {
      showError(context, BmobError.convert(e).error);
    });
  }
    submitSms(BuildContext context,String pin){
      debugPrint(pin);
      notifyListeners();
    }

    reSendSms(BuildContext,String num){
      debugPrint('验证码已发送至18306832083');
    }
}