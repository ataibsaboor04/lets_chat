import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lets_chat/widgets/chat_messages.dart';
import 'package:lets_chat/widgets/new_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String username = '';
  String imageURL = '';
  bool _isLoading = false;

  void setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;
    final notificationSettings = await fcm.requestPermission();
    // final token = await fcm.getToken();

    fcm.subscribeToTopic('chat');
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    setupPushNotifications();
  }

  void _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser!;
    setState(() {
      _isLoading = true;
    });
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    username = userData.data()!['username'];
    imageURL = userData.data()!['image_url'];
    setState(() {
      _isLoading = false;
    });
  }

  void _showProfileModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              CircleAvatar(
                backgroundImage:
                    !_isLoading ? CachedNetworkImageProvider(imageURL) : null,
                backgroundColor: Theme.of(context).colorScheme.primary,
                radius: 50.0,
              ),
              const SizedBox(height: 16.0),
              Text(
                username,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 163, 148, 148),
        appBar: AppBar(
          title: const Text('Let\'s Chat'),
          leading: Container(
            padding: const EdgeInsets.all(11.0),
            child: Hero(
              tag: 'lets_chat_logo',
              child: Image.asset(
                'assets/lets_chat.png',
                height: 35,
                width: 35,
              ),
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: Icon(
                  Icons.exit_to_app,
                  color: Theme.of(context).colorScheme.primary,
                )),
            IconButton(
              icon: CircleAvatar(
                backgroundImage:
                    !_isLoading ? CachedNetworkImageProvider(imageURL) : null,
                backgroundColor: Theme.of(context).colorScheme.primary,
                radius: 17,
              ),
              onPressed: () {
                // Show the profile modal when the button is tapped
                _showProfileModal(context);
              },
            ),
          ],
        ),
        body: const Column(
          children: [
            Expanded(child: ChatMessages()),
            NewMessage(),
          ],
        ));
  }
}
