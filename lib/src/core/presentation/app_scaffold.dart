import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget child;
  final Widget? floatingActionButton;
  final Color? backgroundColor;

  const AppScaffold({
    super.key,
    required this.child,
    this.appBar,
    this.floatingActionButton,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: appBar,
        floatingActionButton: floatingActionButton,
        resizeToAvoidBottomInset: true,
        backgroundColor: backgroundColor,
        body: SafeArea(child: child),
      ),
    );
  }
}
