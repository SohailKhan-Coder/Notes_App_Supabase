import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailsView extends StatefulWidget {
  final int? noteId;          // Null = Add, Not null = Edit
  final String? initialTitle; // For editing
  final String? initialBody;  // For editing

  const DetailsView({super.key, this.noteId, this.initialTitle, this.initialBody});

  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  late TextEditingController _titleController;
  late TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _bodyController = TextEditingController(text: widget.initialBody ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.noteId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edit Note" : "Add Note"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Title Field
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: "Enter title...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),

            // Body Field
            TextFormField(
              controller: _bodyController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Enter your note...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final title = _titleController.text.trim();
                    final body = _bodyController.text.trim();
                    if (title.isEmpty || body.isEmpty) return;

                    final supabase = Supabase.instance.client;

                    if (isEditing) {
                      // Update existing note
                      await supabase
                          .from('notes')
                          .update({'title': title, 'body': body})
                          .eq('id', widget.noteId!);
                    } else {
                      // Add new note
                      await supabase.from('notes').insert({
                        'title': title,
                        'body': body,
                        'created_at': DateTime.now().toIso8601String(),
                      });
                    }

                    Navigator.of(context).pop();
                  },
                  child: Text(isEditing ? "Update" : "Save"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
