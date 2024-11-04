import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
    String? responseCode;
    String? addr;
    String? email;
    String? fullName;
    String? isFingerLogin;
    String? isNc;
    String? loaiNnt;
    String? maCqt;
    String? tel;
    String? token;
    String? userName;
    String? versionAppMobile;

    LoginResponse({
        this.responseCode,
        this.addr,
        this.email,
        this.fullName,
        this.isFingerLogin,
        this.isNc,
        this.loaiNnt,
        this.maCqt,
        this.tel,
        this.token,
        this.userName,
        this.versionAppMobile,
    });

    factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        responseCode: json["responseCode"],
        addr: json["addr"],
        email: json["email"],
        fullName: json["fullName"],
        isFingerLogin: json["isFingerLogin"],
        isNc: json["isNC"],
        loaiNnt: json["loaiNNT"],
        maCqt: json["maCqt"],
        tel: json["tel"],
        token: json["token"],
        userName: json["userName"],
        versionAppMobile: json["versionAppMobile"],
    );

    Map<String, dynamic> toJson() => {
        "responseCode": responseCode,
        "addr": addr,
        "email": email,
        "fullName": fullName,
        "isFingerLogin": isFingerLogin,
        "isNC": isNc,
        "loaiNNT": loaiNnt,
        "maCqt": maCqt,
        "tel": tel,
        "token": token,
        "userName": userName,
        "versionAppMobile": versionAppMobile,
    };
}
