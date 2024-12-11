class ResponseModel {
  String status;
  String massage;
  dynamic data;
  dynamic error;
  ResponseModel(
      {required this.status, required this.massage, this.data, this.error});

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      status: json['status'],
      massage: json['message'],
      data: json['data'],
      error: json['error'],
    );
  }
}
