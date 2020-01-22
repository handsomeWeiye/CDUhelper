import 'package:flutter/material.dart';
import 'package:cdu_helper/provides/credit_page_provide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';

class CreditPage extends StatefulWidget {
  @override
  _CreditPageState createState() => _CreditPageState();
}

class _CreditPageState extends State<CreditPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provide.value<CreditPageProvide>(context).getCreditData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<Map> creditData = snapshot.data;
          Map majorCountData = creditData[creditData.length-1];
          creditData.removeLast();
          return Scaffold(
            appBar: AppBar(
              title: Text('学分统计'),
            ),
            body: ListView.builder(
              itemCount: creditData.length,
              itemBuilder: (BuildContext context, int index) {
                return _widget(creditData[index]);
              },
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: Text('数据正在加载'),
            ),
          );
        }
      },
    );
  }

  Widget _widget(Map map) {
    Widget _dataWidget(String msg) {
      return Container(
        width: ScreenUtil().setWidth(730 / 5),
        height: ScreenUtil().setHeight(150),
        child: Center(
          child: Text('$msg'),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.all(5.0),
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(150),
      decoration: BoxDecoration(color: Colors.cyanAccent),
      child: Center(
        child: Row(
          children: <Widget>[
            _dataWidget('${map['characteristicsOrName']}'),
            _dataWidget('${map['CreditsRequired']}'),
            _dataWidget('${map['CreditsEarned']}'),
            _dataWidget('${map['FailedCredit']}'),
            _dataWidget('${map['NeedForCredit']}'),
          ],
        ),
      ),
    );
  }
}
