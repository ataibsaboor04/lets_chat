import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:lets_chat/screens/chat.dart';
import 'firebase_options.dart';

import 'package:lets_chat/screens/authentication.dart';
import 'package:lets_chat/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initialize();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Let\'s Chat',
        theme: ThemeData().copyWith(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 94, 138, 166),
          ),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/home': (context) => StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const StaticSplashScreen();
                  }

                  if (snapshot.hasData) {
                    return const ChatScreen();
                  }
                  return const AuthenticationScreen();
                },
              ),
        });
  }
}

void initialize() async {
  await FlutterNotificationChannel.registerNotificationChannel(
    description: 'Chat messages pop up.',
    id: 'let\'s_chat/chat',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'Let\'s Chat - Message Received',
  );
}
