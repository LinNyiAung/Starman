class StarItem {
  final String starInvovice;
  final double starAmount;
  final double starPaidAmount;
  final String starUserName;
  final String starCustomerName;
  final String? starSupplierName;

  StarItem({
    required this.starInvovice,
    required this.starAmount,
    required this.starPaidAmount,
    required this.starUserName,
    required this.starCustomerName,
    this.starSupplierName,
  });

  factory StarItem.fromJson(Map<String, dynamic> json) {
    return StarItem(
      starInvovice: json['starInvovice'],
      starAmount: json['starAmount'].toDouble(),
      starPaidAmount: json['starPaidAmount'].toDouble(),
      starUserName: json['starUserName'],
      starCustomerName: json['starCustomerName'],
      starSupplierName: json['starSupplierName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'starInvovice': starInvovice,
      'starAmount': starAmount,
      'starPaidAmount': starPaidAmount,
      'starUserName': starUserName,
      'starCustomerName': starCustomerName,
      'starSupplierName': starSupplierName,
    };
  }
}

class StarTransaction {
  final List<StarItem> starNSItemList;
  final double starTotalAmount;
  final double starTaxAmount;
  final double starDiscountAmount;
  final double starPaidAmount;
  final double starNetAmount;
  final double starBalance;
  final int starTotalInvoice;
  final String starFiler;
  final String starCurrency;
  final bool starUseSingleLine;

  StarTransaction({
    required this.starNSItemList,
    required this.starTotalAmount,
    required this.starTaxAmount,
    required this.starDiscountAmount,
    required this.starPaidAmount,
    required this.starNetAmount,
    required this.starBalance,
    required this.starTotalInvoice,
    required this.starFiler,
    required this.starCurrency,
    required this.starUseSingleLine,
  });

  factory StarTransaction.fromJson(Map<String, dynamic> json) {
    return StarTransaction(
      starNSItemList: (json['starNSItemList'] as List<dynamic>)
          .map((item) => StarItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      starTotalAmount: json['starTotalAmount'].toDouble(),
      starTaxAmount: json['starTaxAmount'].toDouble(),
      starDiscountAmount: json['starDiscountAmount'].toDouble(),
      starPaidAmount: json['starPaidAmount'].toDouble(),
      starNetAmount: json['starNetAmount'].toDouble(),
      starBalance: json['starBalance'].toDouble(),
      starTotalInvoice: json['starTotalInvoice'],
      starFiler: json['starFiler'],
      starCurrency: json['starCurrency'],
      starUseSingleLine: json['starUseSingleLine'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'starNSItemList': starNSItemList.map((item) => item.toJson()).toList(),
      'starTotalAmount': starTotalAmount,
      'starTaxAmount': starTaxAmount,
      'starDiscountAmount': starDiscountAmount,
      'starPaidAmount': starPaidAmount,
      'starNetAmount': starNetAmount,
      'starBalance': starBalance,
      'starTotalInvoice': starTotalInvoice,
      'starFiler': starFiler,
      'starCurrency': starCurrency,
      'starUseSingleLine': starUseSingleLine,
    };
  }
}
