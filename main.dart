import 'package:agenda/agenda.dart';
import 'package:agenda/agenda_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MainPage());
}

class MainPage extends StatelessWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AgendaData.getData();
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('fr', ''), // English, no country code
      ],
      home: Scaffold(
          appBar: AppBar(title: const Text("Mon agenda")),
          bottomNavigationBar: MainPageBottom(),
          body: MainPageBody()),
      routes: <String, WidgetBuilder>{
        '/agenda': (BuildContext context) => Agenda(),
      },
    );
  }
}

class MainPageBody extends StatelessWidget {
  const MainPageBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/agenda');
      },
      child: Container(
        padding: EdgeInsets.all(50),
        margin: EdgeInsets.all(30),
        width: MediaQuery.of(context).size.width,
        height: 200,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.blue),
        child: Column(children: [
          Image(
            image: NetworkImage(
                "https://img.icons8.com/plasticine/100/000000/calendar--v1.png"),
            width: 70,
            height: 70,
          ),
          Text(
            "Agenda",
            style: TextStyle(color: Colors.white),
          )
        ]),
      ),
    ));
  }
}

class MainPageBottom extends StatefulWidget {
  MainPageBottom({Key key}) : super(key: key);

  @override
  _MainPageBottomState createState() => _MainPageBottomState();
}

class _MainPageBottomState extends State<MainPageBottom> {
  bool active = false;
  bool twoActive = false;
  List<Widget> generateStack(BuildContext context) {
    List<Widget> stackChildren = [];
    if (active) {
      if (twoActive) {
        stackChildren.add(Container(
            height: 70,
            width: MediaQuery.of(context).size.width / 3,
            color: Colors.red));
        stackChildren.add(Container(
            margin:
                EdgeInsets.only(left: MediaQuery.of(context).size.width / 3),
            height: 70,
            width: MediaQuery.of(context).size.width / 3 * 2,
            color: Colors.green));
      } else {
        stackChildren.add(Container(
            height: 70,
            width: MediaQuery.of(context).size.width,
            color: Colors.red));
      }
    } else {
      stackChildren.add(Container(
          height: 30,
          width: MediaQuery.of(context).size.width,
          color: Colors.blue));
    }
    return stackChildren;
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Colors.blue,
        child: Stack(children: generateStack(context)));
  }
}
