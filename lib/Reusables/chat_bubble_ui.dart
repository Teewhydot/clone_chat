// ignore_for_file: must_be_immutable

import 'package:flash_chat/Functions/helpers/custom_time_messages.dart';
import 'package:flash_chat/Models/constants.dart';
import 'package:flash_chat/Reusables/palettes.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class CloneChatBubble extends StatefulWidget {
  final String message;
  final bool isMe;
  final bool isGroupChat;
  final String cloneName;
  DateTime time;

  CloneChatBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.cloneName,
    required this.time,
    this.isGroupChat = false,
  });

  @override
  State<CloneChatBubble> createState() => _CloneChatBubbleState();
}

class _CloneChatBubbleState extends State<CloneChatBubble> {
  String time = '';
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    timeago.setLocaleMessages('en', MyCustomTimeMessages());
    time = timeago.format(widget.time);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment:
            widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: widget.isMe ? appBarColor2 : Colors.grey.shade200,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(15),
                topRight: const Radius.circular(15),
                bottomLeft: widget.isMe
                    ? const Radius.circular(15)
                    : const Radius.circular(0),
                bottomRight: widget.isMe
                    ? const Radius.circular(0)
                    : const Radius.circular(15),
              ),
            ),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                widget.isMe
                    ? Container()
                    : Text(
                        widget.cloneName,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                Text(
                  widget.message,
                  style: TextStyle(
                    color: widget.isMe ? Colors.white : Colors.grey.shade800,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                addVerticalSpacing(4),
                Text(
                  time,
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
