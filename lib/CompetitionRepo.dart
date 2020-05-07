import 'package:flutter/foundation.dart';
import 'package:wcaapp/DbProvider.dart';
import 'package:wcaapp/JSONModels/Competition.dart';
import 'package:http/http.dart' as http;

class CompetitionRepo {
  CompetitionRepo._();
  static final url = 'https://www.worldcubeassociation.org/api/v0/competitions';
  static final itemsPerPage = 25;

  static final CompetitionRepo cr = CompetitionRepo._();

  Future<List<Competition>> get competitions async {
    List<Competition> comps = await DbProvider.db.getComps();
    if(comps.isNotEmpty) {
      return comps;
    } else {
      comps = await fetchCompetitions();
      return comps;
    }
  }

  Future<List<Competition>> fetchCompetitions([int page = 1]) async {
    final response = await http.get(url + '?page=$page');
    if(response.statusCode == 200) {
      final comps = compute(parseComps, response.body);
      addToDb(comps);
      return comps;
    } else {
      throw Exception('Failed to load competitions');
    }
  }

  void addToDb(comps) async {
    var compList = await comps;
    for(Competition comp in compList) {
      DbProvider.db.add(comp);
    }
  }
}