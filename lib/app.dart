import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DLApp extends StatefulWidget {
  const DLApp({super.key});

  @override
  State<DLApp> createState() => _DLAppState();
}

class _DLAppState extends State<DLApp> {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'DL',
        theme: ThemeData(primarySwatch: Colors.blue),
      ),
    );
  }
}
