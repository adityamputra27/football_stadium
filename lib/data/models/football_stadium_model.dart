class FootballStadiumModel {
  final int id;
  final int footballClubId;
  final String name;
  final String capacity;
  final String country;
  final String city;
  final String cost;
  final String status;
  final String description;
  final FootballStadiumClubModel footballClub;
  final List<FootballStadiumFileModel> footballStadiumFiles;

  FootballStadiumModel({
    required this.id,
    required this.footballClubId,
    required this.name,
    required this.capacity,
    required this.country,
    required this.city,
    required this.cost,
    required this.status,
    required this.description,
    required this.footballClub,
    required this.footballStadiumFiles,
  });

  factory FootballStadiumModel.fromJson(Map<String, dynamic> json) {
    return FootballStadiumModel(
      id: json['id'],
      footballClubId: json['football_club_id'],
      footballClub: FootballStadiumClubModel.fromJson(json['football_club']),
      name: json['name'],
      capacity: json['capacity'],
      country: json['country'],
      city: json['city'],
      cost: json['cost'],
      status: json['status'],
      description: json['description'],
      footballStadiumFiles:
          (json['football_stadium_files'] as List)
              .map((file) => FootballStadiumFileModel.fromJson(file))
              .toList(),
    );
  }
}

class FootballStadiumFileModel {
  final int id;
  final int footballStadiumId;
  final String filePath;

  FootballStadiumFileModel({
    required this.id,
    required this.footballStadiumId,
    required this.filePath,
  });

  factory FootballStadiumFileModel.fromJson(Map<String, dynamic> json) {
    return FootballStadiumFileModel(
      id: json['id'],
      footballStadiumId: json['football_stadium_id'],
      filePath: json['file_path'],
    );
  }
}

class FootballStadiumClubModel {
  final int id;
  final String name;
  final String logoWhite;

  FootballStadiumClubModel({
    required this.id,
    required this.name,
    required this.logoWhite,
  });

  factory FootballStadiumClubModel.fromJson(Map<String, dynamic> json) {
    return FootballStadiumClubModel(
      id: json['id'],
      name: json['name'],
      logoWhite: json['logo_white'],
    );
  }
}
