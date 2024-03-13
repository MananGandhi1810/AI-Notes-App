import 'package:ai_notes_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:markdown_editor_plus/markdown_editor_plus.dart';
import 'package:provider/provider.dart';

import '../models/note_model.dart';
import '../providers/notes_provider.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key, required this.id});

  final int id;

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  NoteModel? _note;
  final TextEditingController _controller = TextEditingController(text: "");
  final model = GenerativeModel(
      model: 'gemini-pro', apiKey: Constants.apiKey);

  @override
  void initState() {
    setState(() {
      _note = Provider.of<NotesProvider>(context, listen: false)
          .notes
          .firstWhere((element) => element.id == widget.id);
    });
    _controller.text = _note!.content;
    super.initState();
  }

  Future<void> generateSummary() async {
    final summary = await model.generateContent([
      Content.text(
          "This is a note written by me: ${_note!.content}\n\n\nSummarize it."),
    ]);
    setState(() {
      _note = _note!.copyWith(summary: summary.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_note!.title),
        actions: [
          IconButton(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const SizedBox(
                    height: 100,
                    width: 100,
                    child: CircularProgressIndicator(),
                  );
                },
              );
              await generateSummary();
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Summary'),
                    content: Text(_note!.summary ?? "No summary available"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.summarize),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Edit Title'),
                    content: TextField(
                      controller: TextEditingController(text: _note!.title),
                      onChanged: (value) {
                        setState(() {
                          _note = _note!.copyWith(title: value);
                        });
                      },
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Provider.of<NotesProvider>(context, listen: false)
                              .updateNotes(_note!);
                          Navigator.pop(context);
                        },
                        child: const Text('Done'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              Provider.of<NotesProvider>(context, listen: false)
                  .deleteNotes(_note!.id);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: MarkdownField(
        controller: _controller,
        decoration: const InputDecoration(
          hintText: 'Your note here',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
        maxLines: null,
        minLines: null,
        expands: true,
        onChanged: (value) {
          setState(() {
            Provider.of<NotesProvider>(context, listen: false).updateNotes(
              _note!.copyWith(content: value),
            );
          });
        },
      ),
    );
  }
}
