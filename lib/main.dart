import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_yooz/yooz/yooz.dart';


void main() async {
  runApp(run());
}



class run extends StatefulWidget {
  const run({super.key});
  @override
  State<run> createState() => _runState();
}
class _runState extends State<run> {
  String code = """
(
   + hello
   -Hi, I'm Chatbot Yuz! How can I help you
)
  """;
  @override
  Widget build(BuildContext context) {
    return ChatScreen(code: code);
  }
}


class ChatScreen extends StatefulWidget {
  final String code;
  ChatScreen({required this.code});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> messages = [
  ];
  final TextEditingController _controller = TextEditingController();
  final parser = Parser();
  @override
  void initState() {
    parser.loadPatterns(widget.code);
    super.initState();
  }
  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        messages.add(Message(text: _controller.text, isBot: false));
        messages.add(Message(text: parser.parse(_controller.text), isBot: true));
        _controller.clear();
      });
    }
  }

  void _clearMessage(){
    setState(() {
      messages.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: _clearMessage, icon: Icon(Icons.restart_alt))
          ],
          title: Text("Chat Bot"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back), // آیکون دکمه بازگشت
            onPressed: () {
              SystemNavigator.pop();
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return Align(
                    alignment: messages[index].isBot
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: messages[index].isBot
                            ? Colors.blue
                            : Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(messages[index].text, style: TextStyle(fontSize: 16, color: Colors.white ), textAlign: TextAlign.end,),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (value) => _sendMessage(),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Message {
  final String text;
  final bool isBot;

  Message({required this.text, required this.isBot});
}