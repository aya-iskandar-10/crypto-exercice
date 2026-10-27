import 'package:crypto_exercice/controller/crypto_controller.dart';
import 'package:crypto_exercice/model/crypto_model.dart';
import 'package:crypto_exercice/services/firebase/auth_service.dart';
import 'package:crypto_exercice/view/favorites_screen.dart';
import 'package:crypto_exercice/widgets/crypto_card_widget.dart';
import 'package:flutter/material.dart';

class CryptoListScreen extends StatefulWidget {
  const CryptoListScreen({super.key, required this.controller});

  final CryptoController controller;

  @override
  State<CryptoListScreen> createState() => _CryptoListScreenState();
}

class _CryptoListScreenState extends State<CryptoListScreen> {
  late Future<List<CryptoModel>> futureCryptos;
  int? _selectedIndex;

  CryptoController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    futureCryptos = controller.fetchCryptos();
  }

  void _openFavorites() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FavoritesScreen(controller: controller),
      ),
    );
  }

  void _retry() {
    setState(() => futureCryptos = controller.fetchCryptos());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crypto Prices'),
        actions: [
          ListenableBuilder(
            listenable: controller,
            builder: (context, _) => IconButton(
              tooltip: 'My favorites',
              onPressed: _openFavorites,
              icon: Badge.count(
                count: controller.favoriteIds.length,
                isLabelVisible: controller.favoriteIds.isNotEmpty,
                child: const Icon(Icons.star_rounded, size: 28),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Log out',
            icon: const Icon(Icons.logout),
            onPressed: () => AuthService().signOut(),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: FutureBuilder<List<CryptoModel>>(
        future: futureCryptos,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${snapshot.error}', textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    FilledButton(onPressed: _retry, child: const Text('Retry')),
                  ],
                ),
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final cryptos = snapshot.data!;

          // Rebuild the grid whenever favorites change.
          return ListenableBuilder(
            listenable: controller,
            builder: (context, _) => GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200, // as many columns as fit
                mainAxisExtent: 215,     // fixed card height: no overflow
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: cryptos.length,
              itemBuilder: (context, index) {
                final crypto = cryptos[index];
                return CryptoCardWidget(
                  cryptoModel: crypto,
                  isSelected: _selectedIndex == index,
                  isFavorite: controller.isFavorite(crypto.id),
                  onTap: () => setState(() => _selectedIndex = index),
                  onFavoriteTap: () => controller.toggleFavorite(crypto),
                );
              },
            ),
          );
        },
      ),
    );
  }
}