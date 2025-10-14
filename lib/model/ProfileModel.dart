class ProfileModel {
  String? message;
  Employee? employee;

  ProfileModel({this.message, this.employee});

  ProfileModel.fromJson(Map<String, dynamic> json) {
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
  String? phoneno;
  String? role;
  List<String>? warehouses;
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
        this.warehouses,
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
    phoneno = (json['phoneno']??"").toString();
    role = json['role'];
    warehouses = json['warehouses'].cast<String>();
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
    data['warehouses'] = this.warehouses;
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
