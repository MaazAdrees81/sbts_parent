class CredentialsModel {
  CredentialsModel({required this.email, required this.saveForLater, required this.pass});

  late final String email;
  late final String pass;
  late final bool saveForLater;

  CredentialsModel.fromJson(Map<String, dynamic> json) {
    email = json["email"];
    pass = json["pass"];
    saveForLater = json["saveForLater"];
  }

  Map<String, dynamic> toJson() => {
        "email": email,
        "pass": pass,
        "saveForLater": saveForLater,
      };
}