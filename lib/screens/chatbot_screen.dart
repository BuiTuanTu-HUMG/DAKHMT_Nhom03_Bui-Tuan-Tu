import 'package:flutter/material.dart';
import '../service/chatbot_service.dart';

class ChatbotScreen extends StatefulWidget {
  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Object? args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is String && args.isNotEmpty) {
      _handleInitialPrompt(args);
    }
  }

  void _handleInitialPrompt(String prompt) async {
    setState(() {
      _messages.add({'sender': 'user', 'text': prompt});
      _isLoading = true;
    });

    final response = await ChatbotService.getChatResponse(prompt);

    setState(() {
      _messages.add({'sender': 'bot', 'text': response ?? 'Không có phản hồi từ chatbot.'});
      _isLoading = false;
    });
  }

  void _sendMessage() async {
    String input = _controller.text.trim();
    if (input.isNotEmpty) {
      setState(() {
        _messages.add({'sender': 'user', 'text': input});
        _isLoading = true;
        _controller.clear();
      });

      String? response = await ChatbotService.getChatResponse(input);

      setState(() {
        _messages.add({'sender': 'bot', 'text': response ?? 'Không có phản hồi từ chatbot.'});
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chatbot sức khỏe")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isLoading && index == _messages.length) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Đang phản hồi...", style: TextStyle(fontStyle: FontStyle.italic)),
                    ),
                  );
                }
                final msg = _messages[index];
                final isUser = msg['sender'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.teal[100] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(msg['text'] ?? ''),
                  ),
                );
              },
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: "Nhập câu hỏi..."),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
