import 'dart:convert';
import 'dart:io';
import 'package:ToCheck/model/todo.dart';
import 'package:path_provider/path_provider.dart';

class ToDoService {
  static Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/todos.txt';
  }

  static Future<List<ToDo>> readToDos() async {
    try {
      final filePath = await _getFilePath();
      final file = File(filePath);
      if (!await file.exists()) {
        return [];
      }
      final contents = await file.readAsString();
      final List<dynamic> jsonData = jsonDecode(contents);
      return jsonData.map((json) => ToDo.fromJson(json)).toList();
    } catch (e) {
      print('Error reading todos: $e');
      return [];
    }
  }

  static Future<void> writeToDos(List<ToDo> todos) async {
    try {
      final filePath = await _getFilePath();
      final file = File(filePath);
      final jsonData = todos.map((todo) => todo.toJson()).toList();
      await file.writeAsString(jsonEncode(jsonData));
    } catch (e) {
      print('Error writing todos: $e');
    }
  }
}