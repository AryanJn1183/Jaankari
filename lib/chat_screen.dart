import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(390, 844),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white, // Set appbar color to blue
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/icons/chatbot_logo.png'),
                backgroundColor: Colors.white,
                radius: 18.r,
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jaankar Sarthi',
                    style: TextStyle(
                        fontSize: 20.sp,
                        color: Color(0xFF007CC2),
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'Making Laws Easy!',
                    style: TextStyle(fontSize: 16.sp, color: Color(0xFF007CC2)),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: ChatBody(),
      ),
    );
  }
}

class ChatBody extends StatefulWidget {
  @override
  _ChatBodyState createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  TextEditingController _messageController = TextEditingController();
  List<ChatMessage> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg_home.png'),
          opacity: 0.35,
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _messages[index];
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter Your Question',
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.send,
                          color: Color(0xFF007CC2),
                          size: 25.sp,
                        ),
                        onPressed: () {
                          String messageText = _messageController.text;
                          _sendMessage(messageText);
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.r),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.blue[100],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String messageText) async {
    if (messageText.isNotEmpty) {
      setState(() {
        _messages.add(
          ChatMessage(
            isUser: true,
            message: messageText,
          ),
        );
        _messageController.clear();
      });

      final url = Uri.parse(
          'https://asia-south1-heroic-equinox-413915.cloudfunctions.net/function-1/ask-question/$messageText');
      final headers = {
        'Content-Type': 'application/json',
        'Accept-Encoding': 'gzip, deflate, br'
      };

      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final botResponse =
            responseBody['answer']['choices'][0]['message']['content'];
        if (botResponse != null) {
          setState(() {
            _messages.add(
              ChatMessage(
                isUser: false,
                message: botResponse,
              ),
            );
          });
        } else {
          print('Response from server is null');
        }
      } else {
        print('Failed to send message to server');
      }

      // Close the keyboard and keep the chat screen visible
      FocusScope.of(context).unfocus();
    }
  }
}

class ChatMessage extends StatelessWidget {
  final bool isUser;
  final String message;

  const ChatMessage({Key? key, required this.isUser, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            gradient: LinearGradient(
              colors: isUser
                  ? [
                      Colors.blue,
                      Colors.blue.shade300,
                    ]
                  : [
                      Colors.teal.shade100,
                      Colors.teal.shade200,
                      Colors.teal.shade300,
                    ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Text(
            message,
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
