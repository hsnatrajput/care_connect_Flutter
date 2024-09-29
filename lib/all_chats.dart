import 'package:care_connect/chat_with.dart';
import 'package:flutter/material.dart';



class ChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFABD5D5),
      appBar: AppBar(
        title: Text('Chats'),
      ),
      body: ListView(
        children: [
          _buildChatItem(context,'Dr. Ayesha Ali', 'assets/images/doc1.png', '10:30 AM'),
          _buildChatItem(context , 'Dr. Muhammad Ali', 'assets/images/doc2.png', '9:15 AM'),
          _buildChatItem(context , 'Dr. Minahil Munawar', 'assets/images/doc3.png', 'Yesterday'),
          _buildChatItem(context , 'Dr. Ahmad Hasnam', 'assets/images/doc4.png', '2 days ago'),
          // Add more chat items as needed
        ],
      ),
    );
  }

  Widget _buildChatItem( BuildContext context , String name, String imagePath, String time) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(imagePath), // Add your profile image asset here
      ),
      title: Text(name),
      subtitle: Text(time),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (c)=>ChatScreen()));
      },
    );
  }
}
