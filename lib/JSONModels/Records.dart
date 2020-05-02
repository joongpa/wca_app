// To parse this JSON data, do
//
//     final records = recordsFromJson(jsonString);

import 'dart:convert';

Records recordsFromJson(String str) => Records.fromJson(json.decode(str));

String recordsToJson(Records data) => json.encode(data.toJson());

class Records {
  WorldRecords worldRecords;
  ContinentalRecords continentalRecords;

  Records({
    this.worldRecords,
    this.continentalRecords,
  });

  factory Records.fromJson(Map<String, dynamic> json) => Records(
    worldRecords: WorldRecords.fromJson(json["world_records"]),
    continentalRecords: ContinentalRecords.fromJson(json["continental_records"]),
  );

  Map<String, dynamic> toJson() => {
    "world_records": worldRecords.toJson(),
    "continental_records": continentalRecords.toJson(),
  };
}

class ContinentalRecords {
  WorldRecords africa;
  WorldRecords europe;
  WorldRecords asia;
  WorldRecords northAmerica;
  WorldRecords oceania;
  WorldRecords southAmerica;

  ContinentalRecords({
    this.africa,
    this.europe,
    this.asia,
    this.northAmerica,
    this.oceania,
    this.southAmerica,
  });

  factory ContinentalRecords.fromJson(Map<String, dynamic> json) => ContinentalRecords(
    africa: WorldRecords.fromJson(json["_Africa"]),
    europe: WorldRecords.fromJson(json["_Europe"]),
    asia: WorldRecords.fromJson(json["_Asia"]),
    northAmerica: WorldRecords.fromJson(json["_North America"]),
    oceania: WorldRecords.fromJson(json["_Oceania"]),
    southAmerica: WorldRecords.fromJson(json["_South America"]),
  );

  Map<String, dynamic> toJson() => {
    "_Africa": africa.toJson(),
    "_Europe": europe.toJson(),
    "_Asia": asia.toJson(),
    "_North America": northAmerica.toJson(),
    "_Oceania": oceania.toJson(),
    "_South America": southAmerica.toJson(),
  };
}

class The222 {
  int single;
  int average;

  The222({
    this.single,
    this.average,
  });

  factory The222.fromJson(Map<String, dynamic> json) => The222(
    single: json["single"],
    average: json["average"],
  );

  Map<String, dynamic> toJson() => {
    "single": single,
    "average": average,
  };
}

class The333Mbf {
  int single;

  The333Mbf({
    this.single,
  });

  factory The333Mbf.fromJson(Map<String, dynamic> json) => The333Mbf(
    single: json["single"],
  );

  Map<String, dynamic> toJson() => {
    "single": single,
  };
}

class WorldRecords {
  The222 the222;
  The222 the333;
  The222 the444;
  The222 the555;
  The222 the666;
  The222 the777;
  The222 the333Oh;
  The222 the333Bf;
  The222 minx;
  The222 clock;
  The222 the333Fm;
  The222 sq1;
  The222 pyram;
  The222 the444Bf;
  The222 the555Bf;
  The333Mbf the333Mbf;
  The222 skewb;

  WorldRecords({
    this.the222,
    this.the333,
    this.the444,
    this.the555,
    this.the666,
    this.the777,
    this.the333Oh,
    this.the333Bf,
    this.minx,
    this.clock,
    this.the333Fm,
    this.sq1,
    this.pyram,
    this.the444Bf,
    this.the555Bf,
    this.the333Mbf,
    this.skewb,
  });

  factory WorldRecords.fromJson(Map<String, dynamic> json) => WorldRecords(
    the222: The222.fromJson(json["222"]),
    the333: The222.fromJson(json["333"]),
    the444: The222.fromJson(json["444"]),
    the555: The222.fromJson(json["555"]),
    the666: The222.fromJson(json["666"]),
    the777: The222.fromJson(json["777"]),
    the333Oh: The222.fromJson(json["333oh"]),
    the333Bf: The222.fromJson(json["333bf"]),
    minx: The222.fromJson(json["minx"]),
    clock: The222.fromJson(json["clock"]),
    the333Fm: The222.fromJson(json["333fm"]),
    sq1: The222.fromJson(json["sq1"]),
    pyram: The222.fromJson(json["pyram"]),
    the444Bf: The222.fromJson(json["444bf"]),
    the555Bf: The222.fromJson(json["555bf"]),
    the333Mbf: The333Mbf.fromJson(json["333mbf"]),
    skewb: The222.fromJson(json["skewb"]),
  );

  Map<String, dynamic> toJson() => {
    "222": the222.toJson(),
    "333": the333.toJson(),
    "444": the444.toJson(),
    "555": the555.toJson(),
    "666": the666.toJson(),
    "777": the777.toJson(),
    "333oh": the333Oh.toJson(),
    "333bf": the333Bf.toJson(),
    "minx": minx.toJson(),
    "clock": clock.toJson(),
    "333fm": the333Fm.toJson(),
    "sq1": sq1.toJson(),
    "pyram": pyram.toJson(),
    "444bf": the444Bf.toJson(),
    "555bf": the555Bf.toJson(),
    "333mbf": the333Mbf.toJson(),
    "skewb": skewb.toJson(),
  };
}

String getReadableTime(int time) {
  if(time == null) return '-';

  int decimals = time % 100;
  int seconds = time ~/ 100;
  int minutes = seconds~/60;
  seconds -= (60 * minutes);

  String dd = decimals.toString().padLeft(2, '0');
  String ss = seconds.toString();
  String ss2 = seconds.toString().padLeft(2, '0');
  String mm = minutes.toString();

  return (minutes > 0) ? '$mm:$ss2.$dd' : '$ss.$dd';
}

String getMultiResult(int time) {
  int dnfs = time % 100;
  int seconds = (time % 1000000) ~/ 100;
  int minutes = seconds ~/ 60;
  int hours = minutes ~/ 60;
  seconds -= ((hours * 3600) + (minutes * 60));
  int cubesAttempted = 2 * dnfs + (99 - (time ~/ 10000000));

  String score = '${cubesAttempted - dnfs}/$cubesAttempted';

  String ss = seconds.toString();
  String ss2 = seconds.toString().padLeft(2, '0');
  String mm = minutes.toString();
  String mm2 = minutes.toString().padLeft(2, '0');
  String hh = hours.toString();

  if(hours > 0) return score + ' $hh:$mm2:$ss2';
  else if(minutes > 0) return score + ' $mm:$ss2';
  else return score + ' $ss';
}

