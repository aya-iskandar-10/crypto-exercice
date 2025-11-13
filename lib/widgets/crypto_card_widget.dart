import 'package:flutter/material.dart';
import '../models/crypto_model.dart';

class CryptoCardWidget extends StatelessWidget {
  final CryptoModel cryptoModel;
  final bool isSelected;
  final VoidCallback onTap;

  const CryptoCardWidget({super.key,
    required this.cryptoModel,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: isSelected ? Colors.green : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(cryptoModel.image),
            ),
            const SizedBox(height: 8),
            Text(
              cryptoModel.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(cryptoModel.symbol.toUpperCase()),
            Text('\$${cryptoModel.currentPrice.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}
