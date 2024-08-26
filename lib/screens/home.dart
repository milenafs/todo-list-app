import 'package:ToCheck/services/todo.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';

import '../model/todo.dart';
import '../constants/colors.dart';
import '../widgets/todo_item.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ToDo> todosList = [];
  List<ToDo> _foundToDo = [];
  final _todoController = TextEditingController();
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 10));
    _loadToDos();
  }

  Future<void> _loadToDos() async {
    todosList = await ToDoService.readToDos() as List<ToDo>;
    setState(() {
      _foundToDo = todosList;
    });
  }

  void _updateToDoList() {
    // setState(() {
    //   // Update the todoList
    // });
    ToDoService.writeToDos(todosList);
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _throwConfetti() {
    print('Throwing Confetti');
    _confettiController.play();
    Future.delayed(const Duration(milliseconds: 1500), () {
      _confettiController.stop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Container(
            // backgroundColor: tdBlue,
            child: Column(
              children: [
                Container(
                  color: tdPrimary,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  margin: EdgeInsets.only(bottom: 10),
                  child: searchBox(),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    children: [
                      for (ToDo todoo in _foundToDo
                        ..sort((a, b) {
                          // If both don't have a start date, compare by isDone status
                          if (a.isDone && !b.isDone) return 1;
                          if (!a.isDone && b.isDone) return -1;

                          // First, compare by favorite status
                          if (a.isFavorited && !b.isFavorited) return -1;
                          if (!a.isFavorited && b.isFavorited) return 1;

                          // Then, compare by start date
                          if (a.startDate != null && b.startDate != null) {
                            return a.startDate!.compareTo(b.startDate!);
                          }

                          // If one of the todos doesn't have a start date, it comes after
                          if (a.startDate == null && b.startDate != null)
                            return 1;
                          if (a.startDate != null && b.startDate == null)
                            return -1;

                          // If both have the same isDone status, they are considered equal
                          return 0;
                        }))
                        ToDoItem(
                          todo: todoo,
                          onToDoChanged: _handleToDoChange,
                          onDeleteItem: _deleteToDoItem,
                          onFavoriteItem: _handleFavoriteItem,
                          onSetStartDateTime: _handleSetStartDateTime,
                          onSetEndDateTime: _handleSetEndDateTime,
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    bottom: 20,
                    right: 20,
                    left: 20,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 0.0),
                        blurRadius: 10.0,
                        spreadRadius: 0.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: _todoController,
                    decoration: InputDecoration(
                        hintText: 'Add a new todo item',
                        border: InputBorder.none),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  bottom: 20,
                  right: 20,
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(0),
                    backgroundColor: tdPrimary,
                    minimumSize: Size(60, 60),
                    maximumSize: Size(60, 60),
                    elevation: 10,
                  ),
                  child: IconButton(
                    color: Colors.white,
                    iconSize: 20,
                    icon: Icon(Icons.add),
                    onPressed: () {
                      _addToDoItem(_todoController.text);
                    },
                  ),
                  onPressed: () {},
                ),
              ),
            ]),
          ),
          Align(
            alignment: Alignment.center,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.red,
                Colors.blue,
                Colors.green,
                Colors.yellow,
                Colors.purple,
                Colors.orange,
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleFavoriteItem(ToDo todo) {
    setState(() {
      todo.isFavorited = !todo.isFavorited;
    });
    _updateToDoList();
  }

  void _handleSetStartDateTime(ToDo todo, DateTime startDate) {
    setState(() {
      todo.startDate = startDate;
    });
    _updateToDoList();
  }

  void _handleSetEndDateTime(ToDo todo, DateTime endDate) {
    setState(() {
      todo.endDate = endDate;
    });
    _updateToDoList();
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
      if (todo.isDone) {
        print('CONFETTI');
        _throwConfetti();
        _vibratePhone(500);
      }
    });
    _updateToDoList();
  }

  void _vibratePhone(int duration) async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: duration);
    }
    // Create an instance of AudioCache
    final player = AudioCache(prefix: 'assets/sounds/');
    // Play the sound
    await player.play('todo-completed.wav');
  }

  void _deleteToDoItem(String id) {
    setState(() {
      todosList.removeWhere((item) => item.id == id);
    });
    _updateToDoList();
  }

  void _addToDoItem(String toDo) {
    setState(() {
      final newToDo = ToDo(
        id: DateTime.now().toString(),
        todoText: toDo == '' ? 'What should I do?' : toDo,
        isFavorited: false,
        isDone: false,
        startDate: null,
        endDate: null,
      );
      todosList.add(newToDo);
      _foundToDo = todosList;
      _todoController.clear();
    });
    _updateToDoList();
  }

  void _runFilter(String enteredKeyword) {
    List<ToDo> results = [];
    if (enteredKeyword.isEmpty) {
      results = todosList;
    } else {
      results = todosList
          .where((item) => item.todoText!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundToDo = results;
    });
  }

  Widget searchBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: tdBlack,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: tdGrey),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: tdPrimary,
      elevation: 0,
      title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          child: Text(
            'TODO LIST',
            style: TextStyle(
              fontFamily: 'ThickerFont',
              color: Colors.white,
            ),
          ),
        ),
      ]),
    );
  }
}
