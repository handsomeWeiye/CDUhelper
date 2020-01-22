import 'package:flutter/material.dart';
import 'package:cdu_helper/provides/scores_page_provide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';

class ScoresPage extends StatefulWidget {
  @override
  _ScoresPageState createState() => _ScoresPageState();
}

class _ScoresPageState extends State<ScoresPage> {
  var schoolYear;
  var term;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provide.value<ScoresPageProvide>(context)
          .getScoresData('2018-2019', ''),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Provide<ScoresPageProvide>(
            builder: (context, child, val) {
              return Scaffold(
                appBar: AppBar(
                  title: Text('在校成绩'),
                ),
                body: Column(
                  children: <Widget>[
                    queryBox(),
                    Flexible(child: scoreViewList(val.currentScoreData)),
                  ],
                ),
              );
            },
          );
        } else {
          return Scaffold(
            body: Center(
              child: Text('首次加载数据有点慢呢'),
            ),
          );
        }
      },
    );
  }

  Widget queryBox() {
    return Container(
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setWidth(150),
      child: Row(
        children: <Widget>[yearChoiceBox(), termChoiceBox(), queryBottom()],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }

  Widget yearChoiceBox() {
    List<DropdownMenuItem> generateItemList() {
      List<DropdownMenuItem> items = [];
      DropdownMenuItem item1 =
          DropdownMenuItem(value: '2017-2018', child: Text('2017-2018'));
      DropdownMenuItem item2 =
          DropdownMenuItem(value: '2018-2019', child: Text('2018-2019'));
      // DropdownMenuItem item3 =  DropdownMenuItem(
      // value: '2017-2018', child: Text('2017-2018'));
      // DropdownMenuItem item4 =  DropdownMenuItem(
      // value: '2017-2018', child: Text('2017-2018'));
      items..add(item1)..add(item2);
      return items;
    }

    return DropdownButton(
      hint: Text('选择学年'),
      items: generateItemList(),
      value: schoolYear,
      onChanged: (T) {
        setState(() {
          schoolYear = T;
        });
      },
    );
  }

  Widget termChoiceBox() {
    List<DropdownMenuItem> generateItemList() {
      List<DropdownMenuItem> items = [];
      DropdownMenuItem item1 = DropdownMenuItem(value: '1', child: Text('1'));
      DropdownMenuItem item2 = DropdownMenuItem(value: '2', child: Text('2'));
      // DropdownMenuItem item3 =  DropdownMenuItem(
      // value: '2017-2018', child: Text('2017-2018'));
      // DropdownMenuItem item4 =  DropdownMenuItem(
      // value: '2017-2018', child: Text('2017-2018'));
      items..add(item1)..add(item2);
      return items;
    }

    return DropdownButton(
      hint: Text('选择学期'),
      items: generateItemList(),
      value: term,
      onChanged: (T) {
        setState(() {
          term = T;
        });
      },
    );
  }

  Widget queryBottom() {
    return RaisedButton(
      child: Text('查询'),
      onPressed: () {
        Provide.value<ScoresPageProvide>(context)
            .getScoresData(schoolYear, term);
      },
    );
  }

  Widget scoreViewList(scoreDataListh) {
    return ListView.builder(
      itemCount: scoreDataListh.length,
      itemBuilder: (BuildContext context, int index) {
        return scoreViewItem(scoreDataListh[index]);
      },
    );
  }
  

  Widget scoreViewItem(Map scoreDataItem) {
    Widget rowItem(itemName) {
      return Container(
        height: ScreenUtil().setHeight(150),
        width: ScreenUtil().setWidth(730 / 5),
        child: Center(
          child: Text(
            '$itemName',
            style: TextStyle(
                color: Colors.black, fontSize: ScreenUtil().setSp(26)),
          ),
        ),
      );
    }

    return InkWell(
      child: Container(
        width: ScreenUtil().setWidth(750),
        height: ScreenUtil().setHeight(150),
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(color: Colors.blue),
        child: Row(
          children: <Widget>[
            rowItem(scoreDataItem['courseTitle']),
            rowItem(scoreDataItem['credit']),
            rowItem(scoreDataItem['point']),
            rowItem(scoreDataItem['grade']),
            rowItem(scoreDataItem['college']),
          ],
        ),
      ),
      onTap: () {
        // showDialog(context: context,barrierDismissible: false,builder: (BuildContext context){
        //   return AlertDialog(
        //   title: Text('详细信息'),
        //   content: ListView.builder(
        //     itemCount: scoreDataItem.length,
        //     itemBuilder: (BuildContext context, int index) {
        //       Widget details(){
        //         List listkey = scoreDataItem.keys;
        //         List listvalew = scoreDataItem.values;
        //         return Container(
        //                   width: ScreenUtil().setWidth(750),
        //                   height: ScreenUtil().setHeight(150),
        //           child:  Center(child: Row(children: <Widget>[Text('${listkey[index]}'),Text('${listvalew[index]}')],),),
        //         );
        //       }
        //     return details() ;
        //    },
        //   ),
        // );
        // });
      },
    );
  }
}
