import 'package:crypto_exercice/controller/crypto_controller.dart';
import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key, required this.controller});

  final CryptoController controller; // the SAME controller as the list screen

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Favorites')),
      // Rebuilds live whenever Firestore changes the favorites.
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          final favorites = controller.favoriteCoins;

          if (favorites.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No favorites yet.\nTap the star on a coin to add it.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.separated(
            itemCount: favorites.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final crypto = favorites[index];
              return ListTile(
                leading: Image.network(
                  crypto.image,
                  width: 40,
                  height: 40,
                  errorBuilder: (_, __, ___) => const Icon(Icons.currency_bitcoin),
                ),
                title: Text(crypto.name),
                subtitle: Text(crypto.symbol.toUpperCase()),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '\$${crypto.currentPrice.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      tooltip: 'Remove from favorites',
                      icon: const Icon(Icons.star, color: Colors.amber),
                      onPressed: () => controller.toggleFavorite(crypto),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}