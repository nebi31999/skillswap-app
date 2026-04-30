import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/tutor.dart';
import '../providers/favorites_provider.dart';

class TutorCard extends StatelessWidget {
  final Tutor tutor;
  final VoidCallback onTap;

  const TutorCard({
    super.key,
    required this.tutor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Profile Image
              Hero(
                tag: 'tutor_${tutor.id}',
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: tutor.profileImage != null
                      ? CachedNetworkImageProvider(tutor.profileImage!)
                      : null,
                  child: tutor.profileImage == null
                      ? Text(
                          tutor.name.isNotEmpty ? tutor.name[0].toUpperCase() : 'T',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 16),
              // Tutor Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and Availability
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            tutor.name,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: tutor.isAvailable ? Colors.green : Colors.grey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            tutor.isAvailable ? 'Available' : 'Busy',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Rating
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${tutor.rating.toStringAsFixed(1)} (${tutor.reviewCount})',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '\$${tutor.hourlyRate.toStringAsFixed(0)}/hr',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Skills
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: tutor.skills.take(3).map((skill) {
                        return Chip(
                          label: Text(
                            skill,
                            style: const TextStyle(fontSize: 11),
                          ),
                          backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                          labelStyle: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 11,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          visualDensity: VisualDensity.compact,
                        );
                      }).toList(),
                    ),
                    if (tutor.skills.length > 3)
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text(
                          '+${tutor.skills.length - 3} more',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    // Description
                    Text(
                      tutor.description.length > 80
                          ? '${tutor.description.substring(0, 80)}...'
                          : tutor.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Favorite Button
              Consumer<FavoritesProvider>(
                builder: (context, favoritesProvider, child) {
                  return IconButton(
                    onPressed: () {
                      favoritesProvider.toggleFavorite(tutor).then((success) {
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                favoritesProvider.isFavorite(tutor.id)
                                    ? 'Added to favorites'
                                    : 'Removed from favorites',
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      });
                    },
                    icon: Icon(
                      favoritesProvider.isFavorite(tutor.id)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: favoritesProvider.isFavorite(tutor.id)
                          ? Colors.red
                          : Colors.grey[600],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
