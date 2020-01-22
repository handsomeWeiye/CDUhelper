import 'dart:convert';
import 'dart:ui' as prefix0;

import 'package:cdu_helper/provides/home_page_provide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provide/provide.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollViewController;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _scrollViewController = ScrollController(initialScrollOffset: 0.0);
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollViewController.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1500)..init(context);

    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          elevation: 1.0,
          title: Text('主页'),
        ),
        body: NestedScrollView(
          controller: _scrollViewController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                pinned: true,
                floating: true,
                expandedHeight: ScreenUtil().setHeight(700),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Container(
                    //头部整个背景颜色
                    height: double.infinity,
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        // SwiperDiy(),
                        CategoryGridWidget(),
                        ThingDateDiy()
                      ],
                    ),
                  ),
                ),
                bottom: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    // indicatorSize: TabBarIndicatorSize.label,
                    // indicatorWeight: 5.0,
                    labelColor: Color(0xff333333),
                    // labelStyle: TextStyle(
                    //   fontSize: 15.0,
                    // ),
                    // unselectedLabelColor: Color(0xff333333),
                    // unselectedLabelStyle: TextStyle(
                    //   fontSize: 12.0,
                    // ),
                    tabs: [
                      Tab(text: "表白墙"),
                      Tab(text: "跳蚤市场"),
                      Tab(text: "失物招领"),
                    ]),
              )
            ];
          },
          body: TabBarView(controller: _tabController, children: [
            Center(
              child: Text("aaa:"),
            ),
            Center(
              child: Text("aaa:"),
            ),
            Center(
              child: Text("aaa:"),
            )
          ]),
        ));
  }
}

class SwiperDiy extends StatelessWidget {
  // final List swiperItemList;
  // const SwiperDiy({Key key, this.swiperItemList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provide.value<HomePageProvide>(context).getSwiperData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        Map swiperData = json.decode(snapshot.data.toString());
        // print(swiperData);
        List swiperItemList = swiperData['results'];
        // print(swiperItemList.length);
        return Container(
          height: ScreenUtil().setHeight(333),
          width: ScreenUtil().setWidth(750),
          child: Swiper(
            itemBuilder: (BuildContext context, int index) {
              return Image.network(
                '${swiperItemList[index]["image"]["url"]}',
                fit: BoxFit.cover,
              );
            },
            itemCount: swiperItemList.length,
            pagination: SwiperPagination(),
            autoplay: true,
          ),
        );
      },
    );
  }
}

class CategoryGridWidget extends StatelessWidget {
  // final List categoryItemsList;
  // const CategoryGridWidget({Key key, this.categoryItemsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provide.value<HomePageProvide>(context).getCategoryData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List categoryItemsList =
                jsonDecode(snapshot.data.toString())['results'];
            return Container(
              height: ScreenUtil().setHeight(400),
              child: GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  padding: EdgeInsets.all(5),
                  children: categoryItemsList.map((categoryItemDate) {
                    return CategoryItembuild(
                      categoryItemData: categoryItemDate,
                    );
                  }).toList()),
            );
          }
          return Center(child: Text('加载中'));
        });
  }
}

class CategoryItembuild extends StatelessWidget {
  final Map categoryItemData;
  const CategoryItembuild({Key key, this.categoryItemData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: InkWell(
      onTap: () {},
      child: Column(
        children: <Widget>[
          Image.network(
            categoryItemData["iconImage"]["url"],
            width: ScreenUtil().setWidth(100),
          ),
          Text(categoryItemData["iconName"], maxLines: 1)
        ],
      ),
    ));
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double toSetX = size.width / 2;
    double toSetY = size.height / 2;
    // print(toSetX);
    // print(toSetY);
    Paint paint = Paint()
      ..isAntiAlias = true
      ..color = Colors.pink
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    Paint paint1 = Paint()
      ..isAntiAlias = true
      ..color = Colors.blue
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;
    canvas.drawLine(Offset(0, toSetY), Offset(toSetX, toSetY), paint);
    canvas.drawLine(
        Offset(toSetX + 2, toSetY), Offset(2 * toSetX + 2, toSetY), paint);
    canvas.drawPoints(
        prefix0.PointMode.points, [Offset(toSetX, toSetY)], paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}

class ThingDateDiy extends StatelessWidget {
  var now = DateTime.now();
  List<int> differentDays = [];
  List thingDateList = [];
  List<int> removeIndexs = [];

  Widget thingDateIcon() {
    return Container(
      child: Icon(
        Icons.access_time,
        size: 35,
      ),
    );
  }

  Widget thingDateItem(int days, String dateName, String date, int index) {
    return Container(
        height: ScreenUtil().setHeight(200),
        width: ScreenUtil().setWidth(150),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(date),
            CustomPaint(
              painter: MyPainter(),
              size:
                  Size(ScreenUtil().setWidth(150), ScreenUtil().setHeight(20)),
            ),
            Text(dateName + days.toString() + '天')
          ],
        ));
  }

  Widget thingDateItems() {
    List<Widget> list = [];
    for (int i = 0; i < thingDateList.length; i++) {
      list.add(thingDateItem(differentDays[i], thingDateList[i]['thingName'],
          thingDateList[i]['thingDate']['iso'].toString().substring(0, 10), i));
    }
    return list.isNotEmpty ? Row(children: list) : Text('data');
  }

  @override
  Widget build(BuildContext context) {
    differentDays = [];
    return FutureBuilder(
      future: Provide.value<HomePageProvide>(context).getThingDate(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          thingDateList = jsonDecode(snapshot.data.toString())['results'];
          print(thingDateList);
          thingDateList.forEach((f) {
            DateTime date = DateTime.parse(f['thingDate']['iso']);
            var different = date.difference(now);
            var differentDay = int.parse(different.inDays.toString());
            if (differentDay >= 0) {
              differentDays.add(differentDay);
            } else {
              int removeIndex = thingDateList.indexOf(f);
              removeIndexs.add(removeIndex);
            }
          });
          removeIndexs.forEach((f) {
            thingDateList.removeAt(f);
          });
          print(thingDateList);
          return Container(
              padding: EdgeInsets.all(5),
              height: ScreenUtil().setHeight(200),
              width: ScreenUtil().setWidth(750),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    thingDateIcon(),
                    SizedBox(width: ScreenUtil().setWidth(20)),
                    thingDateItems()
                  ],
                ),
              ));
        }
        return Center(child: Text('加载中'));
        // print(differentDays);
      },
    );
  }
}
