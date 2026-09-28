// import 'package:flutter/material.dart';
// import 'home.dart';

// class DetailPage extends StatelessWidget {
//   final Country country;

//   const DetailPage({super.key, required this.country});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(country.name)),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (country.flagsPng != null)
//               Center(
//                 child: Image.network(country.flagsPng!, width: 200),
//               ),
//             const SizedBox(height: 16),
//             Text(
//               'Name: ${country.name}',
//               style: const TextStyle(fontSize: 18),
//             ),
//             Text(
//               'Capital: ${country.capital ?? 'N/A'}',
//               style: const TextStyle(fontSize: 16),
//             ),
//             Text(
//               'Region: ${country.region}',
//               style: const TextStyle(fontSize: 16),
//             ),
//             Text(
//               'Population: ${country.population}',
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Languages: ${country.languages?.join(', ') ?? 'N/A'}',
//               style: const TextStyle(fontSize: 16),
//             ),
//             Text(
//               'Currencies: ${country.currencies?.join(', ') ?? 'N/A'}',
//               style: const TextStyle(fontSize: 16),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

import 'home.dart';

class DetailPage extends StatelessWidget {
  final Country country;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const DetailPage({
    super.key,
    required this.country,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(country.name),

        actions: [
          IconButton(
            icon: Icon(
              isFavorite
                  ? Icons.star
                  : Icons.star_border,
              color: isFavorite
                  ? Colors.amber
                  : null,
            ),
            onPressed: () {
              onFavoriteToggle();

              // Refresh halaman detail agar ikon berubah.
              Navigator.pop(context);
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            if (country.flagsPng != null)
              Center(
                child: Image.network(
                  country.flagsPng!,
                  width: 200,
                  height: 120,
                  fit: BoxFit.contain,

                  errorBuilder:
                      (context, error, stackTrace) {
                    return const Icon(
                      Icons.flag,
                      size: 100,
                    );
                  },
                ),
              ),

            const SizedBox(height: 16),

            Text(
              'Name: ${country.name}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Capital: ${country.capital ?? 'N/A'}',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),

            Text(
              'Region: ${country.region}',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),

            Text(
              'Population: ${country.population}',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Languages: ${country.languages?.join(', ') ?? 'N/A'}',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),

            Text(
              'Currencies: ${country.currencies?.join(', ') ?? 'N/A'}',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}