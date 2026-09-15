import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/api/api_exception.dart';
import '../../domain/entities/member_profile.dart';
import '../providers/profile_providers.dart';

class EditProfilePage extends ConsumerWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(myProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(_errorMessage(error), textAlign: TextAlign.center),
          ),
        ),
        data: (profile) => _EditProfileForm(profile: profile),
      ),
    );
  }
}

class _EditProfileForm extends ConsumerStatefulWidget {
  final MemberProfile profile;

  const _EditProfileForm({required this.profile});

  @override
  ConsumerState<_EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends ConsumerState<_EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fullNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneNumberController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.profile.fullName);
    _emailController = TextEditingController(text: widget.profile.email);
    _phoneNumberController = TextEditingController(
      text: widget.profile.phoneNumber ?? '',
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final updateState = ref.watch(updateMyProfileProvider);
    final isSaving = updateState.isLoading;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _fullNameController,
              enabled: !isSaving,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Full name',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
              maxLength: 150,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Full name is required.';
                }

                return null;
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _emailController,
              enabled: !isSaving,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Profile email',
                prefixIcon: Icon(Icons.mail_outline_rounded),
                helperText: 'This does not change your login email.',
              ),
              maxLength: 200,
              validator: _validateEmail,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _phoneNumberController,
              enabled: !isSaving,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone number (optional)',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              maxLength: 30,
            ),
            if (updateState.hasError) ...[
              const SizedBox(height: 8),
              Text(
                _errorMessage(updateState.error!),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 16),
            FilledButton(
              onPressed: isSaving ? null : _submit,
              child: isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Email is required.';
    }

    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return 'Enter a valid email address.';
    }

    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final phoneNumber = _phoneNumberController.text.trim();

    try {
      await ref
          .read(updateMyProfileProvider.notifier)
          .saveProfile(
            fullName: _fullNameController.text.trim(),
            email: _emailController.text.trim(),
            phoneNumber: phoneNumber.isEmpty ? null : phoneNumber,
          );

      if (mounted) {
        context.pop(true);
      }
    } catch (_) {
      // The provider state exposes the backend-aware error below the form.
    }
  }
}

String _errorMessage(Object error) {
  if (error is ApiException) {
    return error.message;
  }

  return 'Failed to update your profile.';
}
