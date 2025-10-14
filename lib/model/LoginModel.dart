class LoginModel {
  String? message;
  Driver? driver;

  LoginModel({this.message, this.driver});

  LoginModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    driver =
    json['driver'] != null ? new Driver.fromJson(json['driver']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.driver != null) {
      data['driver'] = this.driver!.toJson();
    }
    return data;
  }
}

class Driver {
  String? token;
  String? id;
  String? email;
  int? phoneno;
  String? areaname;
  String? role;
  String? vehicle;

  Driver(
      {this.token,
        this.id,
        this.email,
        this.phoneno,
        this.areaname,
        this.vehicle,
        this.role});

  Driver.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    id = json['id'];
    email = json['email'];
    phoneno = json['phoneno'];
    areaname = json['areaname'];
    role = json['role'];
    vehicle = json['vehicle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['id'] = this.id;
    data['email'] = this.email;
    data['phoneno'] = this.phoneno;
    data['areaname'] = this.areaname;
    data['role'] = this.role;
    data['vehicle'] = this.vehicle;
    return data;
  }
}
