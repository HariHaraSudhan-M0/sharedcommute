// request_model.dart

class Request {
  final String requestId;
  final String user;
  final String phoneNumber;
  final String email;

  Request({
    required this.requestId,
    required this.user,
    required this.phoneNumber,
    required this.email,
  });

  factory Request.fromJson(String id, Map<String, dynamic> json) {
    return Request(
      requestId: id,
      user: json['UserName'],
      phoneNumber: json['phone'],
      email: json['email'],
    );
  }
}

List<Request> parseRequests(Map<String, dynamic> data) {
  List<Request> requests = [];
  data.forEach((key, value) {
    requests.add(Request.fromJson(key, Map<String, dynamic>.from(value)));
  });
  return requests;
}