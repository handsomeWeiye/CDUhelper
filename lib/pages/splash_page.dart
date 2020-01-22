import 'package:flutter/material.dart';
import 'package:cdu_helper/pages/login_test_page.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin{
   AnimationController _animationController;
   Animation _animation;

  @override
  void initState() { 
    super.initState();
    _animationController = AnimationController(vsync: this,duration: Duration(milliseconds: 1000));
    _animation = Tween(begin: 0.0,end: 1.0).animate(_animationController);
    _animation.addStatusListener((status){
      if(status == AnimationStatus.completed){
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
          builder: (context)=> LoginPage(),
        ),(route)=> route==null);
      }
    });
    _animationController.forward();
  }

  @override
  void dispose() { 
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FadeTransition(
        opacity: _animation,
        child: Image.asset(r'lib\images\splash\splash_image.png',
        scale: 2.0,fit: BoxFit.cover,),
      ),
    );
  }
}