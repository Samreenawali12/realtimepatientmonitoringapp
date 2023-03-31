const admin = require('firebase-admin');
const serviceAccount = require('./path/to/serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: 'https://<DATABASE_NAME>.firebaseio.com',
});

// Update user
async function updateUser(uid, updatedUserData) {
  try {
    const userRecord = await admin.auth().updateUser(uid, updatedUserData);
    console.log(`Successfully updated user ${uid}:`, userRecord.toJSON());
    return userRecord;
  } catch (error) {
    console.error(`Error updating user ${uid}:`, error);
    throw error;
  }
}

// Delete user
async function deleteUser(uid) {
  try {
    await admin.auth().deleteUser(uid);
    console.log(`Successfully deleted user ${uid}`);
  } catch (error) {
    console.error(`Error deleting user ${uid}:`, error);
    throw error;
  }
}
