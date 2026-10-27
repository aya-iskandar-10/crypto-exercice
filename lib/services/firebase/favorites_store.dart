import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_exercice/model/crypto_model.dart';
/// The contract the controller talks to. Firestore is one implementation.
abstract class FavoritesStore {
  Stream<Set<String>> watch();
  Future<void> setFavorite(CryptoModel crypto, {required bool favorite});
}

class FirestoreFavoritesStore implements FavoritesStore {
  FirestoreFavoritesStore(this.uid, {FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  final String uid;
  final FirebaseFirestore _db;

  // users/{uid}/favorites
  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('users').doc(uid).collection('favorites');

  /// LISTEN: emits the set of favorite coin ids, now and on every change.
  @override
  Stream<Set<String>> watch() =>
      _col.snapshots().map((snap) => snap.docs.map((d) => d.id).toSet());

  /// CREATE (set with our own id) or DELETE.
  @override
  Future<void> setFavorite(CryptoModel crypto, {required bool favorite}) {
    final doc = _col.doc(crypto.id);
    if (!favorite) return doc.delete();
    return doc.set({
      'name': crypto.name,
      'symbol': crypto.symbol.toUpperCase(),
      'priceWhenAdded': crypto.currentPrice, // number, not String
      'image': crypto.image,
      'addedAt': FieldValue.serverTimestamp(),
    });
  }
}