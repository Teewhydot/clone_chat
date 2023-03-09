import 'package:flutter/material.dart';

enum ChatBubbleClipper { left, right }

class CloneChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final bool isGroupChat;
  final ChatBubbleClipper clipper;

  const CloneChatBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.isGroupChat = false,
    this.clipper = ChatBubbleClipper.left,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        ClipPath(
          clipper: _ChatBubbleClipper(isMe: isMe, clipper: clipper),
          child: Container(
            padding: const EdgeInsets.all(12),
            color: isMe ? Colors.green : Colors.grey.shade200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isMe && isGroupChat)
                  Text(
                    'Sender Name',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                Text(
                  message,
                  style: TextStyle(
                    color: isMe ? Colors.white : Colors.grey.shade800,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '3:00 PM',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ChatBubbleClipper extends CustomClipper<Path> {
  final bool isMe;
  final ChatBubbleClipper clipper;

  _ChatBubbleClipper({required this.isMe, required this.clipper});

  @override
  Path getClip(Size size) {
    final path = Path();

    if (clipper == ChatBubbleClipper.right) {
      path.lineTo(size.width - 25, 0);
      path.quadraticBezierTo(
        size.width,
        0,
        size.width,
        25,
      );
      path.lineTo(size.width, size.height - 25);
      path.quadraticBezierTo(
        size.width,
        size.height,
        size.width - 25,
        size.height,
      );
    } else {
      path.moveTo(25, size.height);
      path.quadraticBezierTo(
        0,
        size.height,
        0,
        size.height - 25,
      );
      path.lineTo(0, 25);
      path.quadraticBezierTo(
        0,
        0,
        25,
        0,
      );
    }

    path.lineTo(size.width - 25, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_ChatBubbleClipper oldClipper) {
    return isMe != oldClipper.isMe || clipper != oldClipper.clipper;
  }
}
