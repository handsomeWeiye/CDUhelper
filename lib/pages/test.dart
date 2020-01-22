import 'package:flutter/material.dart';


void main(){
    List weekDayList = ['1', "2", "3", "4", "5", "6", "7"];
  List indexList = [1,3,5,7,9,11];

  void _coursersContent(){
    //按顺序找到特定顺序的数据，然后一个个的加入到list中，在用一个widget将这个list转成一个column，然后再把许多个column加起，拼成一个表格
    for(int i = 0 ; i<weekDayList.length;i++){
      print(weekDayList[i]);
      for(int j = 0; i<indexList.length;j++){
        
       print(indexList[j]);
      }
    }


  }
  _coursersContent();
}

