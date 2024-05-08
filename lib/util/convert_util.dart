List<int> intToListInt(int number) {
  // Convert the integer to a string
  String numberString = number.toString();

  // Map each character of the string to an integer and convert it into a list
  List<int> result = numberString.runes.map((rune) => int.parse(String.fromCharCode(rune))).toList();

  return result;
}
