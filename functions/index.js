const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

// Cloud Firestore triggers ref: https://firebase.google.com/docs/functions/firestore-events
exports.myFunction = functions.firestore
  .document("notifications/{messageId}")
  .onCreate((snapshot, context) => {
    // Return this function's promise, so this ensures the firebase function
    // will keep running, until the notification is scheduled.
    return admin.messaging().sendToTopic(snapshot.data()["Topic ID"], {
      // Sending a notification message.
      notification: {
        title: snapshot.data()["Title"],
        body: snapshot.data()["Body"],
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
      },
    });
  });