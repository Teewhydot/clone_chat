String convertTime(String timeString, {DateTime? now}) {
  // Parse the input string into a DateTime object
  DateTime time = DateTime.parse(timeString);

  // If now is not provided, use the current time
  now ??= DateTime.now();

  // Calculate the difference between the input time and the current time
  Duration difference = now.difference(time);

  // If the difference is negative, swap the variables
  if (difference.isNegative) {
    difference = time.difference(now);
    time = now;
    now = DateTime.now();
  }

  // Determine the time suffix based on the hours
  String suffix = time.hour >= 12 ? 'PM' : 'AM';

  // Convert the hours to 12-hour format
  int hours = time.hour % 12;
  hours = hours == 0 ? 12 : hours;

  // Format the time string based on the difference between the input time and the current time
  if (difference.inDays == 0) {
    // Today
    return '$hours:${time.minute.toString().padLeft(2, '0')} $suffix';
  } else if (difference.inDays == 1) {
    // Yesterday
    return 'yesterday';
  } else {
    // X days ago
    return '${difference.inDays} days ago';
  }
}
