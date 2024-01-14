import 'package:hive_flutter/hive_flutter.dart';
class database{
  List messages = [];
  final _smsBox=Hive.box('smsBox');
  void load(){
    messages=_smsBox.get("MESSAGES");
  }
  void update(List final_messages){
    for (final item in final_messages) {
      int matchingIdIndex = -1;
      for(int i=0;i<messages.length;i++){
        if (item[0]==messages[i][0]){
          matchingIdIndex=i;
          break;
        }
      }
      if (matchingIdIndex != -1) {
        messages[matchingIdIndex][1].addAll(item[1]);
      } else {
        messages.add(item);
      }
    }
    messages.sort((a, b) => a[0].compareTo(b[0]));
    _smsBox.put("MESSAGES",messages);
  }
}