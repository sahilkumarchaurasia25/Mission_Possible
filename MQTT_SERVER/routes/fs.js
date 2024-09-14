// firebaseService.js
const { db, realtimeDB } = require('./firebase');

// Function to upload data to Firestore
async function uploadToFirestore(collection, document, data) {
  try {
    await db.collection(collection).doc(document).set(data);
    console.log(`Document written to Firestore: ${collection}/${document}`);
  } catch (error) {
    console.error('Error uploading to Firestore:', error);
  }
}

// Function to upload data to Firebase Realtime Database
async function uploadToRealtimeDB(ref, data) {
  try {
    await realtimeDB.ref(ref).set(data);
    console.log(`Data uploaded to Realtime Database: ${ref}`);
  } catch (error) {
    console.error('Error uploading to Realtime Database:', error);
  }
}

module.exports = {
  uploadToFirestore,
  uploadToRealtimeDB,
};
