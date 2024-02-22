import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_bro/Pages/homepage.dart';

void main() async {
  await Hive.initFlutter();
  var box = await Hive.openBox('mybox');
  WidgetsFlutterBinding.ensureInitialized();
  final result = await SharedPreferences.getInstance();
  bool isfirstlaunch=result.getBool('isfirstlaunch')??true;
  String saved_name = result.getString('_name')??"";

  runApp(myapp(
    isfirst: isfirstlaunch,
    name: saved_name,
  ));
}

class myapp extends StatelessWidget {
  myapp({super.key, this.isfirst,this.name});

  final isfirst;
  final name;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do Bro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true)
          .copyWith(scaffoldBackgroundColor: Colors.black),
      home: isfirst ? homepage() : homepage_main(name),
    );
  }
}

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  final _controller = TextEditingController();

  Future<bool> get isfirstlaunch async {
    final result = await SharedPreferences.getInstance();
    if (result.getBool('isfirstlaunch') == null) {
      result.setBool('isfirstlaunch', true);
    }
    print(result.getBool('isfirstlaunch'));
    return result.getBool('isfirstlaunch') ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(230, 225, 140, 229),
              Color.fromARGB(255, 236, 170, 240)
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'images/get_staeted.png',
              height: 350,
              width: 350,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: TextFormField(
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.white60,
                        width: 2.0,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(200),
                        right: Radius.circular(200)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.white60,
                        width: 2.0,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(200),
                        right: Radius.circular(200)),
                  ),
                  labelText: "Name",
                  labelStyle: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.black26,
                  ),
                ),
                style: const TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.bold),
                keyboardType: TextInputType.name,
                textAlign: TextAlign.center,
                controller: _controller,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                var name_got = _controller.text;
                RegExp regex = new RegExp(r'[A-Za-z]+');
                RegExpMatch? match = regex.firstMatch(name_got);
                name_got=match![0].toString();
                name_got=name_got.toLowerCase();
                name_got=name_got.replaceFirst(name_got[0], name_got[0].toUpperCase());
                final result = await SharedPreferences.getInstance();
                result.setString("_name", name_got);
                result.setBool('isfirstlaunch', false);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => homepage_main(name_got)));
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 255, 115, 90))),
              child: const Text(
                "Let's get started",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 25,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
