import 'package:flutter/material.dart';

void _scrollToBottom(BuildContext context) {
  final ScrollController scrollController =
      PrimaryScrollController.of(context)!;
  scrollController.animateTo(
    scrollController.position.maxScrollExtent,
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeOut,
  );
}

class ScrollToBottom extends StatelessWidget {
  const ScrollToBottom({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _scrollToBottom(context));
    return child;
  }
}
