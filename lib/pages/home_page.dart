import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sms_orgonizer_new/database/database.dart';
import 'package:sms_orgonizer_new/util/userid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() =>_HomePageState();
}
class _HomePageState extends State<HomePage>{
  final SmsQuery _query=SmsQuery();
  database db =database();
  void deleteUser(int index){
    setState(() {
      db.messages.removeAt(index);
    });
  }
  void syncronized(List final_messages){
    setState(() {
      db.update(final_messages);
    });
  }
  List<Contact>? _contacts;
  bool _permissionDenied = false;
  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future _fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      setState(() => _permissionDenied = true);
    } else {
      final contacts = await FlutterContacts.getContacts();
      setState(() => _contacts = contacts);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        title:   Text(
          'Messages',
        ),
        elevation: 0,
        backgroundColor: Colors.yellow,
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child:
          db.messages.isNotEmpty
              ? ListView.builder(
                itemCount: db.messages.length,
                itemBuilder: (context,index){
                  return UserId(
                    senderName:db.messages[index][0].length==2?db.messages[index][0][1]:db.messages[index][0],
                    body:db.messages[index][1],
                    deleteFunction: (context)=>deleteUser(index),
                  );
                }
              )
              : Center(
                  child: Text(
                    'No messages to show.\n Tap refresh button...',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var permission=await Permission.sms.status;
          if (permission.isGranted) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                title: Text('Synchronizing...'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),
                    // Buffering animation
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
            );
            try {
              final messagess = await _query.querySms(
              kinds: [
                SmsQueryKind.inbox,
                SmsQueryKind.sent,
              ],
            );
            List final_messages = [];
            for (SmsMessage message in messagess) {
              var f=1;
              if (message.sender is String) {
                if (message.sender!.length<5)f=0;
                if (f==1&&message.sender!.substring(0,4)!='+880')f=0;
              }
              if (f==1){
                var foundMatch = false;
                for (int i = 0; i < final_messages.length; i++) {
                  if (final_messages[i][0] == message.sender) {
                    foundMatch = true;
                    final_messages[i][1].add(message.body);
                    break;
                  }
                }
                if (!foundMatch) {
                  List newSenderEntry = [message.sender, [message.body]]; 
                  final_messages.add(newSenderEntry);
                }
              }
            }
            for (int i=0;i<final_messages.length;i++) {
              for(final number in _contacts!){
                String sub2 = final_messages[i][0].substring(3, 14); 
                bool isPresent = number.phones.any((phone) => phone.number == final_messages[i][0]);
                isPresent |= number.phones.any((phone) => phone.number == sub2);
                if (isPresent){
                  debugPrint("aise");
                  debugPrint(number.displayName);
                }
              }
            }
            final_messages.sort((a, b) => a[0].compareTo(b[0]));
            syncronized(final_messages);
            } catch (error) {
              print('Error during synchronization: $error');
            } finally {
              Navigator.pop(context);
            }
          } else {
            await Permission.sms.request();
          }
        },
        child:  Icon(Icons.sync,color: Colors.black,),
      ),
    );
  }
}