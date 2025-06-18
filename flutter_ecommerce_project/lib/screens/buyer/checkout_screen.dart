import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../services/payment_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _paymentMethod = 'Carte de crédit';
  bool _isProcessing = false;
  final PaymentService _paymentService = PaymentService();

  void _submitOrder() async {
    setState(() {
      _isProcessing = true;
    });

    final cart = Provider.of<CartProvider>(context, listen: false);
    bool success = false;

    if (_paymentMethod == 'Carte de crédit') {
      // TODO: Intégrer Flutter Stripe pour paiement carte
      success = await _paymentService.payWithCreditCard('4242424242424242', '12/24', '123', cart.totalAmount);
    } else {
      // Paiement Mobile Money
      success = await _paymentService.payWithMobileMoney(_paymentMethod, cart.totalAmount);
    }

    setState(() {
      _isProcessing = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Paiement réussi!')));
      cart.clear();
      Navigator.popUntil(context, ModalRoute.withName('/buyer_home'));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Échec du paiement.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paiement'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Montant total: ${cart.totalAmount.toStringAsFixed(2)} FCFA'),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: _paymentMethod,
              items: const [
                DropdownMenuItem(value: 'Carte de crédit', child: Text('Carte de crédit')),
                DropdownMenuItem(value: 'Orange Money', child: Text('Orange Money')),
                DropdownMenuItem(value: 'Moov Money', child: Text('Moov Money')),
                DropdownMenuItem(value: 'Telecel Money', child: Text('Telecel Money')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _paymentMethod = value;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            _isProcessing
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _submitOrder,
                    child: const Text('Payer'),
                  ),
          ],
        ),
      ),
    );
  }
}
