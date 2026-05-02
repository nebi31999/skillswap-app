import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/user_provider.dart';
import '../models/user.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _locationController = TextEditingController();
  final List<String> _selectedInterests = [];
  final List<String> _selectedLanguages = [];
  String? _selectedImagePath;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    final user = context.read<UserProvider>().user;
    if (user != null) {
      _nameController.text = user.name;
      _bioController.text = user.bio ?? '';
      _locationController.text = user.location ?? '';
      _selectedInterests.addAll(user.interests);
      _selectedLanguages.addAll(user.languages);
      _selectedImagePath = user.profileImage;
    }
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 70,
      );

      if (image != null) {
        setState(() {
          _selectedImagePath = image.path;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final success = await context.read<UserProvider>().updateProfile(
            name: _nameController.text.trim(),
            bio: _bioController.text.trim().isEmpty ? null : _bioController.text.trim(),
            location: _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
            interests: _selectedInterests,
            languages: _selectedLanguages,
            profileImage: _selectedImagePath,
          );

      if (success && mounted) {
        setState(() {
          _isEditing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.read<UserProvider>().error ?? 'Failed to update profile'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<UserProvider>().logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: const Text(
          'For assistance with SkillSwap:\n\n'
          'Email: support@skillswap.com\n'
          'Phone: +1 (555) 123-4567\n\n'
          'Available Monday-Friday, 9AM-5PM',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Change Password'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: currentPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Current Password',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter current password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: newPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'New Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter new password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Confirm New Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm new password';
                    }
                    if (value != newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final userProvider = context.read<UserProvider>();
                final success = await userProvider.changePassword(
                  currentPasswordController.text,
                  newPasswordController.text,
                );
                
                if (success && mounted) {
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password changed successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(userProvider.error ?? 'Failed to change password'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Change Password'),
          ),
        ],
      ),
    );
  }

  void _showTutorProfileDialog(BuildContext context, User currentUser) {
    final descriptionController = TextEditingController(text: currentUser.tutorDescription);
    final rateController = TextEditingController(
      text: currentUser.hourlyRate?.toString() ?? '25.0',
    );
    final formKey = GlobalKey<FormState>();
    
    final availableSkills = [
      'Mathematics', 'Programming', 'Science', 'Languages', 'Music', 
      'Art', 'Physics', 'Chemistry', 'Biology', 'English', 'Spanish',
      'Java', 'Python', 'JavaScript', 'Flutter', 'React', 'Node.js',
      'Writing', 'Literature', 'History', 'Geography', 'Economics'
    ];
    
    final selectedSkills = List<String>.from(currentUser.teachingSkills);
    bool isAvailable = currentUser.isAvailableAsTutor;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Edit Tutor Profile'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Availability Toggle
                  SwitchListTile(
                    title: const Text('Available for Tutoring'),
                    subtitle: const Text('Toggle to show/hide your profile in tutor list'),
                    value: isAvailable,
                    onChanged: (value) {
                      setDialogState(() {
                        isAvailable = value;
                      });
                    },
                  ),
                  const Divider(),
                  const SizedBox(height: 16),
                  
                  // Teaching Skills
                  Text(
                    'Skills You Teach',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: availableSkills.map((skill) {
                      final isSelected = selectedSkills.contains(skill);
                      return FilterChip(
                        label: Text(skill),
                        selected: isSelected,
                        onSelected: (selected) {
                          setDialogState(() {
                            if (selected) {
                              selectedSkills.add(skill);
                            } else {
                              selectedSkills.remove(skill);
                            }
                          });
                        },
                        selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                        checkmarkColor: Theme.of(context).primaryColor,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  
                  // Hourly Rate
                  TextFormField(
                    controller: rateController,
                    decoration: const InputDecoration(
                      labelText: 'Hourly Rate (USD)',
                      prefixIcon: Icon(Icons.attach_money),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your hourly rate';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Description
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Tutor Description',
                      hintText: 'Describe your teaching experience and expertise...',
                      prefixIcon: Icon(Icons.description),
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final userProvider = context.read<UserProvider>();
                  
                  // Update user with tutor info
                  final success = await userProvider.updateProfile(
                    teachingSkills: selectedSkills,
                    hourlyRate: double.parse(rateController.text),
                    tutorDescription: descriptionController.text,
                    isAvailableAsTutor: isAvailable,
                  );
                  
                  if (success && mounted) {
                    Navigator.pop(dialogContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Tutor profile updated successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            final user = userProvider.user;
            if (user == null) {
              return const Center(
                child: Text('Please login to view your profile'),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'My Profile',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (!_isEditing)
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _isEditing = true;
                          });
                        },
                        icon: const Icon(Icons.edit),
                      ),
                    if (_isEditing)
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _isEditing = false;
                                _loadUserData(); // Reset to original values
                              });
                            },
                            icon: const Icon(Icons.cancel),
                          ),
                          IconButton(
                            onPressed: _saveProfile,
                            icon: const Icon(Icons.save),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 24),

                // Profile Image
                Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Theme.of(context).primaryColor,
                            backgroundImage: _selectedImagePath != null
                                ? (_selectedImagePath!.startsWith('http')
                                    ? NetworkImage(_selectedImagePath!)
                                    : FileImage(File(_selectedImagePath!)) as ImageProvider)
                                : null,
                            child: _selectedImagePath == null
                                ? Text(
                                    user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                                    style: const TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  )
                                : null,
                          ),
                          if (_isEditing)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: FloatingActionButton(
                                onPressed: _pickImage,
                                mini: true,
                                child: const Icon(Icons.camera_alt),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        user.email,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Profile Form
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      TextFormField(
                        controller: _nameController,
                        enabled: _isEditing,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your name';
                          }
                          if (value.trim().length < 2) {
                            return 'Name must be at least 2 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Bio
                      TextFormField(
                        controller: _bioController,
                        enabled: _isEditing,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Bio',
                          hintText: 'Tell us about yourself...',
                          prefixIcon: Icon(Icons.info),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Location
                      TextFormField(
                        controller: _locationController,
                        enabled: _isEditing,
                        decoration: const InputDecoration(
                          labelText: 'Location',
                          hintText: 'City, Country',
                          prefixIcon: Icon(Icons.location_on),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Interests
                      Text(
                        'Interests',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildChipSection(
                        context,
                        ['Mathematics', 'Programming', 'Science', 'Languages', 'Music', 'Art'],
                        _selectedInterests,
                        _isEditing,
                        (interests) {
                          setState(() {
                            _selectedInterests.clear();
                            _selectedInterests.addAll(interests);
                          });
                        },
                      ),
                      const SizedBox(height: 24),

                      // Languages
                      Text(
                        'Languages',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildChipSection(
                        context,
                        ['English', 'Spanish', 'French', 'German', 'Mandarin', 'Japanese'],
                        _selectedLanguages,
                        _isEditing,
                        (languages) {
                          setState(() {
                            _selectedLanguages.clear();
                            _selectedLanguages.addAll(languages);
                          });
                        },
                      ),
                      const SizedBox(height: 32),

                      // Tutor Profile Section (only for users who can teach)
                      if (user.canTeach && !_isEditing) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.school,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Tutor Profile',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  const Spacer(),
                                  if (user.isAvailableAsTutor)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        'Available',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  else
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        'Not Available',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              if (user.teachingSkills.isNotEmpty) ...[
                                Text(
                                  'Teaching:',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: user.teachingSkills.map((skill) {
                                    return Chip(
                                      label: Text(skill),
                                      backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                                      labelStyle: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 12),
                              ],
                              if (user.hourlyRate != null)
                                Text(
                                  'Hourly Rate: \$${user.hourlyRate!.toStringAsFixed(2)}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              const SizedBox(height: 12),
                              if (user.tutorDescription != null && user.tutorDescription!.isNotEmpty)
                                Text(
                                  user.tutorDescription!,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              const SizedBox(height: 12),
                              Center(
                                child: TextButton.icon(
                                  onPressed: () => _showTutorProfileDialog(context, user),
                                  icon: const Icon(Icons.edit),
                                  label: const Text('Edit Tutor Profile'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],

                      // Account Actions
                      if (!_isEditing) ...[
                        const Divider(),
                        const SizedBox(height: 16),
                        ListTile(
                          leading: const Icon(Icons.lock),
                          title: const Text('Change Password'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () => _showChangePasswordDialog(context),
                        ),
                        ListTile(
                          leading: const Icon(Icons.help),
                          title: const Text('Help & Support'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () => _showHelpDialog(context),
                        ),
                        ListTile(
                          leading: const Icon(Icons.logout, color: Colors.red),
                          title: const Text('Logout', style: TextStyle(color: Colors.red)),
                          onTap: _logout,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildChipSection(
    BuildContext context,
    List<String> availableItems,
    List<String> selectedItems,
    bool isEditing,
    Function(List<String>) onSelectionChanged,
  ) {
    if (!isEditing) {
      if (selectedItems.isEmpty) {
        return Text(
          'No items selected',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
        );
      }
      
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: selectedItems.map((item) {
          return Chip(
            label: Text(item),
            backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            labelStyle: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          );
        }).toList(),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: availableItems.map((item) {
        final isSelected = selectedItems.contains(item);
        return FilterChip(
          label: Text(item),
          selected: isSelected,
          onSelected: (selected) {
            final newSelection = List<String>.from(selectedItems);
            if (selected) {
              newSelection.add(item);
            } else {
              newSelection.remove(item);
            }
            onSelectionChanged(newSelection);
          },
          backgroundColor: Colors.grey[200],
          selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
          checkmarkColor: Theme.of(context).primaryColor,
        );
      }).toList(),
    );
  }
}
