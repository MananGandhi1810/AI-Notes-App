import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'presentation/home_page.dart';
import 'providers/notes_provider.dart';

void main() async {
  runApp(const RootApp());
}

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NotesProvider(),
      child: MaterialApp(
        title: 'AI Notes App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomePage(),
      ),
    );
  }
}
