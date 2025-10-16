class ConstantString {


  ///Baseurl Server
  static final String base_Url = "https://shreeram.volvrit.org/api/";
  static final String image_base_Url = "https://shreeram.volvrit.org";

  ///Others
  // static final String base_Url = "https://bcfdba5389b3.ngrok-free.app/api/";

  // static final String base_Url = "http://192.168.1.37:3000/api/";
  // static final String image_base_Url = "http://192.168.1.37:3000";

  static final String login = "${base_Url}employee/loginemployee";
  static final String updateDetails = "${base_Url}employee/updateremaingdetails/";
  static final String getProfile = "${base_Url}employee/getdriverdetailsbyid/";
  static final String getTask = "${base_Url}driver/getalltodaysorderfordriver/";
  static final String startDelivery = "${base_Url}driver/startdelivery/";
  static final String getCollectedAmount = "${base_Url}driver/collectamount";
  static final String getOrderSummary = "${base_Url}driver/totalorderofdriver/";
  static final String updateStatus = "${base_Url}driver/updatetaskstatus/";
  static final String updateliveTracking = "${base_Url}order/updatestatus/";

  //InCharge
  static final String  getProductById = "${base_Url}product/getproductbyid/";
  static final String  getInChargeProfile= "${base_Url}employee/inchargedetails/";
  static final String  getTodayInchargeTask= "${base_Url}incharge/gettodayorderofincharge/";
  static final String  getLoadOrder= "${base_Url}incharge/loadorder/";
  static final String  getStock= "${base_Url}stock/getstock/";
  static final String  getUploadDetails= "${base_Url}incharge/updateuploadfile/";
  static final String  getTodaysSummary= "${base_Url}incharge/gettodayordersummary/";
  static final String  getDashboredData= "${base_Url}incharge/getallstatuswise/";
  static final String  getDateWiseHistory= "${base_Url}incharge/gettotalorderbyincharge/";
  static final String  gettodayordersummary= "${base_Url}incharge/gettodayordersummary/";
  static final String  inchargeordersummary= "${base_Url}incharge/inchargeordersummary/";
  static final String  getRemainingProductCount= "${base_Url}incharge/getinchargeorderloadstatus/";





  static const String get = 'GET';
  static const String post = 'POST';
  static const String patch = 'PATCH';
  static const String put = 'PUT';
  static const String delete = 'DELETE';

  //------------Shared Preference----------
  static final String loginKey = "LOGIN_DETAIL_KEY_CUS";
  static final String loginKey_2 = "LOGIN_DETAIL_KEY_Profile";
  static final String language = "LANGUAGE";
  static String location = "LOCATION";
}
