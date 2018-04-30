const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

// Create and Deploy Your First Cloud Functions
// https://firebase.google.com/docs/functions/write-firebase-functions

exports.helloWorld = functions.https.onRequest((request, response) => {
 response.send("Hello from Firebase!");
});
exports.sendMessageNotification = functions.firestore.document('chats/{documentId}')
    .onWrite((change, context) => {

    let beforeValue = change.before.data();
    let afterValue = change.after.data();

    let uid1 = afterValue.user_id1;
    let uid2 = afterValue.user_id2;

    let oldMessages = beforeValue.messages;
    let newMessages = afterValue.messages;

    let lastMessage = newMessages[oldMessages.length];

    var reciever = uid1;
    var senderID = lastMessage.sender
    let message = lastMessage.message;
    if (uid1 === senderID)
    {
        reciever = uid2;
    }

    var registrationToken = 'YOUR_REGISTRATION_TOKEN';


    let collection = admin.firestore().collection('user_info2');
    return collection.where('user_id', '==', senderID).get().then((querySnapshot) => {
      var sender = ""
      querySnapshot.forEach((doc) => {
        sender = doc.data().name;
      });
      const payload = {
        notification : {
          title : `new message from ${sender}`,
          body : `${sender}: ${message}`
        }
      };
      sendNotificaiton(payload, reciever)
      admin.messaging().sendToDevice(instanceId, payload);

      return true;
  }).catch((error) => {
    console.log("Error getting document:", error);
  });
});


sendNotificaiton (payload, uid)
{
  const getSenderUidPromise = admin.auth().getUser(uid).then((userRecord) => {
    // See the UserRecord reference doc for the contents of userRecord.
    console.log(userRecord);
    return 1;
  })
  .catch(function(error) {
    console.log("Error fetching user data:", error);
  });
}
