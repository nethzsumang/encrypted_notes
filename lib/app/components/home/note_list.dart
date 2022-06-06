import 'dart:async';
import 'package:after_layout/after_layout.dart';
import 'package:encrypted_notes/app/libraries/secure_storage_library.dart';
import 'package:encrypted_notes/app/services/note_service.dart';
import 'package:encrypted_notes/app/store/notes_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class NoteList extends StatefulWidget {
  const NoteList({Key? key}) : super(key: key);

  @override
  NoteListState createState() => NoteListState();
}

class NoteListState extends State<NoteList> with AfterLayoutMixin<NoteList> {
  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    final goRouter = GoRouter.of(context);
    final notesBlocContext = context.read<NotesBloc>();
    SecureStorageLibrary secureStorageLibrary = SecureStorageLibrary();
    NoteService noteService = NoteService();
    String? userNo = await secureStorageLibrary.getValue('userNo');
    String? k1 = await secureStorageLibrary.getValue('k1');

    if (userNo == null || k1 == null) {
      EasyLoading.showError('You are not logged in.');
      goRouter.push('/');
    }

    Map response = await noteService.getUserNotes(int.parse(userNo!));
    if (response['success'] == false) {
      EasyLoading.showError('Failed fetching your notes. Please restart the app.');
      return;
    }

    List notes = response['data'];
    notesBlocContext.add(NotesFetchDoneEvent(notes));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesBloc, List>(
      builder: (context, notes) {
        if (notes.isEmpty) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: Text('You currently have no notes.')
              )
            ],
          );
        }
        return SizedBox(
          width: double.infinity,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Title'))
            ],
            rows: notes.map((note) => DataRow(
              cells: [
                DataCell(Text(note['title']))
              ]
            )).toList()
          )
        );
      }
    );
  }

}