class CfdModel {
  final List<StarCFByDateDetail> starCFByDateDetailList;
  final double starTotalIncome;
  final double starTotalExpense;
  final double starTotalBalance;
  final String starFilter;
  final String starCurrency;

  CfdModel({
    required this.starCFByDateDetailList,
    required this.starTotalIncome,
    required this.starTotalExpense,
    required this.starTotalBalance,
    required this.starFilter,
    required this.starCurrency,
  });

  factory CfdModel.fromJson(Map<String, dynamic> json) {
    return CfdModel(
      starCFByDateDetailList: (json['starCFByDateDetailList'] as List)
          .map((item) => StarCFByDateDetail.fromJson(item))
          .toList(),
      starTotalIncome: json['starTotalIncome'].toDouble(),
      starTotalExpense: json['starTotalExpense'].toDouble(),
      starTotalBalance: json['starTotalBalance'].toDouble(),
      starFilter: json['starFilter'],
      starCurrency: json['starCurrency'],
    );
  }

  @override
  String toString() {
    return 'CfdModel(starCFByDateDetailList: $starCFByDateDetailList, '
        'starTotalIncome: $starTotalIncome, '
        'starTotalExpense: $starTotalExpense, '
        'starTotalBalance: $starTotalBalance, '
        'starFilter: $starFilter, '
        'starCurrency: $starCurrency)';
  }
}

class StarCFByDateDetail {
  final String starDate;
  final double starIncome;
  final double starExpense;
  final double starBalance;

  StarCFByDateDetail({
    required this.starDate,
    required this.starIncome,
    required this.starExpense,
    required this.starBalance,
  });

  factory StarCFByDateDetail.fromJson(Map<String, dynamic> json) {
    return StarCFByDateDetail(
      starDate: json['starDate'],
      starIncome: json['starIncome'].toDouble(),
      starExpense: json['starExpense'].toDouble(),
      starBalance: json['starBalance'].toDouble(),
    );
  }

  @override
  String toString() {
    return 'StarCFByDateDetail(starDate: $starDate, '
        'starIncome: $starIncome, '
        'starExpense: $starExpense, '
        'starBalance: $starBalance)';
  }
}
