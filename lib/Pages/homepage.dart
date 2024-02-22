import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_bro/Utils/new_task.dart';

import '../Utils/Todotile.dart';
import '../Utils/database.dart';

class homepage_main extends StatefulWidget {
  final String names;

  const homepage_main(this.names);

  @override
  State<homepage_main> createState() => _homepage_mainState();
}

class _homepage_mainState extends State<homepage_main> {
  late String _name;

  final TextEditingController _controllerTaskName = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();
  final TextEditingController _controllerDate = TextEditingController();

  final _myBox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    // TODO: implement initState
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      // there already exists data
      db.loadData();
    }
    super.initState();
    _name = widget.names;
  }

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.todoList[index][1] = !db.todoList[index][1];
    });
  }

  void createNewTask() {
    showDialog(
        context: context,
        builder: (context) {
          return new_task(
            controllerDescription: _controllerDescription,
            controllerTaskName: _controllerTaskName,
            controllerDate: _controllerDate,
            onSave: saveNewTask,
            onCancel: () {
              Navigator.of(context).pop();
              _controllerTaskName.clear();
              _controllerDescription.clear();
            },
          );
        });
  }

  void saveNewTask() {
    setState(() {
      db.todoList
          .add([_controllerTaskName.text, false, _controllerDescription.text,_controllerDate.text]);
      _controllerTaskName.clear();
      _controllerDescription.clear();
      _controllerDate.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  void editTask(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return new_task(
            controllerDescription: _controllerDescription,
            controllerTaskName: _controllerTaskName,
            controllerDate: _controllerDate,
            taskname: db.todoList[index][0],
            description: db.todoList[index][2],
            taskDate: db.todoList[index][3],
            onSave: () => saveEdit(index),
            onCancel: () {
              Navigator.of(context).pop();
              _controllerTaskName.clear();
              _controllerDescription.clear();
            },
          );
        });
  }

  void saveEdit(int index) {
    setState(() {
      db.todoList[index][0] = _controllerTaskName.text;
      db.todoList[index][2]=_controllerDescription.text;
      db.todoList[index][3]=_controllerDate.text;
      _controllerTaskName.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  void deleteTask(int index) {
    setState(() {
      db.todoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 246, 248, 250),
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 246, 248, 250),
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.filter_list_rounded,
                color: Color.fromARGB(255, 146, 158, 191),
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Icon(
                      Icons.search,
                      color: Color.fromARGB(255, 146, 158, 191),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 5, 0),
                    child: Icon(
                      Icons.notifications_none_outlined,
                      color: Color.fromARGB(255, 146, 158, 191),
                    ),
                  ),
                ],
              )
            ],
          )),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: Stack(
          children: [
            Text(
              "Hello $_name,",
              style: const TextStyle(
                fontSize: 38,
                color: Colors.black87,
                fontWeight: FontWeight.w900,
              ),
              textAlign: TextAlign.start,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 10),
              child: SizedBox(
                height: double.infinity,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Today's Task",
                            style: TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 173, 183, 206),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.redAccent),
                            child: const Text(
                              "See All",
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 115, 90),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SingleChildScrollView(
                              // physics: const ScrollPhysics(),
                              child: Column(
                                children: [
                                  ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: db.todoList.length,
                                      itemBuilder: (context, index) {
                                        return Todotile(
                                          onChanged: (value) {
                                            checkBoxChanged(value, index);
                                          },
                                          taskname: db.todoList[index][0],
                                          taskDescription: db.todoList[index][2],
                                          taskDate: db.todoList[index][3],
                                          taskcompleted: db.todoList[index][1],
                                          editTask: () {
                                            editTask(index);
                                          },
                                          deleteTask: (context) {
                                            deleteTask(index);
                                          },
                                        );
                                      }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    createNewTask();
                  },
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all(5.0),
                      shadowColor: MaterialStateProperty.all(
                          Color.fromARGB(255, 255, 115, 90)),
                      backgroundColor: MaterialStateProperty.all(
                          Color.fromARGB(255, 255, 115, 90))),
                  child: const Text(
                    "Create task",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
