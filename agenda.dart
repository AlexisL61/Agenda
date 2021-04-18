import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'agenda_data.dart';

class Agenda extends StatefulWidget {
  Agenda({Key key}) : super(key: key);

  @override
  _AgendaState createState() => _AgendaState();
}

class _AgendaState extends State<Agenda> with SingleTickerProviderStateMixin {
  DateTime time;
  int day = 1;
  ConvexAppBar currentTab;
  void calculateCurrentWeek() {
    if (time == null) time = DateTime.now();
    print(time.weekday);
    if (time.weekday > 5) {
      time = time.add(Duration(days: 7 - time.weekday + 1));
    } else {
      day = time.weekday;
      time = time.add(Duration(days: -time.weekday + 1));
    }
  }

  List<Resource> getResourcesFromDay(DateTime date) {
    return AgendaData.edtData
        .where((element) =>
            element.start.day == date.day && element.start.month == date.month)
        .toList();
  }

  String createSentenceFromWeek() {
    print("Semaine du " +
        time.day.toString() +
        "/" +
        time.month.toString() +
        "/" +
        time.year.toString());
    return "Semaine du " +
        time.day.toString() +
        "/" +
        time.month.toString() +
        "/" +
        time.year.toString();
  }

  @override
  Widget build(BuildContext context) {
    calculateCurrentWeek();
    print(day - 1);

    return Container(
      child: DefaultTabController(
          length: 5,
          initialIndex: day - 1,
          child: Scaffold(
              appBar: AppBar(
                title: const Text("Agenda"),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      DateTime newDate = await showDatePicker(
                          context: context,
                          initialDate: time.add(Duration(days: day - 1)),
                          firstDate: DateTime(2020),
                          locale: Locale("fr", "FR"),
                          lastDate: DateTime(2022));
                      if (newDate != null) {
                        setState(() {
                          time = newDate;
                        });
                      }
                    },
                  )
                ],
              ),
              body: TabBarView(children: [
                AgendaDay(
                    thisDayResources: getResourcesFromDay(time), day: time),
                AgendaDay(
                    thisDayResources:
                        getResourcesFromDay(time.add(Duration(days: 1))),
                    day: time.add(Duration(days: 1))),
                AgendaDay(
                    thisDayResources:
                        getResourcesFromDay(time.add(Duration(days: 2))),
                    day: time.add(Duration(days: 2))),
                AgendaDay(
                    thisDayResources:
                        getResourcesFromDay(time.add(Duration(days: 3))),
                    day: time.add(Duration(days: 3))),
                AgendaDay(
                    thisDayResources:
                        getResourcesFromDay(time.add(Duration(days: 4))),
                    day: time.add(Duration(days: 4)))
              ]),
              bottomNavigationBar: currentTab = ConvexAppBar(
                style: TabStyle.titled,
                items: [
                  TabItem(icon: Icons.today, title: 'Lundi'),
                  TabItem(icon: Icons.today, title: 'Mardi'),
                  TabItem(icon: Icons.today, title: 'Mercredi'),
                  TabItem(icon: Icons.today, title: 'Jeudi'),
                  TabItem(icon: Icons.today, title: 'Vendredi'),
                ],
                onTap: (int i) => (day = i + 1),
              ))),
    );
  }
}

class Grid extends StatelessWidget {
  const Grid({Key key}) : super(key: key);

  static final int totalHours = 12;
  static final int startingHour = 8;

  List<Widget> creatingBackGrid() {
    List<Widget> grid = [];
    for (int i = startingHour; i < totalHours + startingHour; i++) {
      grid.add(Container(
        child: Row(
          children: [
            Container(
                margin: EdgeInsets.only(right: 5),
                width: 30,
                child: Text(i.toString() + "h")),
            Expanded(
                child: Divider(
              color: Colors.grey,
            ))
          ],
        ),
        margin: EdgeInsets.only(top: 30, bottom: 30, left: 5),
      ));
    }
    return grid;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: creatingBackGrid(),
    );
  }
}

class AgendaDay extends StatefulWidget {
  final List<Resource> thisDayResources;
  final DateTime day;
  AgendaDay({Key key, this.thisDayResources, this.day}) : super(key: key);

  @override
  _AgendaDayState createState() => _AgendaDayState();
}

class _AgendaDayState extends State<AgendaDay> {
  List<Widget> buildCours() {
    List<Widget> cours = [];
    for (int i = 0; i < widget.thisDayResources.length; i++) {
      cours.add(Cours(widget.thisDayResources[i]));
    }
    if (cours.length == 0) {
      cours.add(Container());
    }
    return cours;
  }

  String createSentenceFromWeek() {
    List<String> numToDay = [
      " ",
      "Lundi",
      "Mardi",
      "Mercredi",
      "Jeudi",
      "Vendredi"
    ];
    return numToDay[widget.day.weekday] +
        " " +
        widget.day.day.toString() +
        "/" +
        widget.day.month.toString() +
        "/" +
        widget.day.year.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          color: Colors.blue,
          child: Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                createSentenceFromWeek(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ))),
      Container(
          margin: EdgeInsets.only(top: 50),
          child: ListView(
            children: [
              Stack(children: [
                Grid(),
                Container(
                    margin: EdgeInsets.only(left: 50),
                    child: Stack(children: buildCours()))
              ])
            ],
          ))
    ]);
  }
}

class Cours extends StatelessWidget {
  final Resource thisResource;
  const Cours(Resource r) : this.thisResource = r;

  String getTime(bool start) {
    String finalString = "";
    DateTime time = start ? thisResource.start : thisResource.end;
    if (time.hour.toString().length == 1) {
      finalString = "0" + time.hour.toString();
    } else {
      finalString = time.hour.toString();
    }
    finalString += ":";
    if (time.minute.toString().length == 1) {
      finalString += "0" + time.minute.toString();
    } else {
      finalString += time.minute.toString();
    }
    return finalString;
  }

  Color getColorFromCours() {
    if (thisResource.title.contains(" TD ")) {
      return Colors.green.shade400;
    }
    if (thisResource.title.contains(" TP ")) {
      return Colors.blue.shade400;
    }
    if (thisResource.title.contains(" CM ")) {
      return Colors.yellow.shade400;
    }
    return Colors.red.shade200;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: getColorFromCours()),
        width: MediaQuery.of(context).size.width - 55,
        height: thisResource.difference * 76 / 60,
        margin: EdgeInsets.only(
            top: (38 +
                    (thisResource.start.hour * 60 +
                            thisResource.start.minute -
                            8 * 60) *
                        76 /
                        60)
                .toDouble()),
        child: Row(
          children: [
            Container(
              child: Column(children: [
                Container(
                  child: Text(thisResource.title,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis),
                  alignment: Alignment.topLeft,
                ),
                Container(
                  child: Text(thisResource.enseignant,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis),
                  alignment: Alignment.topLeft,
                ),
                Container(
                  child: Text(thisResource.location,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis),
                  alignment: Alignment.topLeft,
                )
              ]),
              alignment: Alignment.topLeft,
              width: (MediaQuery.of(context).size.width - 55) * 0.75,
            ),
            Container(
                child: Column(children: [
                  Text(
                    getTime(true),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(getTime(false),
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis)
                ]),
                alignment: Alignment.topRight,
                width: (MediaQuery.of(context).size.width - 55) * 0.15)
          ],
        ));
  }
}
