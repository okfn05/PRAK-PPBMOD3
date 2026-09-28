// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'dart:io';
// import 'detail.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   late Future<List<Country>> countries;

//   @override
//   void initState() {
//     super.initState();
//     countries = fetchCountries();
//   }

//   Future<List<Country>> fetchCountries() async {
//     final uri = Uri.parse('https://www.apicountries.com/countries');
//     final request = await HttpClient().getUrl(uri);
//     final response = await request.close();

//     if (response.statusCode == 200) {
//       final respBody = await response.transform(utf8.decoder).join();
//       final List jsonData = jsonDecode(respBody);
//       return jsonData.map((j) => Country.fromJson(j)).toList();
//     } else {
//       throw Exception('Failed to load countries: ${response.statusCode}');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Countries')),
//       body: FutureBuilder<List<Country>>(
//         future: countries,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No countries found'));
//           }
          
//           final list = snapshot.data!;
//           return ListView.builder(
//             itemCount: list.length,
//             itemBuilder: (context, i) {
//               final country = list[i];
//               return Card(
//                 child: ListTile(
//                   leading: country.flagsPng != null
//                       ? Image.network(country.flagsPng!, width: 50)
//                       : const SizedBox(width: 50),
//                   title: Text(country.name),
//                   subtitle: Text(country.region),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => DetailPage(country: country),
//                       ),
//                     );
//                   },
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// class Country {
//   final String name;
//   final String region;
//   final String? capital;
//   final int population;
//   final String? flagsPng;
//   final List<dynamic>? languages;
//   final List<dynamic>? currencies;

//   Country({
//     required this.name,
//     required this.region,
//     required this.population,
//     this.capital,
//     this.flagsPng,
//     this.languages,
//     this.currencies,
//   });

//   factory Country.fromJson(Map<String, dynamic> json) {
//     List<dynamic>? langs;

//     if (json['languages'] != null) {
//       langs = (json['languages'] as List)
//           .map((l) => l['name'].toString())
//           .toList();
//     }

//     List<dynamic>? cur;

//     if (json['currencies'] != null) {
//       cur = (json['currencies'] as List)
//           .map((c) => c['name'].toString())
//           .toList();
//     }

//     return Country(
//       name: json['name'] ?? 'N/A',
//       region: json['region'] ?? 'N/A',
//       population: json['population'] ?? 0,
//       capital: json['capital'],

//       // Afghanistan menggunakan PNG dari FlagCDN
//       // Negara lain tetap menggunakan URL dari API
//       flagsPng: json['name'] == 'Afghanistan'
//           ? 'https://flagcdn.com/w160/af.png'
//           : (json['flags'] != null ? json['flags']['png'] : null),

//       languages: langs,
//       currencies: cur,
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'detail.dart';

class HomePage extends StatefulWidget {
  final List<Country> favoriteCountries;
  final Function(Country) onFavoriteToggle;
  final bool Function(Country) isFavorite;
  final Function(Country) onCountryTap;

  const HomePage({
    super.key,
    required this.favoriteCountries,
    required this.onFavoriteToggle,
    required this.isFavorite,
    required this.onCountryTap,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Country>> countries;

  final TextEditingController _searchController =
      TextEditingController();

  String _selectedRegion = 'Semua Benua';

  @override
  void initState() {
    super.initState();
    countries = fetchCountries();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Country>> fetchCountries() async {
    final uri = Uri.parse(
      'https://www.apicountries.com/countries',
    );

    final request = await HttpClient().getUrl(uri);
    final response = await request.close();

    if (response.statusCode == 200) {
      final respBody =
          await response.transform(utf8.decoder).join();

      final List jsonData = jsonDecode(respBody);

      return jsonData
          .map((j) => Country.fromJson(j))
          .toList();
    } else {
      throw Exception(
        'Failed to load countries: ${response.statusCode}',
      );
    }
  }

  List<Country> _filterAndSortCountries(
    List<Country> countries,
  ) {
    final query =
        _searchController.text.toLowerCase().trim();

    List<Country> result = countries.where((country) {
      final matchesSearch =
          country.name.toLowerCase().contains(query);

      final matchesRegion =
          _selectedRegion == 'Semua Benua' ||
          country.region == _selectedRegion;

      return matchesSearch && matchesRegion;
    }).toList();

    // Sorting berdasarkan benua/region,
    // kemudian berdasarkan nama negara.
    result.sort((a, b) {
      final regionCompare =
          a.region.compareTo(b.region);

      if (regionCompare != 0) {
        return regionCompare;
      }

      return a.name.compareTo(b.name);
    });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Countries'),
      ),

      body: FutureBuilder<List<Country>>(
        future: countries,

        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
              ),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No countries found'),
            );
          }

          final list =
              _filterAndSortCountries(snapshot.data!);

          // Mendapatkan daftar benua yang tersedia
          final regions = snapshot.data!
              .map((country) => country.region)
              .where((region) => region.isNotEmpty)
              .toSet()
              .toList();

          regions.sort();

          return Column(
            children: [
              // =========================
              // SEARCH BAR
              // =========================

              Padding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  12,
                  16,
                  8,
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari negara...',
                    prefixIcon:
                        const Icon(Icons.search),
                    suffixIcon:
                        _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {});
                                },
                              )
                            : null,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              // =========================
              // SORTING / FILTER BENUa
              // =========================

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.public),
                    const SizedBox(width: 8),

                    const Text(
                      'Benua:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: DropdownButton<String>(
                        value: _selectedRegion,
                        isExpanded: true,

                        items: [
                          const DropdownMenuItem(
                            value: 'Semua Benua',
                            child: Text('Semua Benua'),
                          ),

                          ...regions.map(
                            (region) {
                              return DropdownMenuItem(
                                value: region,
                                child: Text(region),
                              );
                            },
                          ),
                        ],

                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedRegion = value;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(),

              // =========================
              // LIST NEGARA
              // =========================

              Expanded(
                child: list.isEmpty
                    ? const Center(
                        child: Text(
                          'Negara tidak ditemukan',
                        ),
                      )
                    : ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, i) {
                          final country = list[i];

                          return Card(
                            margin:
                                const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),

                            child: ListTile(
                              leading:
                                  country.flagsPng != null
                                      ? Image.network(
                                          country.flagsPng!,
                                          width: 50,
                                          height: 30,
                                          fit: BoxFit.contain,
                                          errorBuilder:
                                              (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return const Icon(
                                              Icons.flag,
                                            );
                                          },
                                        )
                                      : const Icon(
                                          Icons.flag,
                                        ),

                              title: Text(
                                country.name,
                              ),

                              subtitle: Text(
                                country.region,
                              ),

                              trailing: IconButton(
                                icon: Icon(
                                  widget.isFavorite(
                                    country,
                                  )
                                      ? Icons.star
                                      : Icons.star_border,
                                  color:
                                      widget.isFavorite(
                                    country,
                                  )
                                          ? Colors.amber
                                          : null,
                                ),

                                onPressed: () {
                                  widget.onFavoriteToggle(
                                    country,
                                  );

                                  setState(() {});
                                },
                              ),

                              onTap: () {
                                widget.onCountryTap(
                                  country,
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Country {
  final String name;
  final String region;
  final String? capital;
  final int population;
  final String? flagsPng;
  final List<dynamic>? languages;
  final List<dynamic>? currencies;

  Country({
    required this.name,
    required this.region,
    required this.population,
    this.capital,
    this.flagsPng,
    this.languages,
    this.currencies,
  });

  factory Country.fromJson(
    Map<String, dynamic> json,
  ) {
    List<dynamic>? langs;

    if (json['languages'] != null) {
      langs = (json['languages'] as List)
          .map(
            (l) => l['name'].toString(),
          )
          .toList();
    }

    List<dynamic>? cur;

    if (json['currencies'] != null) {
      cur = (json['currencies'] as List)
          .map(
            (c) => c['name'].toString(),
          )
          .toList();
    }

    return Country(
      name: json['name'] ?? 'N/A',

      region: json['region'] ?? 'N/A',

      population: json['population'] ?? 0,

      capital: json['capital'],

      // Afghanistan menggunakan PNG dari FlagCDN.
      // Negara lainnya tetap menggunakan URL
      // yang diberikan oleh API.
      flagsPng: json['name'] == 'Afghanistan'
          ? 'https://flagcdn.com/w160/af.png'
          : (json['flags'] != null
              ? json['flags']['png']
              : null),

      languages: langs,

      currencies: cur,
    );
  }
}