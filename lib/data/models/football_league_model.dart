class FootballLeagueModel {
  final int id;
  final String name;
  final String logoWhite;
  final int clubTotal;

  FootballLeagueModel({
    required this.id,
    required this.name,
    required this.logoWhite,
    this.clubTotal = 0,
  });

  factory FootballLeagueModel.fromJson(Map<String, dynamic> json) {
    return FootballLeagueModel(
      id: json['id'],
      name: json['name'].toString(),
      logoWhite: json['logo_white'].toString(),
      clubTotal: json['club_total'],
    );
  }
}
