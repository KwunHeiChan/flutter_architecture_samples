import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';

class AppState {
  bool isLoading;
  List<Todo> todos;

  AppState({
    this.isLoading = false,
    this.todos = const [],
  });

  factory AppState.loading() => new AppState(isLoading: true);

  bool get allComplete => todos.every((todo) => todo.complete);

  List<Todo> filteredTodos(VisibilityFilter activeFilter) =>
      todos.where((todo) {
        if (activeFilter == VisibilityFilter.all) {
          return true;
        } else if (activeFilter == VisibilityFilter.active) {
          return !todo.complete;
        } else if (activeFilter == VisibilityFilter.completed) {
          return todo.complete;
        }
      }).toList();

  bool get hasCompletedTodos => todos.any((todo) => todo.complete);

  @override
  int get hashCode => todos.hashCode ^ isLoading.hashCode;

  int get numActive =>
      todos.fold(0, (sum, todo) => !todo.complete ? ++sum : sum);

  int get numCompleted =>
      todos.fold(0, (sum, todo) => todo.complete ? ++sum : sum);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          todos == other.todos &&
          isLoading == other.isLoading;

  void clearCompleted() {
    todos.removeWhere((todo) => todo.complete);
  }

  void toggleAll() {
    final allCompleted = this.allComplete;

    todos.forEach((todo) => todo.complete = !allCompleted);
  }

  Map<String, Object> toJson() {
    return {
      "todos": todos.map((todo) => todo.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'AppState{todos: $todos, isLoading: $isLoading}';
  }

  static AppState fromJson(Map<String, Object> json) {
    final todos = (json["todos"] as List<Map<String, Object>>)
        .map((todoJson) => Todo.fromJson(todoJson))
        .toList();

    return new AppState(
      todos: todos,
    );
  }
}

enum AppTab { todos, stats }

enum ExtraAction { toggleAllComplete, clearCompleted }

class Todo {
  bool complete;
  String id;
  String note;
  String task;

  Todo(this.task, {this.complete = false, this.note = '', String id})
      : this.id = id ?? new Uuid().generateV4();

  @override
  int get hashCode =>
      complete.hashCode ^ task.hashCode ^ note.hashCode ^ id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Todo &&
          runtimeType == other.runtimeType &&
          complete == other.complete &&
          task == other.task &&
          note == other.note &&
          id == other.id;

  Map<String, Object> toJson() {
    return {
      "complete": complete,
      "task": task,
      "note": note,
      "id": id,
    };
  }

  @override
  String toString() {
    return 'Todo{complete: $complete, task: $task, note: $note, id: $id}';
  }

  static Todo fromJson(Map<String, Object> json) {
    return new Todo(
      json["task"] as String,
      complete: json["complete"] as bool,
      note: json["note"] as String,
      id: json["id"] as String,
    );
  }
}

enum VisibilityFilter { all, active, completed }
