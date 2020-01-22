import 'package:cdu_helper/routers/application.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ApplicationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('应用中心'),),
      body: Wrap(
        spacing: 2,
        runSpacing: 5,
        children: <Widget>[
          _widget('课表查询','/courses',context),
          _widget('在校成绩','/scores',context),
          _widget('学分统计','/credit',context),
          // _widget('等级考试'),
          _widget('考场安排','/exam',context),
          // _widget('一键评教'),
          // _widget('定时抢课'),
        ],
      ),
    );
  }

  Widget _widget(name,url,context){
    return InkWell(
      onTap: (){
        Application.router.navigateTo(context, '$url');
      },
      child: Container(
        width: ScreenUtil().setWidth(225),
        margin: EdgeInsets.all(5.0),
        padding: EdgeInsets.all(5.0),
        height: ScreenUtil().setHeight(300),
        decoration: BoxDecoration(border: Border.all()),
        child: Column(
          children: <Widget>[
            Container(
              width: ScreenUtil().setWidth(230),
              height: ScreenUtil().setHeight(200),
              child: Icon(Icons.ac_unit),
            ),
            Text('$name')
          ],
        ),
      ),
    );
  }
}