class DataPoint {
  final String x;
  final double y;

  DataPoint(this.x, this.y);
}

class Financial {
  int amount;
  String from;
  String to;
  double revenue;
  double commission;

  Financial({
    required this.amount,
    required this.from,
    required this.to,
    required this.revenue,
    required this.commission,
  });

  factory Financial.zero() => Financial(amount: 0, from: "", to: "", revenue: 0, commission: 0);

  factory Financial.fromJson(Map<String, dynamic> json) => Financial(
        amount: json["Amount"] ?? 0,
        from: json["From"] ?? "",
        to: json["To"] ?? "",
        revenue: json["Revenue"] ?? 0,
        commission: json["Commission"] ?? 0,
      );
}

class Statistic {
  double queryConv;
  double monthConv;
  Financial queryRange;
  Financial monthRange;
  List<Financial> yearSummary;

  Statistic({
    required this.queryConv,
    required this.monthConv,
    required this.queryRange,
    required this.monthRange,
    required this.yearSummary,
  });

  factory Statistic.zero() => Statistic(
        queryConv: 0,
        monthConv: 0,
        queryRange: Financial.zero(),
        monthRange: Financial.zero(),
        yearSummary: List<Financial>.generate(12, (index) => Financial.zero()),
      );

  factory Statistic.fromJson(Map<String, dynamic> json) => Statistic(
        queryConv: json["QueryConv"] ?? 0,
        monthConv: json["MonthConv"] ?? 0,
        queryRange: Financial.fromJson(json["QueryRange"]),
        monthRange: Financial.fromJson(json["MonthRange"]),
        yearSummary: List<Financial>.from(json["YearSummary"].map((x) => Financial.fromJson(x))),
      );
}
