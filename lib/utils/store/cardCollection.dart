import 'package:hive/hive.dart';

part 'cardCollection.g.dart';

@HiveType(typeId: 2)
class CardCollection extends HiveObject {
  @HiveField(0)
  late String collectionName;

  @HiveField(1)
  late bool isList;

  @HiveField(2)
  late HiveList contents;

  CardCollection(this.collectionName, this.isList, this.contents);
  String toString() => collectionName;
}
