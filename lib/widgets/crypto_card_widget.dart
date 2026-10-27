import 'package:crypto_exercice/model/crypto_model.dart';
import 'package:flutter/material.dart';

class CryptoCardWidget extends StatelessWidget {
  const CryptoCardWidget({
    super.key,
    required this.cryptoModel,
    required this.isSelected,
    required this.onTap,
    required this.isFavorite,
    required this.onFavoriteTap,
  });

  final CryptoModel cryptoModel;
  final bool isSelected;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  /// 79512.0 -> $79,512.00   |   0.0123 -> $0.0123
  static String formatPrice(double v) {
    final fixed = v >= 1 ? v.toStringAsFixed(2) : v.toStringAsFixed(4);
    final parts = fixed.split('.');
    final whole = parts[0].replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => ',',
    );
    return '\$$whole.${parts[1]}';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: isSelected ? 4 : 1,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: isSelected ? Colors.green : Colors.black12,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            // ---------- content ----------
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 20, 12, 14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Image.network(
                      cryptoModel.image,
                      width: 44,
                      height: 44,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.currency_bitcoin, size: 36),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    cryptoModel.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    cryptoModel.symbol.toUpperCase(),
                    style: TextStyle(
                      fontSize: 13,
                      color: cs.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: cs.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        formatPrice(cryptoModel.currentPrice),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ---------- favorite star (inside the card) ----------
            Positioned(
              top: 2,
              right: 2,
              child: IconButton(
                tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
                onPressed: onFavoriteTap,
                icon: Icon(
                  isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: isFavorite ? Colors.amber : Colors.black38,
                  size: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}