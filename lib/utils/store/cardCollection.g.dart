// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cardCollection.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CardCollectionAdapter extends TypeAdapter<CardCollection> {
  @override
  final int typeId = 2;

  @override
  CardCollection read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CardCollection(
      fields[0] as String,
      fields[1] as bool,
      (fields[2] as HiveList).castHiveList(),
    );
  }

  @override
  void write(BinaryWriter writer, CardCollection obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.collectionName)
      ..writeByte(1)
      ..write(obj.isList)
      ..writeByte(2)
      ..write(obj.contents);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardCollectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
