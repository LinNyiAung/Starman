import 'package:collection/collection.dart';

class LicenseInfo {
  String? licenceType;
  String? startDate;
  String? endDate;
  String? duration;
  String? licenseKey;
  String? licenseStatus;

  LicenseInfo({
    this.licenceType,
    this.startDate,
    this.endDate,
    this.duration,
    this.licenseKey,
    this.licenseStatus,
  });

  @override
  String toString() {
    return 'LicenseInfo(licenceType: $licenceType, startDate: $startDate, endDate: $endDate, duration: $duration, licenseKey: $licenseKey, licenseStatus: $licenseStatus)';
  }

  factory LicenseInfo.fromJson(Map<String, dynamic> json) => LicenseInfo(
        licenceType: json['licenceType'] as String?,
        startDate: json['startDate'] as String?,
        endDate: json['endDate'] as String?,
        duration: json['duration'] as String?,
        licenseKey: json['licenseKey'] as String?,
        licenseStatus: json['licenseStatus'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'licenceType': licenceType,
        'startDate': startDate,
        'endDate': endDate,
        'duration': duration,
        'licenseKey': licenseKey,
        'licenseStatus': licenseStatus,
      };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! LicenseInfo) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      licenceType.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      duration.hashCode ^
      licenseKey.hashCode ^
      licenseStatus.hashCode;
}
