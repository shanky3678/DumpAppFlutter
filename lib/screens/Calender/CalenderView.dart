import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalenderDisplay extends StatelessWidget {
  CalenderDisplay({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calender"),
      ),
      body: SfCalendar(
        view: CalendarView.month,
        todayTextStyle: TextStyle(fontSize: 32),
        blackoutDates: [
          DateTime.now().add(Duration(
            days: 3,
          )),
          DateTime.now().add(Duration(days: 5))
        ],
        blackoutDatesTextStyle: TextStyle(
            color: Colors.white, backgroundColor: Colors.blue, fontSize: 32),
      ),
    );
  }
}
