const admin  = require("firebase-admin");
const functions = require("firebase-functions");
const math = require("math");
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
admin.initializeApp();

exports.onUpdateDriverLocations = functions.firestore.document("/DriverCredentials/{userId}").onUpdate(async (change, context) =>{
  console.log("Entered in the onupdate function");
const driverDetails = change.after.data();
// console.log(`testing data ${driverDetails.data()["Name"]}`);
console.log(`after value longitude : ${driverDetails["Lon"]} and ${driverDetails["Name"]}`);
 await admin.firestore().collection("ResidentCredentials").get().then(
   async (querysnapshot) => {
      await querysnapshot.forEach(async (doc) => {
        console.log(`${doc.data()["Name"]} is going to be notified`);
        console.log(`driver lon: ${driverDetails["Lon"]} driver lat: ${driverDetails["Lat"]} resident lon : ${doc.data()["Lon"]} resident lat : ${doc.data()["Lat"]} `);
        

        var distance = calculateDistance(
           driverDetails["Lat"],
           driverDetails["Lon"],
            doc.data()["Lat"],
            doc.data()["Lon"]
      );
      console.log("distance: "+ distance);
 
      if(distance <= 1.0){
        console.log("In range ! distance: "+ distance);
        await admin.firestore().collection("ResidentCredentials").doc(doc.data()['UserId']).collection("Notifications").get().then(async (querysnapshot1) => {
           await querysnapshot1.forEach(async (doc2) => {
             console.log("TImeeeeeeeeeeeeeeeeeeeeeeee : " + doc2.data()['timestamp']);
        //     let currentTime = new Date().getTime();
        //     date = new Date(doc2.data()["timestamp"].seconds * 1000).getTime();

        //     var diff = currentTime - date;
        //     console.log("date : " +date +"\nDiff time: "+diff);
        //     if(diff >= 60){
              await admin.firestore().collection("ResidentCredentials").doc(doc.data()['UserId']).collection("Notifications").add(
                {
                    "message":"Dump truck is arriving.",
                    "type": "alert",
                    "timestamp" : admin.firestore.FieldValue.serverTimestamp()
                })
        //     }
          });
        });

       
    }
      }) 
   }
 );
  });

  


  function calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = math.cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 + c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
            
    return 12742 * math.asin(math.sqrt(a));
} 

exports.onCreateNotification = functions.firestore
  .document("/ResidentCredentials/{userId}/Notifications/{notificationItems}")
  .onCreate(async (snapshot, context) => {
    const userId = context.params.userId;
    const userRef = admin.firestore().doc(`ResidentCredentials/${userId}`);
    const doc = await userRef.get();

    let androidToken;
    let data = doc.data();
    if (data) {
      androidToken = data.AndroidToken;
    }
    // const postusername = doc2.data().userName;
    const createNotificationItems = snapshot.data();
    const postUserRef = admin
      .firestore()
      .doc(`ResidentCredentials/${createNotificationItems.uid}`);
    const doc2 = await postUserRef.get();

    if (androidToken) {
      await sendNotification(androidToken, createNotificationItems);
    } else {
      console.log("No token for user, Not able to send notification");
    }

    async function sendNotification(
      androidTokenArg,
      notificationItemsArg
    ) {
      let body;
      let title;
      if (notificationItemsArg.type) {
        switch (notificationItemsArg.type) {
            case "alert":
              title = "Dump App";
              body = `${notificationItemsArg.message}`;
              break;
    
            default:
              break;
          }
            
      }
      const message = {
        notification: { title, body },
        token: androidTokenArg,
        data: { recipient: userId, click_action: "FLUTTER_NOTIFICATION_CLICK" , view: "notificationView"},
      };

      admin
        .messaging()
        .send(message)
        .then((response) => {
          console.log("Successfully sent message", response);
        })
        .catch((error) => {
          console.log("Error sending message", error);
        });
    }
  });