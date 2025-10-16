class DailyAssignedOrderModel {
  Location? location;
  String? sId;
  UserId? userId;
  String? companyId;
  List<Items>? items;
  num? deliverycharge;
  num? subtotal;
  num? totalDiscount;
  num? totalLabourCharge;
  num? grandTotal;
  Deliveryaddress? deliveryaddress;
  String? paymentmethod;
  String? paymentType;
  String? payLaterDate;
  List<String>? driverId;
  num? redeempoints;
  String? status;
  String? orderDate;
  String? createdAt;
  String? updatedAt;
  num? iV;
  String? godownInchargeId;
  String? warehouseId;
  String? inchargeStatus;

  DailyAssignedOrderModel(
      {this.location,
        this.sId,
        this.userId,
        this.companyId,
        this.items,
        this.deliverycharge,
        this.subtotal,
        this.totalDiscount,
        this.totalLabourCharge,
        this.grandTotal,
        this.deliveryaddress,
        this.paymentmethod,
        this.paymentType,
        this.payLaterDate,
        this.driverId,
        this.redeempoints,
        this.status,
        this.orderDate,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.godownInchargeId,
        this.warehouseId,
        this.inchargeStatus
      });

  DailyAssignedOrderModel.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    sId = json['_id'];
    userId =
    json['UserId'] != null ? new UserId.fromJson(json['UserId']) : null;
    companyId = json['CompanyId'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    deliverycharge = json['deliverycharge'];
    subtotal = json['subtotal'];
    totalDiscount = json['totalDiscount'];
    totalLabourCharge = json['totalLabourCharge'];
    grandTotal = json['grandTotal'];
    deliveryaddress = json['deliveryaddress'] != null
        ? new Deliveryaddress.fromJson(json['deliveryaddress'])
        : null;
    paymentmethod = json['paymentmethod'];
    paymentType = json['paymentType'];
    payLaterDate = json['payLaterDate'];
    driverId = json['driverId'].cast<String>();
    redeempoints = json['redeempoints'];
    status = json['status'];
    orderDate = json['orderDate'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    godownInchargeId = json['godownInchargeId'];
    warehouseId = json['warehouseId'];
    inchargeStatus = json['inchargeStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['_id'] = this.sId;
    if (this.userId != null) {
      data['UserId'] = this.userId!.toJson();
    }
    data['CompanyId'] = this.companyId;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['deliverycharge'] = this.deliverycharge;
    data['subtotal'] = this.subtotal;
    data['totalDiscount'] = this.totalDiscount;
    data['totalLabourCharge'] = this.totalLabourCharge;
    data['grandTotal'] = this.grandTotal;
    if (this.deliveryaddress != null) {
      data['deliveryaddress'] = this.deliveryaddress!.toJson();
    }
    data['paymentmethod'] = this.paymentmethod;
    data['paymentType'] = this.paymentType;
    data['payLaterDate'] = this.payLaterDate;
    data['driverId'] = this.driverId;
    data['redeempoints'] = this.redeempoints;
    data['status'] = this.status;
    data['orderDate'] = this.orderDate;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['godownInchargeId'] = this.godownInchargeId;
    data['warehouseId'] = this.warehouseId;
    data['inchargeStatus'] = this.inchargeStatus;
    return data;
  }
}

class UserId {
  String? sId;
  String? name;
  String? email;
  String? mobileno;

  UserId({this.sId, this.name, this.email, this.mobileno});

  UserId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    mobileno = json['mobileno'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobileno'] = this.mobileno;
    return data;
  }
}

class Items {
  ProductId? productId;
  int? quantity;
  num? pricePerUnit;
  num? discountApplied;
  num? totalPrice;
  String? sId;

  Items(
      {this.productId,
        this.quantity,
        this.pricePerUnit,
        this.discountApplied,
        this.totalPrice,
        this.sId});

  Items.fromJson(Map<String, dynamic> json) {
    productId = json['productId'] != null
        ? new ProductId.fromJson(json['productId'])
        : null;
    quantity = json['quantity'];
    pricePerUnit = json['pricePerUnit'];
    discountApplied = json['discountApplied'];
    totalPrice = json['totalPrice'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.productId != null) {
      data['productId'] = this.productId!.toJson();
    }
    data['quantity'] = this.quantity;
    data['pricePerUnit'] = this.pricePerUnit;
    data['discountApplied'] = this.discountApplied;
    data['totalPrice'] = this.totalPrice;
    data['_id'] = this.sId;
    return data;
  }
}

class ProductId {
  String? sId;
  String? productname;
  String? brand;
  List<String>? productimage;
  String? description;
  String? id;

  ProductId(
      {this.sId,
        this.productname,
        this.brand,
        this.productimage,
        this.description,
        this.id});

  ProductId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    productname = json['productname'];
    brand = json['brand'];
    productimage = json['productimage'].cast<String>();
    description = json['description'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['productname'] = this.productname;
    data['brand'] = this.brand;
    data['productimage'] = this.productimage;
    data['description'] = this.description;
    data['id'] = this.id;
    return data;
  }
}

class Deliveryaddress {
  Location? location;
  String? sId;
  String? user;
  String? company;
  String? addressline;
  String? state;
  String? city;
  String? country;
  num? pin;
  String? saveas;
  String? createdAt;
  String? updatedAt;
  num? iV;

  Deliveryaddress(
      {this.location,
        this.sId,
        this.user,
        this.company,
        this.addressline,
        this.state,
        this.city,
        this.country,
        this.pin,
        this.saveas,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Deliveryaddress.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    sId = json['_id'];
    user = json['user'];
    company = json['company'];
    addressline = json['addressline'];
    state = json['state'];
    city = json['city'];
    country = json['country'];
    pin = json['pin'];
    saveas = json['saveas'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['_id'] = this.sId;
    data['user'] = this.user;
    data['company'] = this.company;
    data['addressline'] = this.addressline;
    data['state'] = this.state;
    data['city'] = this.city;
    data['country'] = this.country;
    data['pin'] = this.pin;
    data['saveas'] = this.saveas;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Location {
  String? type;
  List<double>? coordinates;

  Location({this.type, this.coordinates});

  Location.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['coordinates'] = this.coordinates;
    return data;
  }
}
