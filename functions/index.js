const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);
const collection = admin.firestore().collection('user_info2');
const locationCollection = admin.firestore().collection('locations');
const crossedCollection = admin.firestore().collection('crossed_paths');
const meetRadius = 0.2;
// Create and Deploy Your First Cloud Functions
// https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });
exports.sendMessageNotification = functions.firestore.document('chats/{documentId}')
    .onWrite((change, context) => {

    let beforeValue = change.before.data();
    let afterValue = change.after.data();

    let uid1 = afterValue.user_id1;
    let uid2 = afterValue.user_id2;

    let newMessages = afterValue.messages;

    let lastMessage = newMessages[newMessages.length - 1];

    var reciever = uid1;
    var senderID = lastMessage.sender
    let message = lastMessage.message;
    if (uid1 === senderID)
    {
        reciever = uid2;
    }

    var registrationToken = 'YOUR_REGISTRATION_TOKEN';

    return collection.where('user_id', '==', senderID).get().then((querySnapshot) => {
      var sender = ""
      querySnapshot.forEach((doc) => {
        sender = doc.data().name;
      });
      // const payload = {
      //   notification : {
      //     title : `messsage`,
      //     body : `${sender}: ${message}`
      //   }
      // };
      const payload = {
        notification : {
          body : `message from ${sender}`,
          sender : senderID
        }
      };
      sendNotificaiton(payload, reciever);

      return true;
  }).catch((error) => {
    console.log("Error getting document:", error);
  });
});


function sendNotificaiton(payload, uid)
{
  collection.where('user_id', '==', uid).get().then((querySnapshot) => {
    var token = '';
    querySnapshot.forEach((doc) => {
      if (doc.data().token !== null)
      {
        token = doc.data().token;
        console.log(token);
        console.log(payload);
        return admin.messaging().sendToDevice([token], payload);
      }
      return true;
    });
    return false
  }).catch((error) => console.log("Error fetching user token:", error));
}

exports.sendUserNotification = functions.firestore.document('user_info2/{documentId}')
    .onWrite((change, context) => {

      let beforeValue = change.before.data();
      let afterValue = change.after.data();

      // Send notification if spotted.
      if (afterValue.spotted.length > beforeValue.spotted.length) {
        const payload = {
          notification : {
            body : `you have been spotted`
          }
        };
        return sendNotificaiton(payload, afterValue.user_id);
      }

      // send notification if friended.
      if (afterValue.friends.length > beforeValue.friends.length) {
        const payload = {
          notification : {
            body : `you have a new friend`
          }
        };
        return sendNotificaiton(payload, afterValue.user_id);
      }

      // Update Location Number

      if (afterValue.curLoc !== beforeValue.curLoc)
      {
          locationCollection.where('id', '==', afterValue.curLoc).get().then((querySnapshot) => {
            querySnapshot.forEach((doc) => {
              const data = doc.data();
              if (!data.population) {
                data.population = 1;
              }   else {
                data.population += 1;
              }
              // console.log(data.name + ": " + data.population);
              locationCollection.doc(doc.id).set(data);
            });
            return true;
          }).catch((error) => console.log("Error updating locaiton"));
          locationCollection.where('id', '==', beforeValue.curLoc).get().then((querySnapshot) => {
            querySnapshot.forEach((doc) => {
              const data = doc.data();
              if (!data.population) {
                data.population = 0;
              } else if (data.population > 0) {
                data.population -= 1;
              }
              // console.log(data.name + ": " + data.population);
              locationCollection.doc(doc.id).set(data);
            });
            return true;
          }).catch((error) => console.log("Error updating previous locaiton"));
        }
      // Crossed Paths and Spotts
      if (afterValue.longitude !== beforeValue.longitude)
      {
        const spotts = [];
        collection.get().then((querySnapshot) => {
          var user_doc = "";
          querySnapshot.forEach((doc) => {
            const data = doc.data()
            if (data.user_id === afterValue.user_id)
            {
              user_doc = doc;
            }
            else
            {
              if (withinRadius(afterValue.latitude, afterValue.longitude, data.latitude, data.longitude) === true)
              {
                if(!afterValue.friends.includes(data.user_id) && !afterValue.spotted.includes(data.user_id))
                {
                  spotts.push(data.user_id);
                }
                crossedPaths(data.user_id, afterValue.user_id);
              }
            }
          });
          afterValue.spotts = spotts;
          console.log(afterValue.name + ", " + user_doc.id + ": " + afterValue.spotts + ", " + afterValue.spotts.length)
          collection.doc(user_doc.id).set(afterValue);
          return true
        }).catch((error) => console.log("Could not get users: " + error));
      }
      return true;
});

function withinRadius(lat1, lon1, lat2, lon2)
{
  var R = 6371; // km
  var dLat = toRad(lat2-lat1);
  var dLon = toRad(lon2-lon1);
  var latitude1 = toRad(lat1);
  var latitude2 = toRad(lat2);

  var a = Math.sin(dLat/2) * Math.sin(dLat/2) +
    Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(latitude1) * Math.cos(latitude2);
  var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
  var d = R * c;
  return (d < meetRadius);
}

function toRad(Value)
{
    return Value * Math.PI / 180;
}
