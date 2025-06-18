import 'package:flutter/material.dart';

class OnboardingScreens extends StatefulWidget {
  const OnboardingScreens({super.key});

  @override
  State<OnboardingScreens> createState() => _OnboardingScreensState();
}

class _OnboardingScreensState extends State<OnboardingScreens> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Bienvenue sur notre marketplace',
      'description': 'Découvrez une large gamme de produits de qualité à des prix compétitifs.',
      'image': 'assets/onboarding/shopping.png', // TODO: Ajouter les images
    },
    {
      'title': 'Paiement sécurisé',
      'description': 'Payez en toute sécurité avec Mobile Money ou carte de crédit.',
      'image': 'assets/onboarding/payment.png',
    },
    {
      'title': 'Vendez vos produits',
      'description': 'Devenez vendeur et gérez votre boutique en ligne facilement.',
      'image': 'assets/onboarding/seller.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _onboardingData.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    // TODO: Remplacer par Image.asset quand les images seront ajoutées
                    Icon(
                      index == 0 ? Icons.shopping_cart :
                      index == 1 ? Icons.payment :
                      Icons.store,
                      size: 120,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 40),
                    Text(
                      _onboardingData[index]['title']!,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _onboardingData[index]['description']!,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _onboardingData.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentPage < _onboardingData.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      } else {
                        Navigator.pushReplacementNamed(context, '/login');
                      }
                    },
                    child: Text(
                      _currentPage < _onboardingData.length - 1
                          ? 'Suivant'
                          : 'Commencer',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
