import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tutor_provider.dart';
import '../models/tutor.dart';
import '../widgets/tutor_card.dart';
import 'tutor_details_screen.dart';

class TutorsScreen extends StatefulWidget {
  const TutorsScreen({super.key});

  @override
  State<TutorsScreen> createState() => _TutorsScreenState();
}

class _TutorsScreenState extends State<TutorsScreen> {
  final _searchController = TextEditingController();
  String? _selectedSkill;
  bool _showAvailableOnly = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header and Search
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Find Tutors',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by name, skill, or description...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              context.read<TutorProvider>().searchTutors('');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    context.read<TutorProvider>().searchTutors(value);
                  },
                ),
                const SizedBox(height: 12),
                // Filters
                Row(
                  children: [
                    Expanded(
                      child: Consumer<TutorProvider>(
                        builder: (context, tutorProvider, child) {
                          return DropdownButtonFormField<String>(
                            value: _selectedSkill,
                            decoration: InputDecoration(
                              labelText: 'Filter by Skill',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            items: [
                              const DropdownMenuItem(
                                value: null,
                                child: Text('All Skills'),
                              ),
                              ...tutorProvider.getUniqueSkills().map((skill) {
                                return DropdownMenuItem(
                                  value: skill,
                                  child: Text(skill),
                                );
                              }),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedSkill = value;
                              });
                              context.read<TutorProvider>().filterBySkill(value);
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Available Only Toggle
                    FilterChip(
                      label: const Text('Available Only'),
                      selected: _showAvailableOnly,
                      onSelected: (selected) {
                        setState(() {
                          _showAvailableOnly = selected;
                        });
                      },
                      backgroundColor: Colors.grey[200],
                      selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                      checkmarkColor: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Clear Filters
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _selectedSkill = null;
                          _showAvailableOnly = false;
                        });
                        context.read<TutorProvider>().clearFilters();
                      },
                      child: const Text('Clear Filters'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Tutors List
          Expanded(
            child: Consumer<TutorProvider>(
              builder: (context, tutorProvider, child) {
                if (tutorProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (tutorProvider.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading tutors',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          tutorProvider.error!,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => tutorProvider.refresh(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final tutors = _showAvailableOnly 
                    ? tutorProvider.availableTutors 
                    : tutorProvider.tutors;

                if (tutors.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No tutors found',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your filters or search terms',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => tutorProvider.refresh(),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: tutors.length,
                    itemBuilder: (context, index) {
                      final tutor = tutors[index];
                      return TutorCard(
                        tutor: tutor,
                        onTap: () => _navigateToTutorDetails(tutor),
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

  void _navigateToTutorDetails(Tutor tutor) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TutorDetailsScreen(tutor: tutor),
      ),
    );
  }
}
