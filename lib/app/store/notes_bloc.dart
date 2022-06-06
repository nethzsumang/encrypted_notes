import 'package:flutter_bloc/flutter_bloc.dart';

abstract class NotesEvent {}
class NotesFetchDoneEvent extends NotesEvent {
  List<Map> data;

  NotesFetchDoneEvent(this.data);
}

class NotesBloc extends Bloc<NotesEvent, List> {
  NotesBloc() : super([]) {
    on<NotesFetchDoneEvent>((event, emit) {
      emit(event.data);
    });
  }
}