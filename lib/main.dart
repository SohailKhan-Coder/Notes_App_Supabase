import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'SUPABASE_URL',
    anonKey:
    'ANON_KEY',
  );
  runApp(NotesApp());
}

class NotesApp extends StatefulWidget {
  @override
  State<NotesApp> createState() => _NotesAppState();
}

class _NotesAppState extends State<NotesApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}
