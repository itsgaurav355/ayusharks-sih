class Investor {
  final String? id;
  final String images;
  final String stage;
  final String industry;
  final String investorType;
  final String sector;
  final String role;
  final String intrest;
  final String state;
  final String city;
  final String linkedIn;
  final String investorname;
  final String pancard;
  final double budget;
  final String brief;
  final String mobileno;
  final String type;
  final List<String>? haveStories;

  Investor({
    this.id,
    required this.investorType,
    required this.sector,
    required this.intrest,
    required this.role,
    required this.stage,
    required this.industry,
    required this.state,
    required this.city,
    required this.linkedIn,
    this.haveStories,
    required this.images,
    required this.investorname,
    required this.pancard,
    required this.budget,
    required this.brief,
    required this.mobileno,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'images': images,
      'stage': stage,
      'industry': industry,
      'state': state,
      'city': city,
      'linkedIn': linkedIn,
      'investorname': investorname,
      'pancard': pancard,
      'budget': budget,
      'brief': brief,
      'mobileno': mobileno,
      'type': type,
      'haveStories': haveStories,
      'investorType': investorType,
      'sector': sector,
      'intrest': intrest,
      'role': role,
    };
  }

  factory Investor.fromMap(Map<String, dynamic> map) {
    return Investor(
      id: map['id'] ?? '',
      images: map['images'] ?? '',
      stage: map['stage'] ?? '',
      industry: map['industry'] ?? '',
      state: map['state'] ?? '',
      city: map['city'] ?? '',
      linkedIn: map['linkedIn'] ?? '',
      investorname: map['investorname'] ?? '',
      pancard: map['pancard'] ?? '', // Assuming pancard is an int
      budget: map['budget'] ?? '',
      brief: map['brief'] ?? '',
      mobileno: map['mobileno'] ?? "", // Assuming mobileno is a double
      type: map['type'] ?? '',
      haveStories: map['haveStories'] ?? [],
      investorType: map['investorType'] ?? '',
      sector: map['sector'] ?? '',
      intrest: map['intrest'] ?? '',
      role: map['role'] ?? '',
    );
  }
}
