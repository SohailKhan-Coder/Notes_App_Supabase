import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app_supabase/details_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // Real-time notes stream
  final _noteStream =
  Supabase.instance.client.from('notes').stream(primaryKey: ['id']);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        title: const Text("Notes Keeper App"),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _noteStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final notes = snapshot.data!;
          if (notes.isEmpty) {
            return const Center(child: Text("No notes available"));
          }
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];

              String formattedDate = "";
              if (note['created_at'] != null) {
                final date = DateTime.parse(note['created_at']);
                formattedDate =
                    DateFormat('dd MMM yyyy, hh:mm a').format(date);
              }

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(note['title'] ?? '',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  subtitle: Text(
                    "${note['body'] ?? ''}\n$formattedDate",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Edit Button
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => DetailsView(
                                noteId: note['id'],
                                initialTitle: note['title'],
                                initialBody: note['body'],
                              ),
                            ),
                          );
                        },
                      ),
                      // Delete Button
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
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
          // Navigate to DetailsView to add a new note
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const DetailsView(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
