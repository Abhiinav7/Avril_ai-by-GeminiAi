import 'dart:convert';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  ChatUser myself = ChatUser(id: "1", firstName: "Aaru");
  ChatUser bot = ChatUser(id: "2", firstName: "Avril Ai");
  List<ChatMessage> allMassages = [];
  List<ChatUser> typing=[];

  final ourUrl="https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyAjxsLoRb3xfrtkGyj2_gn4pOFaaO8Ov_Q";
  final header={
    'Content-Type': 'application/json'
  };

  getData(ChatMessage m) async {
    typing.add(bot);
    allMassages.insert(0, m);
    setState(() {

    });
    var data={"contents":[{"parts":[{"text":m.text}]}]};

    await http.post(Uri.parse(ourUrl),headers: header,body: jsonEncode(data)).
    then((value){
      if(value.statusCode==200){
        var result=jsonDecode(value.body);
        print(result["candidates"][0]["content"]["parts"][0]["text"]);
        ChatMessage m1=ChatMessage(

          user: bot,
          createdAt: DateTime.now(),
          text: result["candidates"][0]["content"]["parts"][0]["text"],
        );
        allMassages.insert(0, m1);

      }else{
        print("Error occurred");
      }
    }).
    catchError((e){});
    typing.remove(bot);
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black26,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Welcome to Avril Ai",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: DashChat(
          messageOptions: MessageOptions(
            showOtherUsersAvatar: false,
              showTime: true,
              textColor: Colors.white,
              containerColor: Colors.indigo,
            maxWidth: size.width - 80,
          ),
          typingUsers: typing,
          currentUser: myself,
          onSend: (ChatMessage m) {
            getData(m);
          },
          messages: allMassages,
        ),
      ),
    );
  }
}