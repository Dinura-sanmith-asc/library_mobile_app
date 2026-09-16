import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/secure_storage_service.dart';
import 'api_client.dart';

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return const SecureStorageService();
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final secureStorageService = ref.watch(secureStorageServiceProvider);

  return ApiClient(secureStorageService);
});
