import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class new_task extends StatelessWidget {
  TextEditingController controllerTaskName;
  TextEditingController controllerDescription;
  TextEditingController controllerDate;
  final void Function()? onSave;
  final void Function()? onCancel;

  String? taskname;
  String? description;
  String? taskDate;

  new_task({
    super.key,
    required this.controllerTaskName,
    required this.controllerDescription,
    required this.controllerDate,
    required this.onSave,
    required this.onCancel,
    this.taskname,
    this.description,
    this.taskDate,
  });

  @override
  Widget build(BuildContext context) {
    if(taskname!=""){
      controllerTaskName.text=taskname??"";
    }
    if(description!=""){
      controllerDescription.text=description??"";
    }
    if(taskDate!=""){
      controllerDate.text=taskDate??"";
    }
    DateTime _date = DateTime.now();
    String _dateName = DateFormat('MMMM d, yyyy').format(_date);

    void _showdate(BuildContext context) async {
      await showDatePicker(
              context: context,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              initialDate: DateTime.now())
          .then((value) => _date = value!);
      _dateName = DateFormat('MMMM d, yyyy').format(_date);
      controllerDate.text = _dateName;
    }

    return AlertDialog(
      backgroundColor: Colors.white,
      content: SizedBox(
        height: 200,
        child: Column(
          children: [
            TextFormField(
              controller: controllerTaskName,
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 255, 115, 90),
                      width: 1.0,
                      style: BorderStyle.solid),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 255, 115, 90),
                      width: 1.5,
                      style: BorderStyle.solid),
                ),
                hintText: "New Task Name",
                hintStyle: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.w200),
              ),
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
              autocorrect: false,
              enableSuggestions: false,
            ),
            TextFormField(
              controller: controllerDescription,
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 255, 115, 90),
                      width: 1.0,
                      style: BorderStyle.solid),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 255, 115, 90),
                      width: 1.5,
                      style: BorderStyle.solid),
                ),
                hintText: "Description",
                hintStyle: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.w300),
              ),
              style: const TextStyle(
                color: Colors.black87,
              ),
              autocorrect: false,
              enableSuggestions: false,
            ),
            TextFormField(
              controller: controllerDate,
              decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 255, 115, 90),
                      width: 1.0,
                      style: BorderStyle.solid),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 255, 115, 90),
                      width: 1.5,
                      style: BorderStyle.solid),
                ),
                hintText: "Due Date : ${_dateName}",
                hintStyle: const TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.w300),
              ),
              onTap: () => _showdate(context),
              style: const TextStyle(
                color: Colors.black87,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: onCancel,
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all(5.0),
                      shadowColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 255, 115, 90)),
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 255, 115, 90))),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: ()=>onSave!(),
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all(5.0),
                      shadowColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 255, 115, 90)),
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 255, 115, 90))),
                  child: const Text(
                    "Save",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
