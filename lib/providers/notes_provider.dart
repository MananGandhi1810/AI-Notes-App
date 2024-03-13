import 'package:ai_notes_app/repositories/notes_repository.dart';
import 'package:flutter/cupertino.dart';

import '../models/note_model.dart';

class NotesProvider extends ChangeNotifier {
  List<NoteModel> _notes = [];
  final NotesRepository _notesRepository = NotesRepository();

  List<NoteModel> get notes => _notes;

  void getNotes() async {
    _notes = await _notesRepository.getNotes();
    notifyListeners();
  }

  void newNote() {
    _notes.add(
      NoteModel(
        id: DateTime.now().millisecondsSinceEpoch,
        title: 'New Note',
        content: '',
        date: DateTime.now(),
      ),
    );
    _notesRepository.saveNotes(_notes);
    notifyListeners();
  }

  void deleteNotes(int id) {
    _notes.removeWhere((note) => note.id == id);
    _notesRepository.saveNotes(_notes);
    notifyListeners();
  }

  void updateNotes(NoteModel note) {
    final index = _notes.indexWhere((n) => n.id == note.id);
    _notes[index] = note;
    _notesRepository.saveNotes(_notes);
    notifyListeners();
  }
}
