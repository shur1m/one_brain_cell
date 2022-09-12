enum FlashcardStatus {
  learned,
  memorized,
  started,
  none,
}

class Flashcard {
  late String front;
  late String back;
  late FlashcardStatus status;

  Flashcard(this.front, this.back, this.status);

  @override
  String toString() => front;
}
