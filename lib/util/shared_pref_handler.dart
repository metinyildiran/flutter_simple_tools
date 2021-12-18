import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static final SharedPrefHelper _prefInstance = SharedPrefHelper._init();
  late SharedPreferences _sharedPreferences;

  static SharedPrefHelper get prefInstance => _prefInstance;

  SharedPrefHelper._init(){
    SharedPreferences.getInstance().then((value) {
      _sharedPreferences = value;
    });
  }

  static Future createInstance() async {
    if (prefInstance._sharedPreferences == null) {
      prefInstance._sharedPreferences =
      await SharedPreferences.getInstance();
    }
    return;
  }
}