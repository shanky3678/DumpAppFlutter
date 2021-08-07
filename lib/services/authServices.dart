import 'package:dump/Model/UserData.dart';
import 'package:dump/locator.dart';
import 'package:dump/router/pathnames.dart';
import 'package:dump/screens/Constant/const.dart';
import 'package:dump/services/firebaseServices.dart';
import 'package:dump/services/navigationService.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseService _firebaseService = locator<FirebaseService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseAuth get authservice => _auth;

  UserData _currentUser;
  UserData get currentUser => _currentUser;

  String _verificationId = "", _verificationCode = "";

  //phoneVerification method sent a OTP to number to verify the user.
  phoneVerification(String number) async {
    await authservice.verifyPhoneNumber(
        timeout: Duration(seconds: 60),
        phoneNumber: number,
        verificationCompleted: (credential) async {
          await _auth.signInWithCredential(credential).then((value) async {
            if (value.user != null) {
              print("user logged in");
            }
          });
        },
        verificationFailed: (result) {
          print("Printing verification Failed : $result");
        },
        codeSent: (String verificationId, resendToken) {
          _verificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (verificationId) {
          _verificationCode = verificationId;
        });
    return [
      {"verificationId": _verificationId, "verificationCode": _verificationCode}
    ];
  }

  //signing in with the user credentials
  Future signInWithcredential(
    enteredOTP,
    type,
    phoneNumber,
  ) async {
    var status;
    var result;
    PhoneAuthCredential _phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: enteredOTP);
    await authservice
        .signInWithCredential(_phoneAuthCredential)
        .then((value) async => {
              await _populateCurrentUser(value.user),
              if (type == Driver)
                {
                  result = await checkDetails(phoneNumber, type),
                  if (result)
                    {
                      status = true,
                      _navigationService.popUntil(),
                      await _navigationService.navigateTo(DriverHomeViewRoute)
                    }
                  else
                    {
                      status = true,
                      await _navigationService
                          .popUntilAndNavigateTo(DetailsViewRoute, arguments: {
                        "phoneNumber": phoneNumber,
                        "type": type,
                        "userId": value.user.uid
                      })
                    }
                }
              else if (type == Resident)
                {
                  result = await checkDetails(phoneNumber, type),
                  if (result)
                    {
                      status = true,
                      _navigationService.popUntil(),
                      await _navigationService.navigateTo(ResidentHomeViewRoute)
                    }
                  else
                    {
                      status = true,
                      await _navigationService
                          .popUntilAndNavigateTo(DetailsViewRoute, arguments: {
                        "phoneNumber": phoneNumber,
                        "type": type,
                        "userId": value.user.uid
                      })
                    }
                }
            })
        .catchError(() {
      status = false;
    });
    return status;
  }

  // signup method.
  Future<bool> checkDetails(String phoneNumber, String type) async {
    var result = await _firebaseService.checkDetails(phoneNumber, type);
    return result;
  }

  //method to check user is already logged in or not
  Future<bool> isLoggedIn() async {
    var user = _auth.currentUser;
    print("is Logged In check : $user");
    if (user?.uid != null) {
      print(" is log $user");
      if (user != null) {
        var result = await _populateCurrentUser(user);
        if (result == true) {
          return true;
        } else
          return false;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> _populateCurrentUser(User user) async {
    if (user != null) {
      try {
        _currentUser = await _firebaseService.getUser(user.uid);
        return true;
      } catch (e) {
        return false;
      }
    } else {
      return false;
    }
  }

  login() async {
    try {} catch (e) {}
  }

  logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
