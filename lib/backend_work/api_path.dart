class API_Path {
  static String note(String jobID) {
    return '/user/$jobID';
  }

  static String notePath() {
    return '/user';
  }
}
