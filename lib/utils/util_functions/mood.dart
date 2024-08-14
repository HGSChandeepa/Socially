enum Mood {
  happy,
  sad,
  angry,
  excited,
  bored,
}

// This extension will add two methods to the Mood enum to get the name and emoji of the mood and a method to convert a string to a Mood enum value
extension MoodExtension on Mood {
  // Get the name of the mood
  String get name {
    switch (this) {
      case Mood.happy:
        return 'happy';
      case Mood.sad:
        return 'sad';
      case Mood.angry:
        return 'angry';
      case Mood.excited:
        return 'excited';
      case Mood.bored:
        return 'bored';
      default:
        return '';
    }
  }

  // Get the emoji of the mood
  String get emoji {
    switch (this) {
      case Mood.happy:
        return '😊'; // Happy emoji
      case Mood.sad:
        return '😢'; // Sad emoji
      case Mood.angry:
        return '😡'; // Angry emoji
      case Mood.excited:
        return '🤩'; // Excited emoji
      case Mood.bored:
        return '😴'; // Bored emoji
      default:
        return '';
    }
  }

  // Convert a string to a Mood enum value , here we will use the firstWhere method to get the first value that match the string

  static Mood fromString(String moodString) {
    return Mood.values.firstWhere(
      (mood) => mood.name == moodString,
      orElse: () => Mood.happy, // default value if none match
    );
  }
}
