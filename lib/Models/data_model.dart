// 2 Classes DataModel and GameData

/*
class name: DataModel
Variables: totalRecords,data,cursor

 */
class DataModel {
  int totalRecords;
  List<GameData> data;
  String cursor;

  //constructor
  DataModel({
     required this.totalRecords,
     required this.data,
    required this.cursor,
  });

  //Converts api Map<String, dynamic>  to DataModel
  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
        totalRecords: json['data']['tournaments'].length,
        data: ((json['data']['tournaments']as List).map((i) => GameData.fromJson(i))).toList(),
        cursor: json['data']['cursor']
    );
  }
}

/*
class name: GameData
Variables: gameName,name,coverUrl

 */
class GameData {
  final String gameName;
  final String name;
  final String coverUrl;

  GameData({
     required this.gameName,
     required this.name,
     required this.coverUrl,
  });

  //Converts api Map<String, dynamic>  to GameData
  factory GameData.fromJson(Map<dynamic, dynamic> json) {
    return GameData(
      gameName: json['game_name'],
      name: json['name'],
      coverUrl: json['cover_url'],
    );
  }
}