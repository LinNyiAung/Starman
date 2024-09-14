import 'package:collection/collection.dart';

class CfModel {
  double? starSalesAmount;
  double? starOtherIncome;
  double? starCustomerPayment;
  double? starTotalCashIn;
  double? starPurchaseAmount;
  double? starOtherExpense;
  double? starSupplierPayment;
  double? starDepositOwner;
  double? starTotalCashOut;
  double? starTotal;
  String? starFilter;
  String? starCurrency;

  CfModel({
    this.starSalesAmount,
    this.starOtherIncome,
    this.starCustomerPayment,
    this.starTotalCashIn,
    this.starPurchaseAmount,
    this.starOtherExpense,
    this.starSupplierPayment,
    this.starDepositOwner,
    this.starTotalCashOut,
    this.starTotal,
    this.starFilter,
    this.starCurrency,
  });

  @override
  String toString() {
    return 'CfModel(starSalesAmount: $starSalesAmount, starOtherIncome: $starOtherIncome, starCustomerPayment: $starCustomerPayment, starTotalCashIn: $starTotalCashIn, starPurchaseAmount: $starPurchaseAmount, starOtherExpense: $starOtherExpense, starSupplierPayment: $starSupplierPayment, starDepositOwner: $starDepositOwner, starTotalCashOut: $starTotalCashOut, starTotal: $starTotal, starFilter: $starFilter, starCurrency: $starCurrency)';
  }

  factory CfModel.fromJson(Map<String, dynamic> json) => CfModel(
        starSalesAmount: json['starSalesAmount'] as double?,
        starOtherIncome: json['starOtherIncome'] as double?,
        starCustomerPayment: json['starCustomerPayment'] as double?,
        starTotalCashIn: json['starTotalCashIn'] as double?,
        starPurchaseAmount: json['starPurchaseAmount'] as double?,
        starOtherExpense: json['starOtherExpense'] as double?,
        starSupplierPayment: json['starSupplierPayment'] as double?,
        starDepositOwner: json['starDepositOwner'] as double?,
        starTotalCashOut: json['starTotalCashOut'] as double?,
        starTotal: json['starTotal'] as double?,
        starFilter: json['starFilter'] as String?,
        starCurrency: json['starCurrency'] as String?,
      );
  static List<CfModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => CfModel.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() => {
        'starSalesAmount': starSalesAmount,
        'starOtherIncome': starOtherIncome,
        'starCustomerPayment': starCustomerPayment,
        'starTotalCashIn': starTotalCashIn,
        'starPurchaseAmount': starPurchaseAmount,
        'starOtherExpense': starOtherExpense,
        'starSupplierPayment': starSupplierPayment,
        'starDepositOwner': starDepositOwner,
        'starTotalCashOut': starTotalCashOut,
        'starTotal': starTotal,
        'starFilter': starFilter,
        'starCurrency': starCurrency,
      };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! CfModel) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      starSalesAmount.hashCode ^
      starOtherIncome.hashCode ^
      starCustomerPayment.hashCode ^
      starTotalCashIn.hashCode ^
      starPurchaseAmount.hashCode ^
      starOtherExpense.hashCode ^
      starSupplierPayment.hashCode ^
      starDepositOwner.hashCode ^
      starTotalCashOut.hashCode ^
      starTotal.hashCode ^
      starFilter.hashCode ^
      starCurrency.hashCode;
}
