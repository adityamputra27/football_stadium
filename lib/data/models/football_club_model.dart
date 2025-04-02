class FootballClubModel {
  final int footballStadiumId;
  final int footballLeagueId;
  final int footballClubId;
  final String clubName;
  String? stadiumName;
  String? capacity;
  String? status;
  final String logoWhite;

  FootballClubModel({
    required this.footballStadiumId,
    required this.footballLeagueId,
    required this.footballClubId,
    required this.clubName,
    this.stadiumName = '',
    this.capacity = '',
    this.status = 'ACTIVE',
    required this.logoWhite,
  });

  factory FootballClubModel.fromJson(Map<String, dynamic> json) {
    return FootballClubModel(
      footballLeagueId: json['football_league_id'],
      footballClubId: json['football_club_id'],
      footballStadiumId: json['football_stadium_id'],
      clubName: json['club_name'],
      stadiumName: json['stadium_name'],
      capacity: json['capacity'],
      status: json['status'],
      logoWhite: json['logo_white'],
    );
  }
}
