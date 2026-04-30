import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/tutor_card.dart';
import 'tutor_details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  final Function(int)? onNavigateToTab;
  
  const FavoritesScreen({super.key, this.onNavigateToTab});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'My Favorites',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Consumer<FavoritesProvider>(
                  builder: (context, favoritesProvider, child) {
                    if (favoritesProvider.favorites.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    
                    return TextButton.icon(
                      onPressed: () => _showClearFavoritesDialog(context),
                      icon: const Icon(Icons.clear_all),
                      label: const Text('Clear All'),
                    );
                  },
                ),
              ],
            ),
          ),
          // Favorites List
          Expanded(
            child: Consumer<FavoritesProvider>(
              builder: (context, favoritesProvider, child) {
                if (favoritesProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (favoritesProvider.favorites.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No favorites yet',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Start adding tutors to your favorites to see them here',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            if (onNavigateToTab != null) {
                              onNavigateToTab!(1);
                            }
                          },
                          child: const Text('Browse Tutors'),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => favoritesProvider.refresh(),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: favoritesProvider.favorites.length,
                    itemBuilder: (context, index) {
                      final tutor = favoritesProvider.favorites[index];
                      return TutorCard(
                        tutor: tutor,
                        onTap: () => _navigateToTutorDetails(context, tutor),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToTutorDetails(BuildContext context, tutor) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TutorDetailsScreen(tutor: tutor),
      ),
    );
  }

  void _showClearFavoritesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Favorites'),
        content: const Text('Are you sure you want to remove all tutors from your favorites?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<FavoritesProvider>().clearAllFavorites().then((success) {
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All favorites cleared')),
                  );
                }
              });
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
