
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PeopleTestPage extends StatefulWidget {
  @override
  _PeopleTestPageState createState() => _PeopleTestPageState();
}

class _PeopleTestPageState extends State<PeopleTestPage> {
  static const Map<String, Map> question = {
    '1': {
      'header': '当你独自去参加社交聚会时',
      'body': {'A': '既然去了就积极参与其中，尽兴而归', 'B': '很容易感到疲劳，想要提前退场'}
    },
    '2': {
      'header': '下列哪一件事听起来比较吸引你？',
      'body': {
        'A': '与恋人到很多人且社交频繁的地方',
        'B': '待在家中和恋人做一些特别的事情，比如欣赏一部有趣的录音带并享用你最喜欢的外卖食物'
      }
    },
    '3': {
      'header': '过去，你的亲朋好友倾向对你说',
      'body': {'A': '你难道不可以安静一会儿吗', 'B': '可以请你从你的世界中出来一下吗？'}
    },
    '4': {
      'header': '你倾向通过下列哪种方式收集信息',
      'body': {'A': '你对有可能发生之时的想象和期望', 'B': '你对目前状况的实际认知'}
    },
    '5': {
      'header': '当与一个人交往时，你倾向于看重',
      'body': {
        'A': '情感上的相容性：表达爱意和对另一半的需求很敏感',
        'B': '智慧上的相容性：沟通重要的想法；客观地讨论和辩论事情'
      }
    },
    '6': {
      'header': '当你和另一个人约会时，你偏向讨论',
      'body': {'A': '未来生活中的种种美妙的可能性', 'B': '真实发生的有趣见闻与旅程'}
    },
    '7': {
      'header': '认识你的人倾向于形容你为',
      'body': {'A': '热情随和', 'B': '逻辑冷静'}
    },
    '8': {
      'header': '和某人分手时',
      'body': {
        'A': '你通常让自己的情绪深陷其中，很难抽出身来',
        'B': '虽然你觉得很受伤，但一旦下定决心，你会直截了当的将过去恋人的影子甩开'
      }
    },
    '9': {
      'header': '你倾向如此做决定',
      'body': {'A': '首先依你的心意，然后依你的逻辑', 'B': '首先依你的逻辑，然后依你的心意'}
    },
    '10': {
      'header': '你自己更喜欢什么样的生活',
      'body': {'A': '各方面都井井有条的', 'B': '突如其来的，令人惊喜的'}
    },
    '11': {
      'header': '凡事你喜欢',
      'body': {'A': '先纵观大局，了解大背景', 'B': '先掌握细节，了解具体情况'}
    },
    '12': {
      'header': '你偏好',
      'body': {
        'A': '实现知道约会的行程：要去哪里，有谁参加，你会在哪里多久，该如何打扮',
        'B': '让约会自然地发生，不做太多事先的计划'
      }
    },
  };

  static const List<String> questionOrder = [
    '11',
    '5',
    '9',
    '1',
    '4',
    '12',
    '7',
    '3',
    '6',
    '10',
    '8',
    '2'
  ];

  Map<String, String> questionToAnswer = {
    '1': '',
    '2': '',
    '3': '',
    '4': '',
    '5': '',
    '6': '',
    '7': '',
    '8': '',
    '9': '',
    '10': '',
    '11': '',
    '12': ''
  };

  String personality = '';
  num count_A = 0;
  num questionIndex = 0 ;
  bool firstCommit = true;

  final Map<String, Map> answer = {
    "外向事实情感计划": {
      'personality': 'ESFJ',
      'personality_name': '温润甜心',
      'aphorism': '善良与品德兼备，有如宝石之于金属，两者互为衬托，益增光彩',
      'introduce':
          '热心肠、有责任心、合作。希望周边的环境温馨而和谐，并为此果断地执行。喜欢和他人一起精确并及时地完成任务。事无巨细都会保持忠诚。能体察到他人在日常生活中的所需并竭尽全力帮助。希望自己和自己的所为能受到他人的认可和赏识。',
    },
    "外向事实情感自由": {
      'personality': 'ESFP',
      'personality_name': '生活舞者',
      'aphorism': '一个人应当好好地安排生活，要使每一刻的时光都有意义',
      'introduce':
          '自发的，热情的生活表演者。外向、友好、接受力强。热爱生活、人类和物质上的享受。喜欢和别人一起将事情做成功。在工作中讲究常识和实用性，并使工作显得有趣。灵活、自然不做作，对于新的任何事物都能很快地适应。学习新事物最有效的方式是和他人一起尝试。能够把生活活成一部精彩的戏剧',
    },
    "外向事实逻辑计划": {
      'personality': 'ESTJ',
      'personality_name': '效率精英',
      'aphorism': '业精于勤而荒于嬉，行成于思而毁于随',
      'introduce':
          '实际、现实主义。果断，一旦下决心就会马上行动。善于将项目和人组织起来将事情完成，并尽可能用最有效率的方法得到结果。注重日常的细节。有一套非常清晰的逻辑标准，有系统性地遵循，并希望他人也同样遵循。在实施计划时强而有力。',
    },
    "外向事实逻辑自由": {
      'personality': 'ESTP',
      'personality_name': '战略大师',
      'aphorism': '恰同学少年，风华正茂，书生意气，挥斥方遒',
      'introduce':
          '灵活、忍耐力强，实际，注重结果。觉得理论和抽象的解释非常无趣。喜欢积极地采取行动解决问题。注重当前，自然不做作，享受和他人在一起的时刻。喜欢物质享受和时尚。学习新事物最有效的方式是通过亲身感受和练习。',
    },
    "外向直觉情感计划": {
      'personality': 'ENFJ',
      'personality_name': '魅力演说家',
      'aphorism': '我有一个梦',
      'introduce':
          '热情、为他人着想、易感应、有责任心。非常注重他人的感情、需求和动机。善于发现他人的潜能，并希望能帮助他们实现。能成为个人或群体成长和进步的催化剂。忠诚，对于赞扬和批评都会积极地回应。友善、好社交。在团体中能很好地帮助他人，并有鼓舞他人的领导能力。',
    },
    "外向直觉情感自由": {
      'personality': 'ENFP ',
      'personality_name': '自由精灵',
      'aphorism': '我这一生不羁放纵爱自由',
      'introduce':
          '热情洋溢、富有想象力。认为人生有很多的可能性。能很快地将事情和信息联系起来，然后很自信地根据自己的判断解决问题。总是需要得到别人的认可，也总是准备着给与他人赏识和帮助。灵活、自然不做作，有很强的即兴发挥的能力，言语流畅。',
    },
    "外向直觉逻辑计划": {
      'personality': 'ENTJ',
      'personality_name': '天才领袖',
      'aphorism': '我们的目标一定能达到，我们的目标一定会达到',
      'introduce':
          '坦诚、果断，有天生的领导能力。能很快看到公司/组织程序和政策中的不合理性和低效能性，发展并实施有效和全面的系统来解决问题。善于做长期的计划和目标的设定。通常见多识广，博览群书，喜欢拓广自己的知识面并将此分享给他人。在陈述自己的想法时非常强而有力。',
    },
    "外向直觉逻辑自由": {
      'personality': 'ENTP',
      'personality_name': '创意精英',
      'aphorism': '君不见黄河之水天上来，奔流到海不复回。君不见高堂明镜悲白发，朝如青丝暮成雪',
      'introduce':
          '反应快、睿智，有激励别人的能力，警觉性强、直言不讳。在解决新的、具有挑战性的问题时机智而有策略。善于找出理论上的可能性，然后再用战略的眼光分析。善于理解别人。不喜欢例行公事，很少会用相同的方法做相同的事情，倾向于一个接一个的发展新的爱好',
    },
    "内向事实情感计划": {
      'personality': 'ISFJ',
      'personality_name': '守护天使',
      'aphorism': '爱是一种驯养',
      'introduce':
          '安静、友好、有责任感和良知。坚定地致力于完成他们的义务。全面、勤勉、精确，忠诚、体贴，留心和记得他们重视的人的小细节，关心他人的感受。努力把工作和家庭环境营造得有序而温馨。',
    },
    "内向事实情感自由": {
      'personality': 'ISFP',
      'personality_name': '灵感艺术家',
      'aphorism': '我本楚狂人，凤歌笑孔丘',
      'introduce':
          '内向，友好、敏感、和善，富有激情。享受当前。喜欢有自己的空间，喜欢能按照自己的时间表工作。对于自己的价值观和自己觉得重要的人非常忠诚，有责任心。不喜欢争论和冲突。不会将自己的观念和价值观强加到别人身上。',
    },
    "内向事实逻辑计划": {
      'personality': 'ISTJ',
      'personality_name': '厚重少文',
      'aphorism': '我的眼眸中平静如镜，倒映星辰',
      'introduce':
          '安静、严肃，通过全面性和可靠性获得成功。实际，有责任感。决定有逻辑性，并一步步地朝着目标前进，不易分心。喜欢将工作、家庭和生活都安排得井井有条。重视传统和忠诚。',
    },
    "内向事实逻辑自由": {
      'personality': 'ISTP',
      'personality_name': '低调学霸',
      'aphorism': '多见者博，多闻者智，拒谏者塞，专己者孤',
      'introduce':
          '灵活、忍耐力强，是个安静的观察者直到有问题发生，就会马上行动，找到实用的解决方法。分析事物运作的原理，能从大量的信息中很快的找到关键的症结所在。对于原因和结果感兴趣，用逻辑的方式处理问题，重视效率。',
    },
    "内向直觉情感计划": {
      'personality': 'INFJ',
      'personality_name': '智慧导师',
      'aphorism': '世界上只有一种真正的英雄主义，那就是在认识生活的真相后依然热爱生活',
      'introduce':
          '真正的的理想主义者。寻求思想、关系、物质等之间的意义和联系。希望了解什么能够激励人，对人有很强的洞察力。有责任心，坚持自己的价值观。对于怎样更好的服务大众有清晰的远景。在对于目标的实现过程中有计划而且果断坚定。',
    },
    "内向直觉情感自由": {
      'personality': 'INFP',
      'personality_name': '博学大家',
      'aphorism': '博学之，审问之，慎思之，明辨之，笃行之',
      'introduce':
          '理想主义，对于自己的价值观和自己觉得重要的人非常忠诚。希望外部的生活和自己内心的价值观是统一的。好奇心重，很快能看到事情的可能性，能成为实现想法的催化剂。寻求理解别人和帮助他们实现潜能。适应力强，灵活，善于接受，除非是有悖于自己的价值观的。',
    },
    "内向直觉逻辑计划": {
      'personality': 'INTJ',
      'personality_name': '狂热艺术家',
      'aphorism': '万物皆有裂痕，那是光照进来的地方',
      'introduce':
          '在实现自己的想法和达成自己的目标时有创新的想法和非凡的动力。能很快洞察到外界事物间的规律并形成长期的远景计划。一旦决定做一件事就会开始规划并直到完成为止。多疑、独立，对于自己和他人能力和表现的要求都非常高。目的清晰明确，为达目的可以不择手段。',
    },
    "内向直觉逻辑自由": {
      'personality': 'INTP',
      'personality_name': '思想鬼才',
      'aphorism': '无所学，则无所知',
      'introduce':
          '对于自己感兴趣的任何事物都寻求找到合理的解释。喜欢理论性的和抽象的事物，热衷于思考而非社交活动。安静、内向、灵活、适应力强。对于自己感兴趣的领域有超凡的集中精力深度解决问题的能力。多疑，有时会有点挑剔，喜欢分析。',
    },
  };




  void getPersonalityItem(String item1,String item2,String item3,String prisonalityPossibly1,String prisonalityPossibly2) {
    count_A = 0; //每次调用这个方法的时候，把countA 刷一遍
    //如果1,2,3 的结果中 A的数量多于B 那么为外向 反之则为内向
    String a = questionToAnswer[item1];
    String b = questionToAnswer[item2];
    String c = questionToAnswer[item3];
    List _list = [a, b, c];
    _list.forEach((f) {
      if (f == 'A') count_A = count_A + 1;
    });
    if (count_A > 1) {
      personality = personality + prisonalityPossibly1;
    } else {
      personality = personality + prisonalityPossibly2;
    }
  }

  String getPersonality(){
    getPersonalityItem('1','2','3','外向','内向');
    getPersonalityItem('4','5','6','直觉','事实');
    getPersonalityItem('7','8','9','情感','逻辑');
    getPersonalityItem('10','11','12','计划','自由');
    print(personality);
    return personality;
  }



  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1500)..init(context);
    Widget headTitle(num index ){
      return Container(
        width: ScreenUtil().setWidth(700),
        height: ScreenUtil().setHeight(100),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('单项选择'),
            Text('${index + 1}/12')
          ],
        ),
      );
    }

    Widget qusetionTitle(num index){
      String questonOfIndex = questionOrder[index];
      return Container(
        width: ScreenUtil().setWidth(700),
        height: ScreenUtil().setHeight(100),
        child: Text(question[questonOfIndex]['header']),
      );
    }

    Widget  optionItem(String aOrb, String optionBody,String questonOfIndex){
      return InkWell(
        onTap: (){
          questionToAnswer[questonOfIndex] = aOrb;
          setState(() {
            if(questionIndex<11){
              questionIndex = questionIndex + 1;
              print(questionIndex);
            }else if(questionIndex == 11 && questionToAnswer['2'] != '' && firstCommit == true){
              firstCommit = false;
              getPersonality();
              if (personality.length == 8) {
                print('所有的都有值了');
                print(answer[personality]['personality_name']);
              } 
            }
          });
         
        },
        child:  Container(
        width: ScreenUtil().setWidth(650),
        height: ScreenUtil().setHeight(150),
        padding: EdgeInsets.all(5),
        child: Text(aOrb + ' ' + optionBody),
        )
      );
      
      
    }

    Widget options(num index){
      String questonOfIndex = questionOrder[index];
      return Column(
        children: <Widget>[
          optionItem('A',question[questonOfIndex]['body']['A'],questonOfIndex),
          optionItem('B',question[questonOfIndex]['body']['B'],questonOfIndex),
        ],
      );

    }

    Widget datiMain(num index){
      return Column(children: <Widget>[
        headTitle(index),
        qusetionTitle(index),
        options(index),
      ],);
    }

    Widget jiexiMain(){
      Widget personality_name(){
        return Container(
          child: Text(answer[personality]['personality_name']),
        );
      }

            Widget aphorism(){
        return Container(
          child: Text(answer[personality]['aphorism']),
        );
      }

            Widget introduce(){
        return Container(
          child: Text(answer[personality]['introduce']),
        );
      }

      return Expanded(
        child:  ListView(
        children: <Widget>[
          personality_name(),aphorism(),introduce()
        ],
      )
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('人格测试'),),
      body: Container(
        padding: EdgeInsets.all(5),
        width: ScreenUtil().setWidth(750),
        height: ScreenUtil().setHeight(1500),
        child: Column(
          children: <Widget>[
            firstCommit ? datiMain(questionIndex):jiexiMain()
          ],
        ),
      )
    );

  }
}
