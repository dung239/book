class Validator {
  static bool isValidUser(String user) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(user);
  }

  static bool isValidPass(String pass) {
    return pass.length >= 6 && pass != null;
  }

  static bool isValidPhone(String phone) {
    return RegExp(r"(0)(3|5|7|8|9)+([0-9]{8})").hasMatch(phone);
  }
}
