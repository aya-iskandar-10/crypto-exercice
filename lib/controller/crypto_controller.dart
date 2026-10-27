import 'dart:convert';

import 'package:crypto_exercice/model/crypto_model.dart';
import 'package:crypto_exercice/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:async';                                  // + add
import 'package:crypto_exercice/services/firebase/favorites_store.dart'; // + add

class CryptoController extends ChangeNotifier {
  List<CryptoModel> cryptos = [];

  Future<List<CryptoModel>> fetchCryptos() async {
    final response = await http.get(Uri.parse(AppConstant().apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      debugPrint(response.body);
      List<CryptoModel> cryptos = body
          .map((dynamic item) => CryptoModel.fromJson(item))
          .toList();
      this.cryptos = cryptos; // Update the local list
      return cryptos;
    }
    throw Exception('Failed to load cryptos');
  } FavoritesStore? _store;
  StreamSubscription<Set<String>>? _favSub;
  Set<String> favoriteIds = {};

  bool isFavorite(String coinId) => favoriteIds.contains(coinId);

  List<CryptoModel> get favoriteCoins =>
      cryptos.where((c) => favoriteIds.contains(c.id)).toList();

  /// Call once after login.
  void attachFavorites(FavoritesStore store) {
    _store = store;
    _favSub?.cancel();
    _favSub = store.watch().listen((ids) {
      favoriteIds = ids;
      notifyListeners(); // UI redraws the stars
    });
  }

  Future<void> toggleFavorite(CryptoModel coin) async {
    final store = _store;
    if (store == null) return;
    await store.setFavorite(coin, favorite: !isFavorite(coin.id));
  }

  @override
  void dispose() {
    _favSub?.cancel();
    super.dispose();
  }
}