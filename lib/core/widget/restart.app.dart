import 'package:flutter/material.dart';

class RestarApp extends StatefulWidget {
  const RestarApp({super.key, required this.child});
  final Widget child;
  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestarAppState>()?.restartApp();
  }

  @override
  // ignore: library_private_types_in_public_api
  _RestarAppState createState() => _RestarAppState();
}

class _RestarAppState extends State<RestarApp> {
  Key key = UniqueKey();
  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
