class GetSampleApi {
  // variable to store value of 'hid' from API response
  String? hid;
  //// variable to store value of 'uid' from API response
  String? uid;
  // variable to store value of 'task_hid' from API response
  String? task_hid;
  // variable to store value of 'task_uid' from API response
  String? task_uid;
  // variable to store value of 'time_created' from API response
  String? time_created;
  // variable to store value of 'date_created' from API response
  String? date_created;
  String? task_score;
  String? classification;
  //String? uid;
  //String? questionsetId;

  GetSampleApi({this.hid,this.uid}); // constructor with parameters

// named constructor 'fromJson' which takes a Map object as argument to create an object of 'GetSampleApi'
  GetSampleApi.fromJson(Map<String, dynamic> json) {
    task_hid = json['hid'];
    task_uid = json['uid']; //this is unique foe every test
    date_created = json['created'].split("T")[0];
    time_created = json['created'].split("T")[1].substring(0, 9);
    task_score = json['task_score'].toString();
    classification = json['classification'].toString();
    hid = json['task_snapshot']['hid'];
    uid= json['task_snapshot']['uid'];

    // uid = json['uid'];
    // questionsetId = json['questionset_id'];
  }

  // method named 'toJson' which converts the object of 'GetSampleApi' to a Map object

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hid'] = this.hid;
    //data['uid'] = this.uid;
    //data['questionset_id'] = this.questionsetId;
    return data;
  }
}