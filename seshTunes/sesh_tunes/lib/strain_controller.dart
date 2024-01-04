import 'dart:convert';
import 'package:flutter/services.dart';
import 'strain_model.dart';

class StrainController {
  Future<List<Strain>> loadStrains() async {
    try {
      // Load the JSON file from the assets directory
      String jsonString =
          await rootBundle.loadString('assets/leafly_strain_data.json');

      // Parse the JSON data
      List<dynamic> jsonArray = jsonDecode(jsonString);

      // Create a list of Strain objects
      List<Strain> strains = [];
      for (var jsonMap in jsonArray) {
        Strain strain = Strain.fromJson(jsonMap);
        strains.add(strain);
      }

      return strains;
    } catch (e) {
      print('Error loading strains: $e');
      return [];
    }
  }
}
