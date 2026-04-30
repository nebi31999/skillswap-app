import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tutor.dart';
import '../models/request.dart';
import '../providers/user_provider.dart';
import '../widgets/skill_selector.dart';

class RequestSessionScreen extends StatefulWidget {
  final Tutor tutor;

  const RequestSessionScreen({
    super.key,
    required this.tutor,
  });

  @override
  State<RequestSessionScreen> createState() => _RequestSessionScreenState();
}

class _RequestSessionScreenState extends State<RequestSessionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _durationController = TextEditingController();
  final _rateController = TextEditingController();

  RequestType _requestType = RequestType.tutoring;
  List<String> _selectedTopics = [];
  bool _isOnline = true;
  DateTime? _scheduledDate;
  TimeOfDay? _scheduledTime;

  @override
  void initState() {
    super.initState();
    _rateController.text = widget.tutor.hourlyRate.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _durationController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  Future<void> _submitRequest() async {
    if (_formKey.currentState!.validate()) {
      // In a real app, this would send the request to an API
      final mockRequest = TutorRequest(
        id: 'req_${DateTime.now().millisecondsSinceEpoch}',
        userId: context.read<UserProvider>().user?.id ?? 'unknown',
        tutorId: widget.tutor.id,
        type: _requestType,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        status: RequestStatus.pending,
        createdAt: DateTime.now(),
        scheduledFor: _scheduledDate != null && _scheduledTime != null
            ? DateTime(
                _scheduledDate!.year,
                _scheduledDate!.month,
                _scheduledDate!.day,
                _scheduledTime!.hour,
                _scheduledTime!.minute,
              )
            : null,
        proposedRate: double.tryParse(_rateController.text),
        location: _isOnline ? null : _locationController.text.trim(),
        isOnline: _isOnline,
        duration: int.tryParse(_durationController.text),
        topics: _selectedTopics,
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Session request sent successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Session'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tutor Info Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            widget.tutor.name.isNotEmpty 
                                ? widget.tutor.name[0].toUpperCase()
                                : 'T',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.tutor.name,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '\$${widget.tutor.hourlyRate.toStringAsFixed(0)}/hour',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Request Type
                Text(
                  'Request Type',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<RequestType>(
                        title: const Text('Tutoring'),
                        value: RequestType.tutoring,
                        groupValue: _requestType,
                        onChanged: (value) {
                          setState(() {
                            _requestType = value!;
                          });
                        },
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<RequestType>(
                        title: const Text('Skill Exchange'),
                        value: RequestType.skillExchange,
                        groupValue: _requestType,
                        onChanged: (value) {
                          setState(() {
                            _requestType = value!;
                          });
                        },
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Title
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Session Title',
                    hintText: 'e.g., Help with Calculus Homework',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a session title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Describe what you need help with...',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a description';
                    }
                    if (value.trim().length < 10) {
                      return 'Description must be at least 10 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Topics/Skills
                Text(
                  'Topics/Skills',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                SkillSelector(
                  availableSkills: widget.tutor.skills,
                  selectedSkills: _selectedTopics,
                  onSelectionChanged: (skills) {
                    setState(() {
                      _selectedTopics = skills;
                    });
                  },
                ),
                const SizedBox(height: 24),

                // Session Details
                Text(
                  'Session Details',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Online/In-Person
                SwitchListTile(
                  title: Text(_isOnline ? 'Online Session' : 'In-Person Session'),
                  subtitle: Text(_isOnline ? 'Meet virtually' : 'Meet at a physical location'),
                  value: _isOnline,
                  onChanged: (value) {
                    setState(() {
                      _isOnline = value;
                    });
                  },
                ),

                // Location (only for in-person)
                if (!_isOnline) ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: 'Meeting Location',
                      hintText: 'e.g., Library, Coffee Shop, etc.',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (!_isOnline && (value == null || value.trim().isEmpty)) {
                        return 'Please enter a meeting location';
                      }
                      return null;
                    },
                  ),
                ],

                // Duration
                const SizedBox(height: 16),
                TextFormField(
                  controller: _durationController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Duration (minutes)',
                    hintText: 'e.g., 60',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter session duration';
                    }
                    final duration = int.tryParse(value);
                    if (duration == null || duration < 15) {
                      return 'Duration must be at least 15 minutes';
                    }
                    if (duration > 240) {
                      return 'Duration cannot exceed 4 hours';
                    }
                    return null;
                  },
                ),

                // Proposed Rate
                const SizedBox(height: 16),
                TextFormField(
                  controller: _rateController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Proposed Rate (\$/hour)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a proposed rate';
                    }
                    final rate = double.tryParse(value);
                    if (rate == null || rate <= 0) {
                      return 'Please enter a valid rate';
                    }
                    return null;
                  },
                ),

                // Schedule Date & Time
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: const Text('Schedule Date'),
                        subtitle: Text(
                          _scheduledDate != null
                              ? '${_scheduledDate!.day}/${_scheduledDate!.month}/${_scheduledDate!.year}'
                              : 'Select date',
                        ),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: _selectDate,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text('Schedule Time'),
                        subtitle: Text(
                          _scheduledTime != null
                              ? '${_scheduledTime!.hour.toString().padLeft(2, '0')}:${_scheduledTime!.minute.toString().padLeft(2, '0')}'
                              : 'Select time',
                        ),
                        trailing: const Icon(Icons.access_time),
                        onTap: _selectTime,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Submit Button
                Consumer<UserProvider>(
                  builder: (context, userProvider, child) {
                    return ElevatedButton(
                      onPressed: userProvider.user != null ? _submitRequest : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Send Request', style: TextStyle(fontSize: 16)),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null) {
      setState(() {
        _scheduledDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now().add(const Duration(hours: 1))),
    );
    if (picked != null) {
      setState(() {
        _scheduledTime = picked;
      });
    }
  }
}
