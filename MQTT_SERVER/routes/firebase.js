var admin = require("firebase-admin");
const { QuerySnapshot } = require("firebase-admin/firestore");

var serviceAccount = require('./secureconfig.json');
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: 'https://XCUfiKrpjuTi9esVZN3EGDb87g32.firebaseio.com'
  });

cust_ref.get().then((QuerySnapshot) => {
    QuerySnapshot.forEach(document => {
        console.log(document.data());
    });
});


const firestoreDB = admin.firestore();
module.exports = { firestoreDB };