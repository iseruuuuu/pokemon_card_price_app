import 'package:flutter/material.dart';

class RegisterDialog extends StatelessWidget {
  final Function() onRegister;
  final Function(bool?) onSale;
  final TextEditingController storeController;
  final TextEditingController priceController;
  final Function(String) onStoreChange;
  final Function(String) onPriceChange;
  final bool isSale;

  const RegisterDialog({
    required this.onRegister,
    required this.onSale,
    required this.storeController,
    required this.priceController,
    required this.onStoreChange,
    required this.onPriceChange,
    required this.isSale,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          const SizedBox(height: 15),
          TextField(
            autofocus: true,
            decoration: const InputDecoration(
              labelText: "店名",
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue,
                ),
              ),
            ),
            controller: storeController,
            onChanged: onStoreChange,
          ),
          const SizedBox(height: 15),
          TextField(
            autofocus: true,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: '値段',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue,
                ),
              ),
            ),
            controller: priceController,
            onChanged: onPriceChange,
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('特価'),
              Checkbox(
                value: isSale,
                onChanged: onSale,
              ),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'キャンセル',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            SizedBox(
              width: 100,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(elevation: 0),
                onPressed: onRegister,
                child: const Text('登録'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
