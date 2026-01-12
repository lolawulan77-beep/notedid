import 'package:flutter/material.dart';
import 'db/database_helper.dart';
import 'model/note.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotePage(),
    );
  }
}

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final TextEditingController controller = TextEditingController();
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  Future<void> loadNotes() async {
    notes = await DatabaseHelper.instance.getNotes();
    setState(() {});
  }

  Future<void> addNote() async {
    if (controller.text.isEmpty) return;
    await DatabaseHelper.instance.insertNote(
      Note(title: controller.text),
    );
    controller.clear();
    loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('📝 My Notes')),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (_, i) => Card(
          child: ListTile(
            title: Text(notes[i].title),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await DatabaseHelper.instance.deleteNote(notes[i].id!);
                loadNotes();
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Tambah Catatan'),
            content: TextField(controller: controller),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal')),
              ElevatedButton(
                child: const Text('Simpan'),
                onPressed: () {
                  addNote();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
