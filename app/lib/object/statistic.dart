class DataPoint {
  final String x;
  final double y;

  DataPoint(this.x, this.y);
}

class Financial {
  String from;
  String to;
  double revenue;
  double commission;

  Financial({
    required this.from,
    required this.to,
    required this.revenue,
    required this.commission,
  });

  factory Financial.zero() => Financial(from: "", to: "", revenue: 0, commission: 0);

  factory Financial.fromJson(Map<String, dynamic> json) => Financial(
        from: json["From"] ?? "",
        to: json["To"] ?? "",
        revenue: json["Revenue"] ?? 0,
        commission: json["Commission"] ?? 0,
      );
}

class Statistic {
  Financial queryRange;
  Financial monthRange;
  List<Financial> yearSummary;

  Statistic({
    required this.queryRange,
    required this.monthRange,
    required this.yearSummary,
  });

  factory Statistic.zero() => Statistic(
        queryRange: Financial.zero(),
        monthRange: Financial.zero(),
        yearSummary: List<Financial>.generate(12, (index) => Financial.zero()),
      );

  factory Statistic.fromJson(Map<String, dynamic> json) => Statistic(
        queryRange: Financial.fromJson(json["QueryRange"]),
        monthRange: Financial.fromJson(json["MonthRange"]),
        yearSummary: List<Financial>.from(json["YearSummary"].map((x) => Financial.fromJson(x))),
      );
}
