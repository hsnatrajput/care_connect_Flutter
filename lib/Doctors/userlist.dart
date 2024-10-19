import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../chatScreen.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late Stream<List<Map<String, dynamic>>> _userListStream;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _userListStream = _firestore
        .collection('messages')
        .where('sender', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .asyncMap((snapshot) async {
      Set<String> userIds = {};
      List<Map<String, dynamic>> usersData = [];

      // Add all unique recipients from messages where the current user is the sender
      for (var doc in snapshot.docs) {
        final receiverId = doc['receiver'];
        if (!userIds.contains(receiverId)) {
          userIds.add(receiverId);
          final userSnapshot = await _firestore.collection('users').doc(receiverId).get();
          if (userSnapshot.exists) {
            final userData = userSnapshot.data() as Map<String, dynamic>;
            usersData.add({
              'userId': receiverId,
              'name': userData['name'],
              'email': userData['email'],
            });
          }
        }
      }

      // Also check for messages where the current user is the receiver
      final receiverMessages = await _firestore
          .collection('messages')
          .where('receiver', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      for (var doc in receiverMessages.docs) {
        final senderId = doc['sender'];
        if (!userIds.contains(senderId)) {
          userIds.add(senderId);
          final userSnapshot = await _firestore.collection('users').doc(senderId).get();
          if (userSnapshot.exists) {
            final userData = userSnapshot.data() as Map<String, dynamic>;
            usersData.add({
              'userId': senderId,
              'name': userData['name'],
              'email': userData['email'],
            });
          }
        }
      }

      return usersData;
    });
  }

  Widget _buildUserItem(Map<String, dynamic> userData) {
    return ListTile(
      title: Row(children: [
        const CircleAvatar(
          backgroundImage: AssetImage('assets/images/avatarman.png'),
        ),
        SizedBox(width: 10),
        Text(userData['name']),
      ]),
      subtitle: Text(userData['email']),
      onTap: () {
        // Navigate to chat screen with this user
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              senderId: FirebaseAuth.instance.currentUser!.uid,
              receiverId: userData['userId'],
              receiverName: userData['name'],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFABD5D5),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFABD5D5),
        title: Text('User List'),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _userListStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final List<Map<String, dynamic>> users = snapshot.data!;
          if (users.isEmpty) {
            return Center(
              child: Text('No users found'),
            );
          }
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final userData = users[index];
              return _buildUserItem(userData);
            },
          );
        },
      ),
    );
  }
}
