import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'Français';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
      ),
      body: ListView(
        children: [
          const ListTile(
            title: Text(
              'Préférences générales',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Notifications'),
            subtitle: const Text('Recevoir des notifications sur les commandes et promotions'),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
              // TODO: Sauvegarder la préférence
            },
          ),
          SwitchListTile(
            title: const Text('Mode sombre'),
            subtitle: const Text('Activer le thème sombre'),
            value: _darkModeEnabled,
            onChanged: (bool value) {
              setState(() {
                _darkModeEnabled = value;
              });
              // TODO: Changer le thème de l'application
            },
          ),
          ListTile(
            title: const Text('Langue'),
            subtitle: Text(_selectedLanguage),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Choisir la langue'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RadioListTile(
                        title: const Text('Français'),
                        value: 'Français',
                        groupValue: _selectedLanguage,
                        onChanged: (value) {
                          setState(() {
                            _selectedLanguage = value.toString();
                          });
                          Navigator.pop(context);
                        },
                      ),
                      RadioListTile(
                        title: const Text('English'),
                        value: 'English',
                        groupValue: _selectedLanguage,
                        onChanged: (value) {
                          setState(() {
                            _selectedLanguage = value.toString();
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const Divider(),
          const ListTile(
            title: Text(
              'Sécurité',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            title: const Text('Changer le mot de passe'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Implémenter le changement de mot de passe
            },
          ),
          ListTile(
            title: const Text('Vérification en deux étapes'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Implémenter la 2FA
            },
          ),
          const Divider(),
          const ListTile(
            title: Text(
              'À propos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ListTile(
            title: const Text('Version de l\'application'),
            subtitle: const Text('1.0.0'),
          ),
          ListTile(
            title: const Text('Conditions d\'utilisation'),
            onTap: () {
              // TODO: Afficher les conditions d'utilisation
            },
          ),
          ListTile(
            title: const Text('Politique de confidentialité'),
            onTap: () {
              // TODO: Afficher la politique de confidentialité
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Se déconnecter'),
            textColor: Colors.red,
            leading: const Icon(Icons.logout, color: Colors.red),
            onTap: () async {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              await authProvider.signOut();
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
    );
  }
}
