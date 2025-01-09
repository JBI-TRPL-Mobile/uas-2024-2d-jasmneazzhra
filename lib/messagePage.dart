import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:io'; // Import dart:io for file handling
import 'package:path_provider/path_provider.dart'; // For accessing local storage
import 'package:template_project/models/message.dart'; // Import model Message

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  TextEditingController _messageController = TextEditingController();
  List<Message> _messages = [];

  // Load messages from the local file
  Future<void> _loadMessages() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/datamessage.json');

    if (file.existsSync()) {
      final String response = await file.readAsString();
      final data = json.decode(response);
      setState(() {
        _messages = (data['messages'] as List)
            .map((messageData) => Message.fromJson(messageData))
            .toList();
      });
    }
  }

  // Save messages to the local file
  Future<void> _saveMessages() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/datamessage.json');

    // Convert messages to JSON
    List<Map<String, dynamic>> jsonMessages =
        _messages.map((message) => message.toJson()).toList();

    final Map<String, dynamic> data = {'messages': jsonMessages};
    await file.writeAsString(json.encode(data)); // Save to file
  }

  // Add a new message
  void _addMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _messages.add(Message(sender: 'You', content: _messageController.text, recipient: ''));
        _messageController.clear();
      });
      _saveMessages(); // Save the new list to the file
    }
  }

  @override
  void initState() {
    super.initState();
    _loadMessages(); // Load messages when the page is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            onSelected: (value) {},
            itemBuilder: (BuildContext context) {
              return {'Settings', 'Logout'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed:
                      _addMessage, // Call _addMessage when send button is pressed
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message.sender,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              message.content,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
