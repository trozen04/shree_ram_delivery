class TaskModel {
  String? updatestatus;
  Driverid? driverid;
  Orderid? orderid;
  String? createdAt;
  List<Product>? products;
  String? sId;

  bool? isAmountCollected;
  num? collectAmount;
  num? remainingAmount;
  bool? start;

  TaskModel({
    this.updatestatus,
    this.driverid,
    this.orderid,
    this.createdAt,
    this.products,
    this.sId,
    this.isAmountCollected,
    this.collectAmount,
    this.start,
    this.remainingAmount
  });

  TaskModel.fromJson(Map<String, dynamic> json) {
    updatestatus = json['updatestatus'];
    driverid = json['driverid'] != null
        ? Driverid.fromJson(json['driverid'])
        : null;
    orderid = json['Orderid'] != null
        ? Orderid.fromJson(json['Orderid'])
        : null;
    createdAt = json['createdAt'];
    if (json['products'] != null) {
      products = <Product>[];
      json['products'].forEach((v) {
        products!.add(Product.fromJson(v));
      });
    }
    sId = json['_id'];
    isAmountCollected = json['isAmountCollected'];
    collectAmount = json['collectAmount'];
    remainingAmount = json['remainingAmount'];
    start = json['start'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['updatestatus'] = updatestatus;
    if (driverid != null) data['driverid'] = driverid!.toJson();
    if (orderid != null) data['Orderid'] = orderid!.toJson();
    data['createdAt'] = createdAt;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    data['_id'] = sId;
    data['isAmountCollected'] = isAmountCollected;
    data['collectAmount'] = collectAmount;
    data['remainingAmount'] = remainingAmount;
    data['start'] = start;
    return data;
  }
}

// New Product class to handle the products array
class Product {
  String? productid;
  num? quantity;
  num? leftquantity;
  num? orderedQty;
  String? sId;

  Product({
    this.productid,
    this.quantity,
    this.leftquantity,
    this.orderedQty,
    this.sId,
  });

  Product.fromJson(Map<String, dynamic> json) {
    productid = json['productid'];
    quantity = json['quantity'];
    leftquantity = json['leftquantity'];
    orderedQty = json['orderedQty'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productid'] = productid;
    data['quantity'] = quantity;
    data['leftquantity'] = leftquantity;
    data['orderedQty'] = orderedQty;
    data['_id'] = sId;
    return data;
  }
}


class Driverid {
  String? sId;

  Driverid({this.sId});

  Driverid.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    return data;
  }
}

class Orderid {
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
  int? iV;
  String? godownInchargeId;
  WarehouseId? warehouseId;

  Orderid(
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
        this.warehouseId});

  Orderid.fromJson(Map<String, dynamic> json) {
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
    payLaterDate = json['payLaterDate']??"";
    driverId = json['driverId'].cast<String>();
    redeempoints = json['redeempoints'];
    status = json['status'];
    orderDate = json['orderDate'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    godownInchargeId = json['godownInchargeId'];
    warehouseId = json['warehouseId'] != null
        ? new WarehouseId.fromJson(json['warehouseId'])
        : null;
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
    if (this.warehouseId != null) {
      data['warehouseId'] = this.warehouseId!.toJson();
    }
    return data;
  }
}


class UserId {
  String? sId;
  String? name;
  String? photo;
  String? email;
  int? redeempoints;
  String? mobileno;
  String? password;
  String? securityQuestion;
  String? answer;
  String? createdAt;
  String? updatedAt;
  int? iV;

  UserId(
      {this.sId,
        this.name,
        this.photo,
        this.email,
        this.redeempoints,
        this.mobileno,
        this.password,
        this.securityQuestion,
        this.answer,
        this.createdAt,
        this.updatedAt,
        this.iV});

  UserId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    photo = json['photo'];
    email = json['email'];
    redeempoints = json['redeempoints'];
    mobileno = json['mobileno'];
    password = json['password'];
    securityQuestion = json['securityQuestion'];
    answer = json['answer'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['photo'] = this.photo;
    data['email'] = this.email;
    data['redeempoints'] = this.redeempoints;
    data['mobileno'] = this.mobileno;
    data['password'] = this.password;
    data['securityQuestion'] = this.securityQuestion;
    data['answer'] = this.answer;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Items {
  ProductId? productId;
  num? quantity;
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
  List<String>? productimage;
  String? id;

  ProductId({this.sId, this.productname, this.productimage, this.id});

  ProductId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    productname = json['productname'];
    productimage = json['productimage'].cast<String>();
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['productname'] = this.productname;
    data['productimage'] = this.productimage;
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
  int? pin;
  String? saveas;
  String? createdAt;
  String? updatedAt;
  int? iV;

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

class WarehouseId {
  String? sId;
  String? warehousename;
  String? address;
  String? city;
  String? areaname;
  String? status;
  String? lastupdated;
  String? createdAt;
  String? updatedAt;
  int? iV;

  WarehouseId(
      {this.sId,
        this.warehousename,
        this.address,
        this.city,
        this.areaname,
        this.status,
        this.lastupdated,
        this.createdAt,
        this.updatedAt,
        this.iV});

  WarehouseId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    warehousename = json['warehousename'];
    address = json['address'];
    city = json['city'];
    areaname = json['areaname'];
    status = json['status'];
    lastupdated = json['lastupdated'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['warehousename'] = this.warehousename;
    data['address'] = this.address;
    data['city'] = this.city;
    data['areaname'] = this.areaname;
    data['status'] = this.status;
    data['lastupdated'] = this.lastupdated;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
