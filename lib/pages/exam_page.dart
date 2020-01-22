import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provide/provide.dart';
import 'package:cdu_helper/provides/exam_page_provide.dart';

class ExamPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: Provide.value<ExamPageProvide>(context).getCreditData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData){
          return Scaffold(
            body:Container(
              child: Html(data:snapshot.data,),
            )
          );
        }else{
          return Scaffold(
            body: Center(child: Text('数据正在加载'),),
          );
        }
        
      },
    );
  }
}