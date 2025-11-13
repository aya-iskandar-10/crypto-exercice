import 'package:crypto_exercice/controller/crypto_controller.dart';
import 'package:crypto_exercice/model/crypto_model.dart';
import 'package:crypto_exercice/widgets/crypto_card_widget.dart';
import 'package:flutter/material.dart';



class CryptoListScreen extends StatefulWidget {
  const CryptoListScreen({super.key});

  @override
  _CryptoListScreenState createState() => _CryptoListScreenState();
}

class _CryptoListScreenState extends State<CryptoListScreen> {
  late Future<List<CryptoModel>> futureCryptos;
  final cryptoController = CryptoController();
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    futureCryptos = cryptoController.fetchCryptos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crypto Prices'),
      ),
      body: Center(
        child: FutureBuilder<List<CryptoModel>>(
          future: futureCryptos,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2 / 2.5,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final cryptoModel = snapshot.data![index];
                  final isSelected = _selectedIndex == index;
                  return CryptoCardWidget(
                    cryptoModel: cryptoModel,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
