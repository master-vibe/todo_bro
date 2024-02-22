import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Todotile extends StatelessWidget {
  final String taskname;
  final String? taskDescription;
  final String? taskDate;
  final bool taskcompleted;
  Function(bool?)? onChanged;
  final void Function()? editTask;
  final void Function(BuildContext)? deleteTask;

  Todotile({
    super.key,
    required this.taskcompleted,
    required this.taskname,
    required this.taskDate,
    this.taskDescription,
    required this.onChanged,
    this.editTask,
    this.deleteTask,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 20, 15),
      child: Slidable(
        endActionPane: ActionPane(motion: const StretchMotion(), children: [
          SlidableAction(
            onPressed: deleteTask,
            icon: Icons.delete,
            backgroundColor: Colors.red.shade300,
            borderRadius: BorderRadius.circular(12),
          )
        ]),
        child: Container(
          height: 75,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              gradient: RadialGradient(
                center: Alignment.bottomCenter,
                radius: 5,
                colors: [
                  Color.fromARGB(255, 157, 136, 251),
                  Color.fromARGB(150, 157, 136, 251)
                ],
              ),
              boxShadow: [
                BoxShadow(
                    color: Color.fromARGB(255, 157, 136, 251),
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: Offset(0, 4))
              ]),
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Checkbox(
                        value: taskcompleted,
                        onChanged: onChanged,
                        activeColor: Colors.black87,
                        checkColor: Colors.white),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            taskname,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                decoration: taskcompleted
                                    ? TextDecoration.combine(
                                        [TextDecoration.lineThrough])
                                    : TextDecoration.none,
                                decorationThickness: 2,
                                decorationColor: Colors.black87,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Row(
                            children: [
                              Visibility(
                                visible: taskDate!="",
                                child: const Icon(
                                  Icons.calendar_month_rounded,
                                  size: 12,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(2, 0, 15, 0),
                                child: Text(
                                  "Due Date : ${taskDate!}",
                                  style: TextStyle(
                                      decorationColor: Colors.black87,
                                      fontSize: taskDate != "" ? 13 : 0,
                                      color: Colors.white70),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            taskDescription!,
                            style: TextStyle(
                                decorationColor: Colors.black87,
                                fontSize: taskDescription != "" ? 12 : 0,
                                fontWeight: FontWeight.w500,
                                color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => editTask!(),
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white70,
                      size: 19,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
