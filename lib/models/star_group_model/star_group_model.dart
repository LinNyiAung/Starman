import 'package:collection/collection.dart';

class StarGroupModel {
  int? id;
  String? busniessName;
  String? busniessPhone;
  String? busniessAddress;
  String? starId;

  StarGroupModel({
    this.id,
    this.busniessName,
    this.busniessPhone,
    this.busniessAddress,
    this.starId,
  });

  @override
  String toString() {
    return 'StarGroupModel(id: $id, busniessName: $busniessName, busniessPhone: $busniessPhone, busniessAddress: $busniessAddress, starId: $starId)';
  }

  factory StarGroupModel.fromJson(Map<String, dynamic> json) {
    return StarGroupModel(
      id: json['id'] as int?,
      busniessName: json['busniessName'] as String?,
      busniessPhone: json['busniessPhone'] as String?,
      busniessAddress: json['busniessAddress'] as String?,
      starId: json['starId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'busniessName': busniessName,
        'busniessPhone': busniessPhone,
        'busniessAddress': busniessAddress,
        'starId': starId,
      };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! StarGroupModel) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      busniessName.hashCode ^
      busniessPhone.hashCode ^
      busniessAddress.hashCode ^
      starId.hashCode;
}
