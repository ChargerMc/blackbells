class Rider {
  static String getRouteTime(DateTime start, DateTime? end) {
    final dif = end!.difference(start);
    return '${dif.inHours} horas';
  }
}
