class Flashcard {
  late int rowid;
  late String front;
  late String back;
  late String collection;
  late int collectionKey;
  late int status;

  Flashcard(this.rowid, this.front, this.back, this.status, this.collection,
      this.collectionKey);

  @override
  String toString() =>
      'front: $front \nback: $back \nstatus: $status \ncollectionKey: $collectionKey';
}
