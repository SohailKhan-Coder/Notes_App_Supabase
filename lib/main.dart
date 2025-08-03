import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://tqrisyyqskqqddztinhy.supabase.co',
    anonKey:
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRxcmlzeXlxc2txcWRkenRpbmh5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTM2MTU2MjcsImV4cCI6MjA2OTE5MTYyN30.UAiCer8eUOkh_syV4tc1fiB_LoHdyi_-ywc9c5ZcBoE',
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
      debugShowCheckedModeBanner: false,
      home: HomeView(),
    );
  }
}

