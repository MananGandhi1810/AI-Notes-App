import 'dart:convert';

import 'package:ai_notes_app/models/note_model.dart';

import '../services/storage_service.dart';

class NotesRepository{
  final StorageService _storageService = StorageService();

  Future<List<NoteModel>> getNotes() async {
    final notesStr = await _storageService.readData(key: 'notes');
    if (notesStr != null) {
      var notesList = jsonDecode(notesStr);
      final List<NoteModel> notes = [];
      for (var note in notesList) {
        notes.add(NoteModel.fromJson(note));
      }
      return notes;
    }
    return [];
  }

  Future<void> saveNotes(List<NoteModel> notes) async {
    final notesStr = jsonEncode(notes);
    await _storageService.writeData(key: 'notes', value: notesStr);
  }
}