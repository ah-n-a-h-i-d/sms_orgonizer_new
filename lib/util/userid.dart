import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sms_orgonizer_new/pages/messagebody.dart';
class UserId extends StatelessWidget {
  final String senderName;
  final List body;
  Function(BuildContext)? deleteFunction;
  UserId({
    super.key,
    required this.senderName, 
    required this.body,
    required this.deleteFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25,right: 25,top:25),
      child: Slidable(
      endActionPane: ActionPane(
        motion: StretchMotion(),
        children: [
          SlidableAction(
            label: 'Delete',
            backgroundColor: Colors.red,
            borderRadius: BorderRadius.circular(15),
            icon: Icons.delete,
            onPressed: deleteFunction,
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black)),
        ),
        child: ListTile(
            leading:Icon(Icons.person),
            title:Text('$senderName'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MessageBody(messages: body,name:senderName)),
              );
            },
        ),
      ),
      )
    );
  }
}