import 'package:collection/collection.dart';

class PlModel {
  int? starSaleAmount;
  int? starSoldItemValue;
  int? starPurchaseDiscount;
  int? starOtherIncome;
  int? starExtraCharge;
  int? starTotalIncome;
  int? starSalesDiscount;
  int? starSalesTax;
  int? starPurchaseTax;
  int? starDamagedLostAmount;
  int? starOtherExpense;
  int? starTotalExpense;
  int? starProfitLoss;
  String? starFilter;
  String? starCurrency;
  int? starPurchaseExtraCharge;

  PlModel({
    this.starSaleAmount,
    this.starSoldItemValue,
    this.starPurchaseDiscount,
    this.starOtherIncome,
    this.starExtraCharge,
    this.starTotalIncome,
    this.starSalesDiscount,
    this.starSalesTax,
    this.starPurchaseTax,
    this.starDamagedLostAmount,
    this.starOtherExpense,
    this.starTotalExpense,
    this.starProfitLoss,
    this.starFilter,
    this.starCurrency,
    this.starPurchaseExtraCharge,
  });

  @override
  String toString() {
    return 'PlModel(starSaleAmount: $starSaleAmount, starSoldItemValue: $starSoldItemValue, starPurchaseDiscount: $starPurchaseDiscount, starOtherIncome: $starOtherIncome, starExtraCharge: $starExtraCharge, starTotalIncome: $starTotalIncome, starSalesDiscount: $starSalesDiscount, starSalesTax: $starSalesTax, starPurchaseTax: $starPurchaseTax, starDamagedLostAmount: $starDamagedLostAmount, starOtherExpense: $starOtherExpense, starTotalExpense: $starTotalExpense, starProfitLoss: $starProfitLoss, starFilter: $starFilter, starCurrency: $starCurrency, starPurchaseExtraCharge: $starPurchaseExtraCharge)';
  }

  factory PlModel.fromJson(Map<String, dynamic> json) => PlModel(
        starSaleAmount: json['starSaleAmount'] as int?,
        starSoldItemValue: json['starSoldItemValue'] as int?,
        starPurchaseDiscount: json['starPurchaseDiscount'] as int?,
        starOtherIncome: json['starOtherIncome'] as int?,
        starExtraCharge: json['starExtraCharge'] as int?,
        starTotalIncome: json['starTotalIncome'] as int?,
        starSalesDiscount: json['starSalesDiscount'] as int?,
        starSalesTax: json['starSalesTax'] as int?,
        starPurchaseTax: json['starPurchaseTax'] as int?,
        starDamagedLostAmount: json['starDamagedLostAmount'] as int?,
        starOtherExpense: json['starOtherExpense'] as int?,
        starTotalExpense: json['starTotalExpense'] as int?,
        starProfitLoss: json['starProfitLoss'] as int?,
        starFilter: json['starFilter'] as String?,
        starCurrency: json['starCurrency'] as String?,
        starPurchaseExtraCharge: json['starPurchaseExtraCharge'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'starSaleAmount': starSaleAmount,
        'starSoldItemValue': starSoldItemValue,
        'starPurchaseDiscount': starPurchaseDiscount,
        'starOtherIncome': starOtherIncome,
        'starExtraCharge': starExtraCharge,
        'starTotalIncome': starTotalIncome,
        'starSalesDiscount': starSalesDiscount,
        'starSalesTax': starSalesTax,
        'starPurchaseTax': starPurchaseTax,
        'starDamagedLostAmount': starDamagedLostAmount,
        'starOtherExpense': starOtherExpense,
        'starTotalExpense': starTotalExpense,
        'starProfitLoss': starProfitLoss,
        'starFilter': starFilter,
        'starCurrency': starCurrency,
        'starPurchaseExtraCharge': starPurchaseExtraCharge,
      };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! PlModel) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      starSaleAmount.hashCode ^
      starSoldItemValue.hashCode ^
      starPurchaseDiscount.hashCode ^
      starOtherIncome.hashCode ^
      starExtraCharge.hashCode ^
      starTotalIncome.hashCode ^
      starSalesDiscount.hashCode ^
      starSalesTax.hashCode ^
      starPurchaseTax.hashCode ^
      starDamagedLostAmount.hashCode ^
      starOtherExpense.hashCode ^
      starTotalExpense.hashCode ^
      starProfitLoss.hashCode ^
      starFilter.hashCode ^
      starCurrency.hashCode ^
      starPurchaseExtraCharge.hashCode;
}
