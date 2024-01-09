class StartUp {
  final String? id;
  final String images;
  final String companyName;
  final String stage;
  final String msmeNumber;
  final String industry;
  final String sector;
  final String servicesType;
  final int investement;
  final double profitmargin;
  final double equity;
  final String cin;
  final double revenue;
  final String description;

  StartUp({
    required this.stage,
    required this.msmeNumber,
    required this.industry,
    required this.sector,
    required this.servicesType,
    required this.id,
    required this.images,
    required this.companyName,
    required this.investement,
    required this.profitmargin,
    required this.equity,
    required this.cin,
    required this.revenue,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': images,
      'companyname': companyName,
      'stage': stage,
      'msmeNumber': msmeNumber,
      'industry': industry,
      'sector': sector,
      'servicesType': servicesType,
      'investement': investement,
      'profitmargin': profitmargin,
      'equity': equity,
      'cin': cin,
      'revenue': revenue,
      'description': description,
    };
  }

  factory StartUp.fromMap(Map<String, dynamic> map) {
    return StartUp(
      id: map['id'],
      images: map['image'],
      companyName: map['companyname'],
      stage: map['stage'],
      msmeNumber: map['msmeNumber'],
      industry: map['industry'],
      sector: map['sector'],
      servicesType: map['servicesType'],
      investement: map['investement'],
      profitmargin: map['profitmargin'],
      equity: map['equity'],
      cin: map['cin'],
      revenue: map['revenue'],
      description: map['description'],
    );
  }
}
