import 'package:collection/collection.dart';

import 'license_info.dart';

class LastSubscriptionModel {
  int? id;
  LicenseInfo? licenseInfo;
  int? amount;
  bool? deleted;

  LastSubscriptionModel({
    this.id,
    this.licenseInfo,
    this.amount,
    this.deleted,
  });

  @override
  String toString() {
    return 'LastSubscriptionModel(id: $id, licenseInfo: $licenseInfo, amount: $amount, deleted: $deleted)';
  }

  factory LastSubscriptionModel.fromJson(Map<String, dynamic> json) {
    return LastSubscriptionModel(
      id: json['id'] as int?,
      licenseInfo: json['licenseInfo'] == null
          ? null
          : LicenseInfo.fromJson(json['licenseInfo'] as Map<String, dynamic>),
      amount: json['amount'] as int?,
      deleted: json['deleted'] as bool?,
    );
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
    if (other is! LastSubscriptionModel) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^ licenseInfo.hashCode ^ amount.hashCode ^ deleted.hashCode;
}
