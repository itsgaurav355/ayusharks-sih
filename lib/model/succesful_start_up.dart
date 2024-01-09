class SuccessfulStartUp {
  final String? id;
  final String startupName;
  final String startUpLogo;
  final int profit;
  final int investment;
  final String startupLink;
  SuccessfulStartUp(
      {this.id,
      required this.startupName,
      required this.startUpLogo,
      required this.profit,
      required this.investment,
      required this.startupLink});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "startupname": startupName,
      "startupLogo": startUpLogo,
      "profit": profit,
      "investment": investment,
      "startupLink": startupLink
    };
  }

  factory SuccessfulStartUp.fromMap(Map<String, dynamic> map) {
    return SuccessfulStartUp(
      id: map['id'] ?? '',
      investment: map['investment'] ?? 0,
      startupName: map['startupname'] ?? '',
      startUpLogo: map['startupLogo'] ?? '',
      profit: map['profit'] ?? 0,
      startupLink: map['startupLink'] ?? '',
    );
  }
}
