enum Mood {
  happy,
  sad,
  angry,
  excited,
  bored,
}

extension MoodExtension on Mood {
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

  static Mood fromString(String moodString) {
    return Mood.values.firstWhere(
      (mood) => mood.name == moodString,
      orElse: () => Mood.happy, // default value if none match
    );
  }
}
