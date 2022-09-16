class Flashcard {
  late String front;
  late String back;
  late String collection;
  late int status;

  Flashcard(this.front, this.back, this.status, this.collection);

  @override
  String toString() => 'front: $front \nback: $back \nstatus: $status';
}
