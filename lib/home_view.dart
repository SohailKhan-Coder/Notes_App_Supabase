import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _noteStream =
      Supabase.instance.client.from('notes').stream(primaryKey: ['id']);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _noteStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.indigo),
            );
          }
          final notes = snapshot.data!;
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];

              // Parse the date from Supabase (if exists)
              String dateText = "";
              if (note['created_at'] != null) {
                final date = DateTime.parse(note['created_at']);
                dateText = DateFormat('dd MMM yyyy, hh:mm a').format(date);
              }

              return Card(
                elevation: 10,
                child: ListTile(
                  title: Text(note['body'],style: TextStyle(color: Colors.indigo),),
                  subtitle: Text(dateText), // Show date here
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Edit Button
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _showEditDialog(note['id'], note['body']);
                        },
                      ),
                      // Delete Button
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await Supabase.instance.client
                              .from('notes')
                              .delete()
                              .eq('id', note['id']);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Note"),
        content: TextFormField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(hintText: "Enter your note..."),
        ),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text("Add"),
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                await Supabase.instance.client.from("notes").insert({
                  'body': controller.text,
                  'created_at': DateTime.now().toIso8601String(),
                });
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  void _showEditDialog(int id, String oldValue) {
    final controller = TextEditingController(text: oldValue);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Note"),
        content: TextFormField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(hintText: "Enter your note..."),
        ),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text("Save"),
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                await Supabase.instance.client
                    .from("notes")
                    .update({'body': controller.text}).eq('id', id);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
