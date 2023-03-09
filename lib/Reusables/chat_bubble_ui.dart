import 'package:flash_chat/Functions/helpers/convert_firebase_timestamp.dart';
import 'package:flash_chat/Reusables/palettes.dart';
import 'package:flutter/material.dart';

enum ChatBubbleClipper { left, right }

class CloneChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final bool isGroupChat;
  final String cloneName;
  final DateTime time;
  final ChatBubbleClipper clipper;

  const CloneChatBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.cloneName,
    required this.time,
    this.isGroupChat = false,
    this.clipper = ChatBubbleClipper.left,
  });

  @override
  Widget build(BuildContext context) {
    final timeStamp = time.toString().substring(11, 16);
    final chatTime = convertTime(timeStamp);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: isMe ? appBarColor2 : Colors.grey.shade200,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(15),
                topRight: const Radius.circular(15),
                bottomLeft:
                    isMe ? const Radius.circular(15) : const Radius.circular(0),
                bottomRight:
                    isMe ? const Radius.circular(0) : const Radius.circular(15),
              ),
            ),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isMe ? 'You' : cloneName,
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
                  chatTime,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
