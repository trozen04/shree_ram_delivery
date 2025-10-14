class InChargeProfileModel {
  String? message;
  Employee? employee;

  InChargeProfileModel({this.message, this.employee});

  InChargeProfileModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    employee = json['employee'] != null
        ? new Employee.fromJson(json['employee'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.employee != null) {
      data['employee'] = this.employee!.toJson();
    }
    return data;
  }
}

class Employee {
  String? sId;
  int? slno;
  String? name;
  int? phoneno;
  String? role;
  // List<Null>? warehouses;
  String? email;
  String? areaname;
  String? password;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? vehicle;
  String? city;
  String? uploadadhar;
  String? uploadpan;
  String? uploadphoto;
  String? uploadrc;

  Employee(
      {this.sId,
        this.slno,
        this.name,
        this.phoneno,
        this.role,
        // this.warehouses,
        this.email,
        this.areaname,
        this.password,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.vehicle,
        this.city,
        this.uploadadhar,
        this.uploadpan,
        this.uploadphoto,
        this.uploadrc});

  Employee.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    slno = json['slno'];
    name = json['name'];
    phoneno = json['phoneno'];
    role = json['role'];
    // if (json['warehouses'] != null) {
    //   warehouses = <Null>[];
    //   json['warehouses'].forEach((v) {
    //     warehouses!.add(new Null.fromJson(v));
    //   });
    // }
    email = json['email'];
    areaname = json['areaname'];
    password = json['password'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    vehicle = json['vehicle'];
    city = json['city'];
    uploadadhar = json['uploadadhar'];
    uploadpan = json['uploadpan'];
    uploadphoto = json['uploadphoto'];
    uploadrc = json['uploadrc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['slno'] = this.slno;
    data['name'] = this.name;
    data['phoneno'] = this.phoneno;
    data['role'] = this.role;
    // if (this.warehouses != null) {
    //   data['warehouses'] = this.warehouses!.map((v) => v.toJson()).toList();
    // }
    data['email'] = this.email;
    data['areaname'] = this.areaname;
    data['password'] = this.password;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['vehicle'] = this.vehicle;
    data['city'] = this.city;
    data['uploadadhar'] = this.uploadadhar;
    data['uploadpan'] = this.uploadpan;
    data['uploadphoto'] = this.uploadphoto;
    data['uploadrc'] = this.uploadrc;
    return data;
  }
}
