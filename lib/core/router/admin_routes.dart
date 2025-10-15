import 'package:go_router/go_router.dart';
import 'package:petmatch/admin/features/pet_management_page.dart';

final adminRoutes = [
  GoRoute(
    path: '/admin/pet-management',
    name: 'admin-pet-management',
    pageBuilder: (context, state) => const NoTransitionPage(
      child: PetManagementPage(),
    ),
  ),
];
