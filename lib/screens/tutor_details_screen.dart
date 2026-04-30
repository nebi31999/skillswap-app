import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/tutor.dart';
import '../models/review.dart';
import '../providers/favorites_provider.dart';
import '../services/api_service.dart';
import 'request_session_screen.dart';

class TutorDetailsScreen extends StatefulWidget {
  final Tutor tutor;

  const TutorDetailsScreen({
    super.key,
    required this.tutor,
  });

  @override
  State<TutorDetailsScreen> createState() => _TutorDetailsScreenState();
}

class _TutorDetailsScreenState extends State<TutorDetailsScreen> {
  List<Review> _reviews = [];
  bool _isLoadingReviews = false;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    setState(() {
      _isLoadingReviews = true;
    });

    try {
      final reviews = await ApiService.getTutorReviews(widget.tutor.id);
      setState(() {
        _reviews = reviews;
      });
    } catch (e) {
      // Handle error silently
    } finally {
      setState(() {
        _isLoadingReviews = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Hero Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'tutor_${widget.tutor.id}',
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Theme.of(context).primaryColor.withValues(alpha: 0.8),
                        Theme.of(context).primaryColor.withValues(alpha: 0.4),
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Background Image
                      if (widget.tutor.profileImage != null)
                        Positioned.fill(
                          child: CachedNetworkImage(
                            imageUrl: widget.tutor.profileImage!,
                            fit: BoxFit.cover,
                            colorBlendMode: BlendMode.overlay,
                            color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                          ),
                        ),
                      // Profile Info
                      Positioned(
                        bottom: 20,
                        left: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.tutor.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.amber[300],
                                  size: 20,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.tutor.rating.toStringAsFixed(1)} (${widget.tutor.reviewCount} reviews)',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              Consumer<FavoritesProvider>(
                builder: (context, favoritesProvider, child) {
                  return IconButton(
                    onPressed: () {
                      favoritesProvider.toggleFavorite(widget.tutor).then((success) {
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                favoritesProvider.isFavorite(widget.tutor.id)
                                    ? 'Added to favorites'
                                    : 'Removed from favorites',
                              ),
                            ),
                          );
                        }
                      });
                    },
                    icon: Icon(
                      favoritesProvider.isFavorite(widget.tutor.id)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ],
          ),
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Availability Badge
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: widget.tutor.isAvailable ? Colors.green : Colors.grey,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.tutor.isAvailable ? 'Available Now' : 'Currently Busy',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '\$${widget.tutor.hourlyRate.toStringAsFixed(0)}/hour',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Description
                  Text(
                    'About',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.tutor.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),

                  // Skills
                  Text(
                    'Skills',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.tutor.skills.map((skill) {
                      return Chip(
                        label: Text(skill),
                        backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Additional Info
                  _buildInfoRow(
                    context,
                    'Location',
                    widget.tutor.location ?? 'Online',
                    Icons.location_on,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    context,
                    'Languages',
                    widget.tutor.languages.join(', '),
                    Icons.language,
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: widget.tutor.isAvailable
                              ? () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => RequestSessionScreen(tutor: widget.tutor),
                                    ),
                                  );
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Request Session'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // TODO: Implement message feature
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Message feature coming soon!')),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Send Message'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Reviews Section
                  Text(
                    'Reviews (${_reviews.length})',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_isLoadingReviews)
                    const Center(child: CircularProgressIndicator())
                  else if (_reviews.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.rate_review_outlined,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'No reviews yet',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Column(
                      children: _reviews.map((review) {
                        return _ReviewCard(review: review);
                      }).toList(),
                    ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Review review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: review.userProfileImage != null
                      ? CachedNetworkImageProvider(review.userProfileImage!)
                      : null,
                  child: review.userProfileImage == null
                      ? Text(
                          review.userName.isNotEmpty ? review.userName[0].toUpperCase() : 'U',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.userName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          ...List.generate(5, (index) {
                            return Icon(
                              index < review.rating.floor()
                                  ? Icons.star
                                  : index < review.rating
                                      ? Icons.star_half
                                      : Icons.star_border,
                              size: 16,
                              color: Colors.amber[600],
                            );
                          }),
                          const SizedBox(width: 8),
                          Text(
                            review.rating.toStringAsFixed(1),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  _formatDate(review.createdAt),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              review.comment,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (review.topics.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 4,
                children: review.topics.map((topic) {
                  return Chip(
                    label: Text(
                      topic,
                      style: const TextStyle(fontSize: 11),
                    ),
                    backgroundColor: Colors.grey[200],
                    visualDensity: VisualDensity.compact,
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inMinutes}m ago';
    }
  }
}
