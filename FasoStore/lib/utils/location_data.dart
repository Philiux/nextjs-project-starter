class RegionData {
  final String name;
  final List<String> provinces;
  final List<String> mainCities;

  const RegionData({
    required this.name,
    required this.provinces,
    required this.mainCities,
  });
}

class CountryData {
  static const Map<String, List<RegionData>> countries = {
    'Burkina Faso': burkinaFaso,
    'Mali': mali,
    'Niger': niger,
  };

  // Burkina Faso - 13 régions
  static const List<RegionData> burkinaFaso = [
    RegionData(
      name: 'Boucle du Mouhoun',
      provinces: ['Balé', 'Banwa', 'Kossi', 'Mouhoun', 'Nayala', 'Sourou'],
      mainCities: ['Dédougou', 'Boromo', 'Solenzo', 'Nouna', 'Toma', 'Tougan'],
    ),
    RegionData(
      name: 'Cascades',
      provinces: ['Comoé', 'Léraba'],
      mainCities: ['Banfora', 'Sindou'],
    ),
    RegionData(
      name: 'Centre',
      provinces: ['Kadiogo'],
      mainCities: ['Ouagadougou'],
    ),
    RegionData(
      name: 'Centre-Est',
      provinces: ['Boulgou', 'Koulpélogo', 'Kouritenga'],
      mainCities: ['Tenkodogo', 'Koupéla', 'Pouytenga'],
    ),
    RegionData(
      name: 'Centre-Nord',
      provinces: ['Bam', 'Namentenga', 'Sanmatenga'],
      mainCities: ['Kaya', 'Kongoussi', 'Boulsa'],
    ),
    RegionData(
      name: 'Centre-Ouest',
      provinces: ['Boulkiemdé', 'Sanguié', 'Sissili', 'Ziro'],
      mainCities: ['Koudougou', 'Réo', 'Léo', 'Sapouy'],
    ),
    RegionData(
      name: 'Centre-Sud',
      provinces: ['Bazèga', 'Nahouri', 'Zoundwéogo'],
      mainCities: ['Manga', 'Kombissiri', 'Pô'],
    ),
    RegionData(
      name: 'Est',
      provinces: ['Gnagna', 'Gourma', 'Komandjoari', 'Kompienga', 'Tapoa'],
      mainCities: ['Fada N\'Gourma', 'Bogandé', 'Diapaga'],
    ),
    RegionData(
      name: 'Hauts-Bassins',
      provinces: ['Houet', 'Kénédougou', 'Tuy'],
      mainCities: ['Bobo-Dioulasso', 'Orodara', 'Houndé'],
    ),
    RegionData(
      name: 'Nord',
      provinces: ['Loroum', 'Passoré', 'Yatenga', 'Zondoma'],
      mainCities: ['Ouahigouya', 'Yako', 'Gourcy', 'Titao'],
    ),
    RegionData(
      name: 'Plateau-Central',
      provinces: ['Ganzourgou', 'Kourwéogo', 'Oubritenga'],
      mainCities: ['Ziniaré', 'Zorgho', 'Boussé'],
    ),
    RegionData(
      name: 'Sahel',
      provinces: ['Oudalan', 'Séno', 'Soum', 'Yagha'],
      mainCities: ['Dori', 'Gorom-Gorom', 'Djibo', 'Sebba'],
    ),
    RegionData(
      name: 'Sud-Ouest',
      provinces: ['Bougouriba', 'Ioba', 'Noumbiel', 'Poni'],
      mainCities: ['Gaoua', 'Diébougou', 'Batié', 'Kampti'],
    ),
  ];

  // Mali - 10 régions + District de Bamako
  static const List<RegionData> mali = [
    RegionData(
      name: 'Kayes',
      provinces: ['Kayes', 'Bafoulabé', 'Diéma', 'Kéniéba', 'Kita', 'Nioro', 'Yélimané'],
      mainCities: ['Kayes', 'Bafoulabé', 'Diéma', 'Kéniéba', 'Kita', 'Nioro du Sahel'],
    ),
    RegionData(
      name: 'Koulikoro',
      provinces: ['Koulikoro', 'Banamba', 'Dioïla', 'Kangaba', 'Kati', 'Kolokani', 'Nara'],
      mainCities: ['Koulikoro', 'Banamba', 'Dioïla', 'Kangaba', 'Kati', 'Kolokani'],
    ),
    RegionData(
      name: 'Sikasso',
      provinces: ['Sikasso', 'Bougouni', 'Kadiolo', 'Kolondiéba', 'Koutiala', 'Yanfolila', 'Yorosso'],
      mainCities: ['Sikasso', 'Bougouni', 'Kadiolo', 'Koutiala'],
    ),
    RegionData(
      name: 'Ségou',
      provinces: ['Ségou', 'Barouéli', 'Bla', 'Macina', 'Niono', 'San', 'Tominian'],
      mainCities: ['Ségou', 'San', 'Niono', 'Bla'],
    ),
    RegionData(
      name: 'Mopti',
      provinces: ['Mopti', 'Bandiagara', 'Bankass', 'Djenné', 'Douentza', 'Koro', 'Ténenkou', 'Youwarou'],
      mainCities: ['Mopti', 'Bandiagara', 'Djenné', 'Douentza'],
    ),
    RegionData(
      name: 'Tombouctou',
      provinces: ['Tombouctou', 'Diré', 'Goundam', 'Gourma-Rharous', 'Niafunké'],
      mainCities: ['Tombouctou', 'Diré', 'Goundam', 'Niafunké'],
    ),
    RegionData(
      name: 'Gao',
      provinces: ['Gao', 'Ansongo', 'Bourem', 'Ménaka'],
      mainCities: ['Gao', 'Ansongo', 'Bourem', 'Ménaka'],
    ),
    RegionData(
      name: 'Kidal',
      provinces: ['Kidal', 'Abeïbara', 'Tessalit', 'Tin-Essako'],
      mainCities: ['Kidal', 'Tessalit'],
    ),
    RegionData(
      name: 'District de Bamako',
      provinces: ['Bamako'],
      mainCities: ['Bamako'],
    ),
  ];

  // Niger - 8 régions
  static const List<RegionData> niger = [
    RegionData(
      name: 'Agadez',
      provinces: ['Agadez', 'Arlit', 'Bilma', 'Tchirozerine'],
      mainCities: ['Agadez', 'Arlit', 'Bilma'],
    ),
    RegionData(
      name: 'Diffa',
      provinces: ['Diffa', 'Maine-Soroa', 'N\'Guigmi'],
      mainCities: ['Diffa', 'Maine-Soroa', 'N\'Guigmi'],
    ),
    RegionData(
      name: 'Dosso',
      provinces: ['Dosso', 'Boboye', 'Dogondoutchi', 'Gaya', 'Loga'],
      mainCities: ['Dosso', 'Gaya', 'Dogondoutchi'],
    ),
    RegionData(
      name: 'Maradi',
      provinces: ['Maradi', 'Aguié', 'Dakoro', 'Guidan-Roumdji', 'Madarounfa', 'Mayahi', 'Tessaoua'],
      mainCities: ['Maradi', 'Dakoro', 'Tessaoua'],
    ),
    RegionData(
      name: 'Tahoua',
      provinces: ['Tahoua', 'Abalak', 'Birni N\'Konni', 'Bouza', 'Illéla', 'Keita', 'Madaoua', 'Tchintabaraden'],
      mainCities: ['Tahoua', 'Birni N\'Konni', 'Madaoua'],
    ),
    RegionData(
      name: 'Tillabéri',
      provinces: ['Tillabéri', 'Filingué', 'Kollo', 'Ouallam', 'Say', 'Téra'],
      mainCities: ['Tillabéri', 'Filingué', 'Téra'],
    ),
    RegionData(
      name: 'Zinder',
      provinces: ['Zinder', 'Gouré', 'Magaria', 'Matameye', 'Mirriah', 'Tanout'],
      mainCities: ['Zinder', 'Magaria', 'Tanout'],
    ),
    RegionData(
      name: 'Niamey',
      provinces: ['Niamey'],
      mainCities: ['Niamey'],
    ),
  ];

  // Obtenir toutes les villes principales d'un pays
  static List<String> getMainCities(String country) {
    final regions = countries[country] ?? [];
    final Set<String> cities = {};
    for (var region in regions) {
      cities.addAll(region.mainCities);
    }
    return cities.toList()..sort();
  }

  // Obtenir toutes les régions d'un pays
  static List<String> getRegions(String country) {
    final regions = countries[country] ?? [];
    return regions.map((r) => r.name).toList()..sort();
  }

  // Obtenir toutes les provinces d'une région
  static List<String> getProvinces(String country, String region) {
    final regions = countries[country] ?? [];
    final regionData = regions.firstWhere(
      (r) => r.name == region,
      orElse: () => const RegionData(name: '', provinces: [], mainCities: []),
    );
    return regionData.provinces..sort();
  }

  // Vérifier si deux villes sont dans le même pays
  static bool areCitiesInSameCountry(String city1, String city2) {
    String? country1, country2;
    
    for (var entry in countries.entries) {
      for (var region in entry.value) {
        if (region.mainCities.contains(city1)) {
          country1 = entry.key;
        }
        if (region.mainCities.contains(city2)) {
          country2 = entry.key;
        }
      }
    }
    
    return country1 != null && country1 == country2;
  }
}
