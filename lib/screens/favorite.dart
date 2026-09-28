import 'package:flutter/material.dart';

import 'home.dart';

class FavoritePage extends StatelessWidget {
  final List<Country> favoriteCountries;
  final Function(Country) onFavoriteToggle;
  final bool Function(Country) isFavorite;
  final Function(Country) onCountryTap;

  const FavoritePage({
    super.key,
    required this.favoriteCountries,
    required this.onFavoriteToggle,
    required this.isFavorite,
    required this.onCountryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorit'),
      ),

      body: favoriteCountries.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star_border,
                    size: 80,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Belum ada negara favorit',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: favoriteCountries.length,

              itemBuilder: (context, index) {
                final country =
                    favoriteCountries[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),

                  child: ListTile(
                    leading: country.flagsPng != null
                        ? Image.network(
                            country.flagsPng!,
                            width: 50,
                            height: 30,
                            fit: BoxFit.contain,
                            errorBuilder:
                                (context, error, stackTrace) {
                              return const Icon(
                                Icons.flag,
                              );
                            },
                          )
                        : const Icon(Icons.flag),

                    title: Text(country.name),

                    subtitle: Text(country.region),

                    trailing: IconButton(
                      icon: const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),

                      onPressed: () {
                        onFavoriteToggle(country);
                      },
                    ),

                    onTap: () {
                      onCountryTap(country);
                    },
                  ),
                );
              },
            ),
    );
  }
}