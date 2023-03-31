// import 'package:firebase_admin/firebase_admin.dart';
// import 'package:firebase_core/firebase_core.dart';

// // Initialize Firebase Admin SDK
// void initializeAdminSdk() {
//   FirebaseAdmin.instance.initializeApp(
//     FirebaseOptions(
//       credential: FirebaseAdmin.instance.certFromPath('path/to/serviceAccount.json'),
//     ) as AppOptions?,
//   );
// }

// // Update user
// Future<UserRecord> updateUser(String uid, Map<String, dynamic> updatedUserData) async {
//   try {
//     final userRecord = await FirebaseAdmin.instance.auth().updateUser(uid, updatedUserData);
//     print('Successfully updated user $uid: ${userRecord.toJson()}');
//     return userRecord;
//   } catch (error) {
//     print('Error updating user $uid: $error');
//     rethrow;
//   }
// }

// // Delete user
// Future<void> deleteUser(String uid) async {
//   try {
//     await FirebaseAdmin.instance.auth().deleteUser(uid);
//     print('Successfully deleted user $uid');
//   } catch (error) {
//     print('Error deleting user $uid: $error');
//     rethrow;
//   }
// }
