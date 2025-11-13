class CryptoModel {
  final String name;
  final String symbol;
  final String image;
  final double currentPrice;

  const CryptoModel({
    required this.name,
    required this.symbol,
    required this.image,
    required this.currentPrice,
  });

  factory CryptoModel.fromJson(Map<String, dynamic> json) {
    return CryptoModel(
      name: json['name'],
      symbol: json['symbol'],
      image: json['image'],
      currentPrice: json['current_price'].toDouble(),
    );
  }
}
