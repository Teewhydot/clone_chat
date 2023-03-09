String convertTime(String time) {
  // Parse the hours and minutes from the input string
  int hours = int.parse(time.split(':')[0]);
  int minutes = int.parse(time.split(':')[1]);

  // Determine whether it's AM or PM based on the hours
  String suffix = hours >= 12 ? 'PM' : 'AM';

  // Convert the hours to 12-hour format
  if (hours > 12) {
    hours -= 12;
  } else if (hours == 0) {
    hours = 12;
  }

  // Format the time string in 12-hour format
  return '$hours:${minutes.toString().padLeft(2, '0')} $suffix';
}
