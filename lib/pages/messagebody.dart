import 'package:flutter/material.dart';
class MessageBody extends StatelessWidget {
  String name;
  List messages;
  MessageBody({
    super.key,
    required this.messages,
    required this.name
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text(name),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.yellow[100], 
        ),
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: messages.length,
          reverse: true,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.yellow[200],
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Icon(Icons.chat_bubble),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        messages[index],
                        style: TextStyle(color: Colors.black), 
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}