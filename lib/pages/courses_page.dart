import 'package:flutter/material.dart';
import 'package:cdu_helper/provides/courses1_page_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';

class CoursesPage extends StatefulWidget {
  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {

  
  int weeks = 12;
  String grade = '大三';
  String term = '第1学期';
  List weekDayList = ['周一', "周二", "周三", "周四", "周五", "周六", "周日"];
  List indexList = [1,3,5,7,9,11];
  List colorList = [Colors.pink,Colors.blue,Colors.yellowAccent,Colors.greenAccent,Colors.orangeAccent,Colors.purpleAccent,Colors.redAccent,Colors.tealAccent,Colors.lightGreen,Colors.cyanAccent,Colors.grey];
  

  //循环遍历所有的课程名称，找到所有的课程名称
  
  List courserNameList (coursesData){
    Set _set = Set();
    for(int k = 0 ; k <coursesData.length;k++){
      _set.add(coursesData[k]['coursesName']);
    }
    
    return _set.toList();
  }


  //将请求得到的数据转换为有顺序的课程组件
  List _coursersContent(coursesData){
    List rowList = [];
    // print(coursesData);
    //得到所有课程的名字列表，根据名字在列表中的索引，得到对应的颜色
    List courserName = courserNameList(coursesData);
    //按顺序找到特定顺序的数据，然后一个个的加入到list中，在用一个widget将这个list转成一个column，然后再把许多个column加起，拼成一个表格
    for(int i = 0 ; i<weekDayList.length;i++){
      List columnList = [];
      for(int j = 0; j<indexList.length;j++){
        // print(weekDayList[i]);
        // print(indexList[j]);
        bool hasData = false;
        for(int k = 0 ; k <coursesData.length;k++){
          if(coursesData[k]['coursesDay']==weekDayList[i]&&coursesData[k]['coursesIndex'].contains(indexList[j]) &&coursesData[k]['coursesWeeks'].contains(weeks)){
            hasData = true;
            // print(coursesData[k]['coursesDay']);
            // print(coursesData[k]['coursesIndex'][0]);
            // print(coursesData[k]['coursesName']);
            String coursersName = coursesData[k]['coursesName'];
            String coursesRoom = coursesData[k]['coursesRoom'];
            // print(coursesData[k]['coursesIndex']);
            var color =  colorList[courserName.indexOf(coursersName)] ;
           columnList.add( _courser(coursersName,coursesRoom,color));
          }
          // print(columnList);
        }
        if(hasData == false){
          columnList.add( _courser('','',''));
        }
        
        
      }
      rowList.add(columnList);
    }
    // print(rowList);
    return rowList;
  }

  
  


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provide.value<CoursesPageProvide>(context).getCoursesData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // print(colorList.length);
        if (snapshot.hasData) {
          List coursesData =  _coursersContent(snapshot.data);
          return Scaffold(
              appBar: AppBar(
                title: Text('课程表'),
              ),
              body: Container(
                width: ScreenUtil().setWidth(750),
                height: ScreenUtil().setHeight(1500),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      _weekInfoWiget(weeks, term, grade),
                      _weekdayWidget(),
                      Row(children: <Widget>[_leftRowsNum(),_coursesMain(coursesData)],crossAxisAlignment: CrossAxisAlignment.start,),
                      
                    ],
                  ),
                ),
              ));
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

  //输入一个有顺序的课程List，输出七列的column;本质上就是按顺序拜访了组件
  Widget _coursesMain(coursersData){
    List<Widget> list = [];
     Widget _columuWidget(List columuWidgetData){
      List<Widget> list = [];
      columuWidgetData.forEach((f)=>list.add(f));
      return Column(children: list);
    }

    for(int i = 0 ; i<coursersData.length;i++){
      list.add(_columuWidget(coursersData[i])) ;
    }    
    return Row(
      children: list
    );
  }

  //所属第几周，第几个星期的组件

  Widget _weekInfoWiget(weeks,term,  grade) {
    return Container(
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(100),
      decoration: BoxDecoration(color: Colors.white),
      child: Center(
          child: Column(
        children: <Widget>[
          Text('第${weeks}周'),
          Center(
            child: Row(
                children: <Widget>[Text('$grade'), Text(term)],
                mainAxisSize: MainAxisSize.min),
          )
        ],
      )),
    );
  }

  //周一到周日的组件
  Widget _weekdayWidget() {
    List list = ['周一', "周二", "周三", "周四", "周五", "周六", "周日"];

    Widget _weekDay(weekDayName) {
      return Container(
        width: ScreenUtil().setWidth(100),
        child: Center(
          child: Text('$weekDayName'),
        ),
        decoration: BoxDecoration(
            border: Border(right: BorderSide(width: 1.0, color: Colors.white))),
      );
    }

    Widget _monthName(monthName) {
      return Container(
        width: ScreenUtil().setWidth(50),
        child: Center(
          child: Text('$monthName'),
        ),
        decoration: BoxDecoration(
            border: Border(right: BorderSide(width: 1.0, color: Colors.white))),
      );
    }

    return Container(
        width: ScreenUtil().setWidth(750),
        height: ScreenUtil().setHeight(70),
        decoration: BoxDecoration(color: Colors.white),
        child: Row(
          children: <Widget>[
            _monthName(''),
            _weekDay(list[0]),
            _weekDay(list[1]),
            _weekDay(list[2]),
            _weekDay(list[3]),
            _weekDay(list[4]),
            _weekDay(list[5]),
            _weekDay(list[6])
          ],
        ));
  }

  //左边的行号，使用一个column
  Widget _leftRowsNum (){
    
    Widget _widget(number){
      return Container(
        width: ScreenUtil().setWidth(100),
        height: ScreenUtil().setHeight(120),
        child: Center(
          child: Text('$number'),
        ),
        decoration: BoxDecoration(
          color: Colors.white12,
          border: Border(
            bottom: BorderSide()
          )
        ),
      );

    }

    List<Widget> list = [];
    for(int i = 1; i<=12; i++){
      list.add(_widget(i));
    }


    return  Column(
        children: <Widget>[
          Container(
      width: ScreenUtil().setWidth(50),
      height: ScreenUtil().setHeight(1440),
      color: Colors.black26,
      child: Column(
        children: list
      ),
    )
        ],
      );
    
  }
  

  //右边的每一个课程的色块
  Widget _courser([courserName,courserClassNum,color]){
    return InkWell(
      onTap: (){},
      child: Container(
      margin: EdgeInsets.all(2.0),
      height: ScreenUtil().setHeight(230),
      width: ScreenUtil().setWidth(92),
      
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          5.0),
        color: courserName==''?Colors.white:color
      ),
      child: Center(
        child: Column(
          children: <Widget>[
            courserName!=''?Text('$courserName'):Text(''),
            courserClassNum!=''?Text('@$courserClassNum'):Text('')
          ],
        ),
      ),
    ),
    );
  }


  


  





}
