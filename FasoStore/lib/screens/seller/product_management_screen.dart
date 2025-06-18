import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../models/product.dart';

class ProductManagementScreen extends StatelessWidget {
  const ProductManagementScreen({super.key});

  void _showEditDialog(BuildContext context, Product? product) {
    final _formKey = GlobalKey<FormState>();
    String name = product?.name ?? '';
    String description = product?.description ?? '';
    String imageUrl = product?.imageUrl ?? '';
    double price = product?.price ?? 0.0;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(product == null ? 'Ajouter un produit' : 'Modifier le produit'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: name,
                  decoration: const InputDecoration(labelText: 'Nom'),
                  validator: (value) => value!.isEmpty ? 'Veuillez entrer un nom' : null,
                  onSaved: (value) => name = value!.trim(),
                ),
                TextFormField(
                  initialValue: description,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (value) => value!.isEmpty ? 'Veuillez entrer une description' : null,
                  onSaved: (value) => description = value!.trim(),
                ),
                TextFormField(
                  initialValue: price.toString(),
                  decoration: const InputDecoration(labelText: 'Prix'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty || double.tryParse(value) == null ? 'Veuillez entrer un prix valide' : null,
                  onSaved: (value) => price = double.parse(value!),
                ),
                TextFormField(
                  initialValue: imageUrl,
                  decoration: const InputDecoration(labelText: 'URL de l\'image'),
                  validator: (value) => value!.isEmpty ? 'Veuillez entrer une URL' : null,
                  onSaved: (value) => imageUrl = value!.trim(),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (!_formKey.currentState!.validate()) return;
              _formKey.currentState!.save();

              final productProvider = Provider.of<ProductProvider>(context, listen: false);
              if (product == null) {
                final newProduct = Product(
                  id: DateTime.now().toString(),
                  name: name,
                  description: description,
                  price: price,
                  imageUrl: imageUrl,
                  sellerId: 'currentSellerId', // TODO: Remplacer par l'ID réel du vendeur
                );
                productProvider.addProduct(newProduct);
              } else {
                final updatedProduct = Product(
                  id: product.id,
                  name: name,
                  description: description,
                  price: price,
                  imageUrl: imageUrl,
                  sellerId: product.sellerId,
                );
                productProvider.updateProduct(product.id, updatedProduct);
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final sellerProducts = productProvider.products.where((prod) => prod.sellerId == 'currentSellerId').toList(); // TODO: Remplacer par l'ID réel du vendeur

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des produits'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showEditDialog(context, null),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: sellerProducts.length,
        itemBuilder: (ctx, index) {
          final product = sellerProducts[index];
          return ListTile(
            leading: Image.network(product.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
            title: Text(product.name),
            subtitle: Text('${product.price.toStringAsFixed(2)} FCFA'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showEditDialog(context, product),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    productProvider.deleteProduct(product.id);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
