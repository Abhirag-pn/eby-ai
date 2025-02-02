import 'package:eby/pages/quizapage.dart';
import 'package:eby/widgets/customtextfeild.dart';
import 'package:eby/widgets/smallbouncingbutton.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> with SingleTickerProviderStateMixin {
  final _topicController = TextEditingController();
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _topicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated Background
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: BackgroundPainter(_controller.value),
                child: Container(),
              );
            },
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  // Quiz Icon
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 900),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.quiz_rounded,
                      size: 60,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Title
                 Text(
              "QUICK QUIZ",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.white, fontFamily: 'Bowl'),
            ),
                  const SizedBox(height: 40),
                  // Topic Input Field
                  CustomTextFeild(hinttext: "ENTER TOPIC", controller: _topicController),
                  const SizedBox(height: 30),
                  // Start Button
                  SmallBouncingTextButton(
              button: 'assets/images/next.png',
              action: () {

                if (_topicController.text.trim().isNotEmpty) {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizAPage(
                        topic: _topicController.text.trim(),
                      ),
                    ),
                  );
                  
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a topic'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final double animationValue;

  BackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    
    // Base gradient background
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF43A047),
        Color(0xFF66BB6A),
        Color(0xFF81C784),
      ],
    );
    paint.shader = gradient.createShader(rect);
    canvas.drawRect(rect, paint);

    // Animated circles
    final circlePaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    void drawCircle(double x, double y, double radius) {
      final offset = Offset(
        x + math.sin(animationValue * 2 * math.pi) * 20,
        y + math.cos(animationValue * 2 * math.pi) * 20,
      );
      canvas.drawCircle(offset, radius, circlePaint);
    }

    // Draw multiple floating circles
    drawCircle(size.width * 0.2, size.height * 0.2, 60);
    drawCircle(size.width * 0.8, size.height * 0.3, 40);
    drawCircle(size.width * 0.5, size.height * 0.6, 50);
    drawCircle(size.width * 0.15, size.height * 0.8, 30);
    drawCircle(size.width * 0.8, size.height * 0.9, 45);

    // Add some floating shapes
    final shapePaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    // Rotating squares
    canvas.save();
    canvas.translate(size.width * 0.3, size.height * 0.4);
    canvas.rotate(animationValue * 2 * math.pi);
    canvas.drawRect(
      Rect.fromCenter(center: Offset.zero, width: 40, height: 40),
      shapePaint,
    );
    canvas.restore();

    canvas.save();
    canvas.translate(size.width * 0.7, size.height * 0.7);
    canvas.rotate(-animationValue * 2 * math.pi);
    canvas.drawRect(
      Rect.fromCenter(center: Offset.zero, width: 60, height: 60),
      shapePaint,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}