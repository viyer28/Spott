const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);
const collection = admin.firestore().collection('user_info2');
const locationCollection = admin.firestore().collection('locations');
const crossedCollection = admin.firestore().collection('crossed_paths');
const enterCollection = admin.firestore().collection('visited_locations');
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
  }).catch((error) => console.log("Error fetching user token:" + error));
}

exports.sendUserNotification = functions.firestore.document('user_info2/{documentId}')
    .onWrite((change, context) => {

      let beforeValue = change.before.data();
      let afterValue = change.after.data();

      if (!afterValue.score)
      {
        afterValue.score = 0;
      }


      // Send notification if spotted.
      if (afterValue.spotted.length > beforeValue.spotted.length) {
        const payload = {
          notification : {
            body : `you have been spotted`
          }
        };
        afterValue.score += 13;
        collection.doc(change.after.id).set(afterValue);
        return sendNotificaiton(payload, afterValue.user_id);
      }

      // send notification if friended.
      if (afterValue.friends.length > beforeValue.friends.length) {
        const payload = {
          notification : {
            body : `you have a new friend`
          }
        };
        afterValue.score += 17;
        collection.doc(change.after.id).set(afterValue);
        return sendNotificaiton(payload, afterValue.user_id);
      }

      // Update Location Number

      if (afterValue.curLoc !== beforeValue.curLoc)
      {
          locationCollection.where('id', '==', afterValue.curLoc).get().then((querySnapshot) => {
            querySnapshot.forEach((doc) => {
              const data = doc.data();
              if (!data.users || !data.population)
              {
                data.population = 1;
                data.users[afterValue.user_id];
                afterValue.score += 2;
                enterLocation(afterValue.user_id, data.id);
                collection.doc(change.after.id).set(afterValue);
                locationCollection.doc(doc.id).set(data);
              }
              else if (!data.users.includes(afterValue.user_id))
              {
                data.users.push(afterValue.user_id);
                data.population = data.users.length;
                afterValue.score += 2;
                enterLocation(afterValue.user_id, data.id);
                collection.doc(change.after.id).set(afterValue);
                locationCollection.doc(doc.id).set(data);
              }
            });
            return true;
          }).catch((error) => console.log("Error visiting a location: " + error));
          locationCollection.where('id', '==', beforeValue.curLoc).get().then((querySnapshot) => {
            querySnapshot.forEach((doc) => {
              const data = doc.data();
              if (!data.users || !data.population)
              {
                data.population = 0;
                data.users = [];
                locationCollection.doc(doc.id).set(data);
              } else if (data.users.includes(afterValue.user_id))
              {
                data.users = data.users.filter(x => x !== afterValue.user_id);
                data.population = data.users.length;
                locationCollection.doc(doc.id).set(data);
              }
            });
            return true;
          }).catch((error) => console.log("Error updating previous locaiton: " + error));
        }
      // Crossed Paths and Spotts
      if (!withinRadius(afterValue.latitude, afterValue.longitude, beforeValue.latitude, beforeValue.longitude, 0.1))
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
              if (withinRadius(afterValue.latitude, afterValue.longitude, data.latitude, data.longitude, 0.2) === true)
              {
                if(!afterValue.friends.includes(data.user_id) && !afterValue.spotted.includes(data.user_id))
                {
                  spotts.push(data.user_id);
                }
                if (withinRadius(beforeValue.latitude, beforeValue.longitude, data.latitude, data.longitude, 0.2) === false)
                {
                  crossedPaths(afterValue.user_id, data.user_id);
                  afterValue.score += 5;
                }
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

function withinRadius(lat1, lon1, lat2, lon2, rad)
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
  return (d < rad);
}

function toRad(Value)
{
    return Value * Math.PI / 180;
}

function crossedPaths(user1, user2)
{
  var id1 = user1;
  var id2 = user2;
  if (user2 > user1)
  {
    id1 = user2;
    id2 = user1;
  }
  crossedCollection.where('id1', '==', id1).where('id2', '==', id2).get().then((querySnapshot) => {
    if (querySnapshot.size === 0)
    {
      const data = {
        'id1' : id1,
        'id2' : id2,
        'count' : 1
      };
      crossedCollection.add(data);
    } else {
      querySnapshot.forEach((doc) => {
        const data = doc.data();
        data.count += 1;
        crossedCollection.doc(doc.id).set(data);
      })
    }
    return true;
  }).catch((error) => console.log("Error added crossed location: " + error));

}

function enterLocation(user, location)
{
  if (location === -1)
  {
    return true;
  }
  enterCollection.where('user_id', '==', user).where('location_id', '==', location).get().then((querySnapshot) => {
    if (querySnapshot.size === 0)
    {
      console.log(user + " enter " + location)
      const data = {
        'user_id' : user,
        'location_id' : location,
        'count' : 1
      };
      enterCollection.add(data);
    } else {
      querySnapshot.forEach((doc) => {
        const data = doc.data();
        data.count += 1;
        enterCollection.doc(doc.id).set(data);
      })
    }
    return true;
  }).catch((error) => console.log("Error entering location: " + error));
  return true;
}

exports.updateranks = functions.firestore.document('rank_timer/{documentId}')
    .onWrite((change, context) => {
      updateScoreboardRanks();
      return true;
});

function updateScoreboardRanks()
{
  collection.get().then((querySnapshot) => {
    const ranks = []
    querySnapshot.forEach((doc) => {
      const rank = doc.data();
      if (!rank.prevRank)
      {
        rank.prevRank = -1;
      }
      if (!rank.rank)
      {
        rank.rank = -1;
      }
      if (!rank.score)
      {
        rank.score = 0;
      }
      ranks.push({data: rank, doc: doc.id});
    });
    console.log(ranks);
    ranks.sort((a, b) => b.data.score - a.data.score);
    var i = 1;
    console.log(ranks);
    ranks.forEach((rank) => {
      rank.data.prevRank = rank.data.rank;
      rank.data.rank = i;
      i += 1;
      collection.doc(rank.doc).set(rank.data);
    });
    return true
  }).catch((error) => console.log("Error updating ranks: " + error))
}
