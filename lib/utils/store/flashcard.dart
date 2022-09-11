enum FlashcardStatus {
  learned,
  memorized,
  started,
  none,
}

class Flashcard {
  late List<String> parentLists;
  late String uuid;
  late String front;
  late String back;
  late FlashcardStatus status;

  Flashcard(this.parentLists, this.uuid, this.front, this.back, this.status);
}
