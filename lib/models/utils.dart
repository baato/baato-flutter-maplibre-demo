

class Utils {
  //input should be in seconds
  String giveMeTimeFromSecondsFormat(int input) {
    String output = "";
    final int MIN = 60, HRS = 3600, DYS = 84600;
    int days, seconds, minutes, hours, rDays, rHours;
    //calculations
    days = input ~/ DYS;
    rDays = input % DYS;
    hours = rDays ~/ HRS;
    rHours = rDays % HRS;
    minutes = rHours ~/ MIN;
    seconds = rHours % MIN;

    //output
    if (input >= DYS) {
      if (hours > 0)
        output = (days.toString() + " d " + hours.toString() + " hr");
      else
        output = (days.toString() + " day");
    } else if (input >= HRS && input < DYS) {
      if (minutes > 0)
        output = (hours.toString() + " hr " + minutes.toString() + " min");
      else
        output = (hours.toString() + " hr");
    } else if (input >= MIN && input < HRS) {
      if (seconds > 0)
        output = (minutes.toString() + " min " + seconds.toString() + " sec");
      else
        output = (minutes.toString() + " min");
    } else if (input < MIN) {
      output = (input.toString() + " sec");
    }
    return output;
  }
}
