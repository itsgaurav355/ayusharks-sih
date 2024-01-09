import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  //keys
  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userTypeKey = "USETYPEKEY";
  static String userTypeValue = "USERTYPEVALUE";
  static String imageUrl = "STATICIMAGEURL";

  //saving the data to SF
  static Future<bool> saveUserLoggedInStatus(
      bool isUserLoggedIn, bool isUserType) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    await sf.setBool(userLoggedInKey, isUserLoggedIn);
    return sf.setBool(userTypeKey, isUserType);
  }

  static Future<bool> saveUserEmailSF(String userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, userEmail);
  }

  static Future<bool> saveUserImageSF(String userImage) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(imageUrl, userImage);
  }

  static Future<bool> saveUserTypeSF(String userType) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userTypeValue, userType);
  }

  static Future<bool> saveUserNameSF(String userName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, userName);
  }
  //getting the data from SF

  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();

    return sf.getBool(userLoggedInKey);
  }

  static Future<String?> getUserEmailFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();

    return sf.getString(userEmailKey);
  }

  static Future<String?> getUserImageFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();

    return sf.getString(imageUrl);
  }

  static Future<String?> getUserNameFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();

    return sf.getString(userNameKey);
  }

  static Future<String?> getUserTypeFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();

    return sf.getString(userTypeValue);
  }
}
