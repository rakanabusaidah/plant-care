const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
const database = admin.firestore();
exports.reminderSystem = functions.pubsub.schedule("every 1 minutes")
    .onRun((context) => {
      database.collection("operations").get().then((snapshot) => {
        snapshot.forEach((doc) => {
          if (doc.data().endDate < admin.firestore.Timestamp.now()) {
            database.collection("operations").doc(doc.id).update({
              "isActive": false,
            });
          }
          if (doc.data().isActive) {
            if (doc.data().nextReminder < admin.firestore.Timestamp.now()) {
              const data = doc.data();
              const oldDate = doc.data().nextReminder.toDate();
              const updatedDate = new Date();
              updatedDate.setDate(oldDate.getDate() + data.repetition);
              database.collection("operations").doc(doc.id).update({
                "previousReminder": oldDate,
                "nextReminder": updatedDate,
              });
              const token = data.token;
              const typ= data.typeAR;
              const pName = data.plantName;
              const pMethod = data.plantMethod;
              const userID= data.userID;
              const title = "تنبيه " + typ;
              const body = "يوجد لديك تذكير " + typ + " " +
              "للمحصول " + pName +
              " " + "من نوع " + pMethod;
              const payload= {
                notification: {
                  title: title,
                  body: body,
                },
              };
              if (doc.data().isReminding) {
                admin.messaging().sendToDevice(token, payload);
                database.collection("notifications").add({
                  "text": body,
                  "title": title,
                  "userID": userID,
                  "date": admin.firestore.Timestamp.now(),
                });
              }
            }
          }
        });
      });
      return null;
    });
exports.reminder = functions.pubsub.schedule("every 1 minutes")
    .onRun((context) => {
      database.collection("operations").get().then((snapshot) => {
        snapshot.forEach((doc) => {
          if (doc.data().isActive) {
            if (doc.data().startDate < admin.firestore.Timestamp.now()) {
              const data = doc.data();
              const token = data.token;
              const typ= data.typeAR;
              const pName = data.plantName;
              const pMethod = data.plantMethod;
              const userID= data.userID;
              const title = "تنبيه " + typ;
              const body = "يوجد لديك تذكير " + typ + " " +
              "للمحصول " + pName +
              " " + "من نوع " + pMethod;
              const payload= {
                notification: {
                  title: title,
                  body: body,
                },
              };
              if (doc.data().isReminding) {
                admin.messaging().sendToDevice(token, payload);
                database.collection("notifications").add({
                  "text": body,
                  "title": title,
                  "userID": userID,
                  "date": admin.firestore.Timestamp.now(),
                });
              }
            }
          }
        });
      });
      return null;
    });
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
