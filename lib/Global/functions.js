const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { DataSnapshot } = require("firebase-functions/v1/database");
const app = admin.initializeApp();

const database = app.database();

exports.checkIfRiderOrDriver = functions.https.onCall(async (data, context) => {
  const email = data.email;
  const role = data.role;
  try {
    const userAuth = app.auth();
    const user = await userAuth.getUserByEmail(email);
    const userDatabase = await database
      .ref(`/users/${user?.uid}`)
      .once("value");
    const driverDatabase = await database
      .ref(`/drivers/${user?.uid}`)
      .once("value");

    console.log("User Database = " + userDatabase.exists());
    console.log("Driver Database = " + driverDatabase.exists());
    if (user && userDatabase.exists() && userDatabase.val().email === email) {
      if (userDatabase.val().role === role) {
        return {
          allowed: true,
          email: email,
          message: "You are allowed to use this.",
          role: role,
        };
      }
      return {
        allowed: false,
        email: email,
        message: "You are not Allowed. to login as a " + role.toUpperCase()+ " Go to Driver's App for this",
        role: role,
      };
    } else if (
      user &&
      driverDatabase.exists() &&
      driverDatabase.val().driver.email === email
    ) {
      if (driverDatabase.val().driver.role === role) {
        return {
          allowed: true,
          email: email,
          message: "You are allowed to use this.",
          role: role,
        };
      }
      return {
        allowed: false,
        email: email,
        message: "You are not Allowed. to login as a " + role.toUpperCase()+ " Go to Rider's App for this",
        role: role,
      };
    } else {
      return {
        allowed: false,
        email: email,
        message: "You are not Allowed.",
        role: role,
      };
    }
  } catch (error) {
    console.log(error);
    return {
      allowed: false,
      message: error.message,
      email: email,
      role: "",
    };
  }
});

exports.checkIfPhoneExists = functions.https.onCall(async (data, context) => {
  const phone = data.phone;
  try {
    const userAuth = app.auth();
    const user = await userAuth.getUserByPhoneNumber(phone);
    const userDatabase = await database
      .ref(`/users/${user?.uid}`)
      .once("value");
    const driverDatabase = await database
      .ref(`/drivers/${user?.uid}`)
      .once("value");

    console.log("User Database = " + userDatabase.exists());
    console.log("Driver Database = " + driverDatabase.exists());
    if (user && userDatabase.exists() && userDatabase.val().phone === phone) {
      return {
        exists: true,
        phone: phone,
        message: "Phone number is already registered",
        role: "user",
      };
    } else if (
      user &&
      driverDatabase.exists() &&
      driverDatabase.val().driver.phone === phone
    ) {
      return {
        exists: true,
        phone: phone,
        message: "Phone number is already registered",
        role: "driver",
      };
    } else {
      return {
        exists: false,
        phone: phone,
        message: "",
        role: "",
      };
    }
  } catch (error) {
    console.log(error);
    return {
      exists: false,
      message: error.message,
      phone: phone,
      role: "",
    };
  }
});

exports.notifyDriver = functions.https.onCall(async (data, context) => {
  const id = data.uid;
  const rideId = data.rideId;

  console.log(id);
  console.log(rideId);
  try {
    const updateData = database.ref(`/drivers/${id}`);
    const snapshot = await database.ref(`/drivers/${id}`).once("value");
    const token = snapshot.val().driver.token;
    updateData.update({ newRide: rideId });
    console.log(token);

    const payload = {
      notification: {
        title: "Ride Request",
        body: "New Ride Request arrived go to the app to accept it",
      },
      data: {
        request_id: rideId,
      },
    };

    const options = {
      priority: "high",
    };
    await admin
      .messaging()
      .sendToDevice(token, payload, options)
      .then((response) => {
        console.log("Successfully sent message:", response);
        return { success: true };
      })
      .catch((error) => {
        return { error: error.code, success: false };
      });
  } catch (error) {
    console.log(error);
    return { error: error.message, success: false };
  }
});

exports.updateRideStatus = functions.database
  .ref("/ride_request/{rideId}/status/")
  .onUpdate(async (change, context) => {
    try {
      const rideId = context.params.rideId;
      const status = change.after.val();

      console.log(rideId);
      console.log(status);

      var rideDetails = await database
        .ref(`/ride_request/${rideId}`)
        .once("value");
      var userId = rideDetails.val().user.uid;
      var driverId = rideDetails.val().driverId;
      var token = rideDetails.val().user.token;

      console.log(userId);
      console.log(driverId);
      console.log(token);

      // Reference's to the database
      var driverRef;
      if (driverId != "waiting") {
        driverRef = database.ref(`/drivers/${driverId}`);
      }
      var userRef = database.ref(`/users/${userId}`);
      var ridesHistory = database.ref("/allrides");
      var rideRef = database.ref(`/ride_request/${rideId}`);

      var payload;

      const options = {
        priority: "high",
      };

      if (status === "RideStatus.accepted") {
        payload = {
          notification: {
            title: "Ride Accepted",
            body: "Driver is coming to your location",
          },
          data: {
            request_id: rideId,
          },
        };
        console.log("Ride Accepted");
        userRef.child("active").set(rideId);
      } else if (status === "RideStatus.arrived") {
        payload = {
          notification: {
            title: "Rider Arrived",
            body: "Driver is at your location",
          },
          data: {
            request_id: rideId,
          },
        };
        console.log("Rider Arrived");
      } else if (status === "RideStatus.started") {
        payload = {
          notification: {
            title: "Ride Started",
            body: "Your ride is started",
          },
          data: {
            request_id: rideId,
          },
        };
        console.log("Ride Started");
      } else if (status === "RideStatus.completed") {
        payload = {
          notification: {
            title: "You arrived",
            body: "Your have reached your destination",
          },
          data: {
            request_id: rideId,
            driver_id: driverId,
            rating: "yes",
          },
        };
        console.log("You arrived");
      } else if (status === "RideStatus.finished") {
        payload = {
          notification: {
            title: "How was your ride?",
            body: "Please rate your ride.",
          },
          data: {
            request_id: rideId,
            driver_id: driverId,
            rating: "yes",
          },
        };
        console.log("How was your ride?");
        userRef.child("active").remove();
        userRef.child("activeRide").remove();
        var rideInfo = rideDetails;
        rideRef.remove();
        userRef.child("trips").child(rideId).set(rideInfo.val());
        driverRef.child("history").child(rideId).set({
          rideId: rideId,
          rating: null,
          earn: rideInfo.val().price,
          start: rideInfo.val().startTime,
          end: rideInfo.val().endTime,
          user: rideInfo.val().user.displayName,
          userId: rideInfo.val().user.uid,
          pickUp: rideInfo.val().currentLocation.address,
          dropOff: rideInfo.val().destinationLocation.address,
        });
        ridesHistory.child(rideId).set(rideInfo.val());
      }

      await admin
        .messaging()
        .sendToDevice(token, payload, options)
        .then((response) => {
          console.log("Successfully sent message:", response);

          return {
            success: true,
            userId: userId,
            driverId: driverId,
            rideId: rideId,
            token: token,
            status: status,
          };
        })
        .catch((error) => {
          console.log(error);
          return {
            error: error.code,
            success: false,
            userId: userId,
            driverId: driverId,
            rideId: rideId,
            token: token,
            status: status,
          };
        });
    } catch (error) {
      console.log(error);
      return { error: error.code, success: false };
    }
  });

exports.updateDriverStatus = functions.https.onCall(async (data, context) => {
  const id = data.uid;
  const status = data.status;

  try {
    const updateData = database.ref(`/drivers/${id}`);
    updateData.update({ newRide: status });
    return { success: true, status: status, message: null };
  } catch (error) {
    console.log(error);
    return { message: error.message, success: false, status: status };
  }
});

exports.updateDriverRating = functions.https.onCall(async (data, context) => {
  const id = data.uid;
  const rideId = data.rideId;
  const rating = data.rating;
  var allRating = 0;
  var allRides = 0;

  try {
    const history = await database.ref(`/drivers/${id}/history`).once("value");
    history.forEach((ride) => {
      if (ride.child("rating").exists()) {
        console.log(ride.val());
        allRides++;
        allRating += ride.val().rating;
      }
    });

    const averageRating = allRating / allRides;
    console.log(averageRating);
    const updateData = database.ref(`/drivers/${id}/history/${rideId}`);
    updateData.update({ rating: rating });
    await database
      .ref(`/drivers/${id}`)
      .update({ averageRating: averageRating });

    return {
      success: true,
      status: rating,
      message: "Rating updated successfully",
    };
  } catch (error) {
    console.log(error);
    return {
      message: error.message,
      success: false,
      status: "Rating not updated",
    };
  }
});
