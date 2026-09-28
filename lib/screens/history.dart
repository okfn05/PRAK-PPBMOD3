import 'package:flutter/material.dart';

import 'home.dart';

class HistoryPage extends StatelessWidget {
  final List<Country> historyCountries;
  final Function(Country) onDelete;
  final VoidCallback onClear;
  final Function(Country) onCountryTap;

  const HistoryPage({
    super.key,
    required this.historyCountries,
    required this.onDelete,
    required this.onClear,
    required this.onCountryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat'),

        actions: [
          if (historyCountries.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'Hapus semua riwayat',

              onPressed: () {
                showDialog(
                  context: context,

                  builder: (context) {
                    return AlertDialog(
                      title: const Text(
                        'Hapus semua riwayat?',
                      ),

                      content: const Text(
                        'Semua riwayat akan dihapus secara permanen.',
                      ),

                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },

                          child: const Text('Batal'),
                        ),

                        TextButton(
                          onPressed: () {
                            onClear();
                            Navigator.pop(context);
                          },

                          child: const Text(
                            'Hapus',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
        ],
      ),

      body: historyCountries.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [
                  Icon(
                    Icons.history,
                    size: 80,
                  ),

                  SizedBox(height: 16),

                  Text(
                    'Belum ada riwayat',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: historyCountries.length,

              itemBuilder: (context, index) {
                final country =
                    historyCountries[index];

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

                    subtitle: Text(
                      country.region,
                    ),

                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),

                      tooltip: 'Hapus riwayat',

                      onPressed: () {
                        onDelete(country);
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