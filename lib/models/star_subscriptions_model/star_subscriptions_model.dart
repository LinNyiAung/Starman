import 'package:collection/collection.dart';

import 'license_info.dart';

class StarSubscriptionsModel {
  int? id;
  LicenseInfo? licenseInfo;
  int? amount;
  bool? deleted;

  StarSubscriptionsModel({
    this.id,
    this.licenseInfo,
    this.amount,
    this.deleted,
  });

  @override
  String toString() {
    return 'StarSubscriptionsModel(id: $id, licenseInfo: $licenseInfo, amount: $amount, deleted: $deleted)';
  }

  factory StarSubscriptionsModel.fromJson(Map<String, dynamic> json) {
    return StarSubscriptionsModel(
      id: json['id'] as int?,
      licenseInfo: json['licenseInfo'] == null
          ? null
          : LicenseInfo.fromJson(json['licenseInfo'] as Map<String, dynamic>),
      amount: json['amount'] as int?,
      deleted: json['deleted'] as bool?,
    );
  }
  static List<StarSubscriptionsModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => StarSubscriptionsModel.fromJson(json))
        .toList();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'licenseInfo': licenseInfo?.toJson(),
        'amount': amount,
        'deleted': deleted,
      };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! StarSubscriptionsModel) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^ licenseInfo.hashCode ^ amount.hashCode ^ deleted.hashCode;
}
