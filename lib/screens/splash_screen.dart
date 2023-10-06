import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _imageAnimationController;
  late AnimationController _slideAnimationController;
  late Animation<double> _imageAnimation;
  String _typedName = '';
  int _currentIndex = 0;
  final List<String> _nameLetters = 'Ataib Saboor'.split('');
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _imageAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _slideAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _imageAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _imageAnimationController,
      curve: Curves.elasticOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideAnimationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimationController.forward();
    Future.delayed(const Duration(seconds: 1), () {
      _imageAnimationController.forward();
      _startTypingName();
    });
  }

  void _startTypingName() {
    const typingDuration = Duration(milliseconds: 150);

    Timer.periodic(typingDuration, (timer) {
      if (_currentIndex < _nameLetters.length) {
        setState(() {
          _typedName += _nameLetters[_currentIndex];
          _currentIndex++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacementNamed('/home');
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 94, 138, 166),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SlideTransition(
                position: _slideAnimation,
                child: const Text(
                  "Let's Chat",
                  style: TextStyle(
                    fontSize: 36,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              AnimatedBuilder(
                animation: _imageAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _imageAnimation.value,
                    child: child,
                  );
                },
                child: Hero(
                  tag: 'lets_chat_logo',
                  child: Image.asset(
                    'assets/lets_chat.png',
                    width: 150,
                    height: 150,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SlideTransition(
                position: _slideAnimation,
                child: const Text(
                  "Developed by",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SlideTransition(
                position: _slideAnimation,
                child: Text(
                  _typedName,
                  style: const TextStyle(
                    fontSize: 26,
                    color: Color.fromARGB(255, 242, 219, 13),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _imageAnimationController.dispose();
    super.dispose();
  }
}

class StaticSplashScreen extends StatelessWidget {
  const StaticSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 94, 138, 166),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Let's Chat",
                style: TextStyle(
                  fontSize: 36,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Hero(
                tag: 'lets_chat_logo',
                child: Image.asset(
                  'assets/lets_chat.png',
                  width: 150,
                  height: 150,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Developed by",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Ataib Saboor',
                style: TextStyle(
                  fontSize: 26,
                  color: Color.fromARGB(255, 242, 219, 13),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
