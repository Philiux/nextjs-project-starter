import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../models/user.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  void _showEditDialog(BuildContext context, UserModel user) {
    String selectedRole = user.role.toString().split('.').last;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Modifier le rôle utilisateur'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Utilisateur: ${user.name}'),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: selectedRole,
              items: UserRole.values.map((role) {
                return DropdownMenuItem(
                  value: role.toString().split('.').last,
                  child: Text(role.toString().split('.').last),
                );
              }).toList(),
              onChanged: (newRole) {
                if (newRole != null) {
                  selectedRole = newRole;
                  // TODO: Mettre à jour le rôle de l'utilisateur dans la base de données
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Sauvegarder les modifications
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
    final userProvider = Provider.of<UserProvider>(context);
    // TODO: Récupérer la liste des utilisateurs depuis la base de données

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des utilisateurs'),
      ),
      body: ListView.builder(
        itemCount: 0, // TODO: Remplacer par le nombre réel d'utilisateurs
        itemBuilder: (context, index) {
          // TODO: Remplacer par les données réelles des utilisateurs
          final user = UserModel(
            id: 'id',
            name: 'Nom utilisateur',
            email: 'email@example.com',
            phoneNumber: '+22600000000',
            role: UserRole.buyer,
          );

          return ListTile(
            leading: CircleAvatar(
              child: Text(user.name[0]),
            ),
            title: Text(user.name),
            subtitle: Text('${user.email} - ${user.role.toString().split('.').last}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showEditDialog(context, user),
                ),
                IconButton(
                  icon: const Icon(Icons.block),
                  onPressed: () {
                    // TODO: Implémenter la désactivation du compte
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
