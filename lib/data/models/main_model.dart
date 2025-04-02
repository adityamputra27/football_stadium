class MainPopularStadium {
  final int footballClubId;
  final String clubName;
  final String logoPrimary;
  String? stadiumName;
  String? capacity;
  String? status;
  String? stadiumFilePath;

  MainPopularStadium({
    required this.footballClubId,
    required this.clubName,
    required this.logoPrimary,
    this.stadiumName,
    this.stadiumFilePath,
    this.status,
    this.capacity,
  });

  factory MainPopularStadium.fromJson(Map<String, dynamic> json) {
    return MainPopularStadium(
      footballClubId: json['football_club_id'],
      clubName: json['club_name'],
      logoPrimary: json['logo_primary'],
      stadiumName: json['stadium_name'],
      stadiumFilePath: json['stadium_file_path'],
      capacity: json['capacity'],
      status: json['status'],
    );
  }
}

class MainPopularLeague {
  final int id;
  final String name;
  final String logoWhite;
  final int clubTotal;

  MainPopularLeague({
    required this.id,
    required this.name,
    required this.logoWhite,
    this.clubTotal = 0,
  });

  factory MainPopularLeague.fromJson(Map<String, dynamic> json) {
    return MainPopularLeague(
      id: json['id'],
      name: json['name'],
      logoWhite: json['logo_white'],
      clubTotal: json['club_total'],
    );
  }
}

class MainPopularClub {
  final int footballLeagueId;
  final int footballClubId;
  final String clubName;
  String? stadiumName;
  String? capacity;
  String? status;
  String? logoWhite;

  MainPopularClub({
    required this.footballLeagueId,
    required this.footballClubId,
    required this.clubName,
    this.stadiumName,
    this.capacity,
    this.status,
    this.logoWhite,
  });

  factory MainPopularClub.fromJson(Map<String, dynamic> json) {
    return MainPopularClub(
      footballLeagueId: json['football_league_id'],
      footballClubId: json['football_club_id'],
      clubName: json['club_name'],
      stadiumName: json['stadium_name'],
      capacity: json['capacity'],
      status: json['status'],
      logoWhite: json['logo_white'],
    );
  }
}

class MainModel {
  final List<MainPopularStadium> popularStadiums;
  final List popularLeagues;
  final List popularClubs;

  MainModel({
    required this.popularStadiums,
    required this.popularLeagues,
    required this.popularClubs,
  });

  factory MainModel.fromJson(Map<String, dynamic> json) {
    return MainModel(
      popularStadiums:
          (json['popular_stadiums'] as List)
              .map((stadium) => MainPopularStadium.fromJson(stadium))
              .toList(),
      popularLeagues:
          (json['popular_leagues'] as List)
              .map((league) => MainPopularLeague.fromJson(league))
              .toList(),
      popularClubs:
          (json['popular_clubs'] as List)
              .map((club) => MainPopularClub.fromJson(club))
              .toList(),
    );
  }
}
