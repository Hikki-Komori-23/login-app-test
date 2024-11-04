import 'dart:convert';

Authentication authenticationFromJson(String str) => Authentication.fromJson(json.decode(str));

String authenticationToJson(Authentication data) => json.encode(data.toJson());

class Authentication {
    String? requestId;
    String? userName;
    String? passWord;
    String? otpNo;
    String? version;
    String? operatingSystem;
    String? token;
    String? deviceId;
    String? code;
    String? tokenPush;
    String? sodinhdanh;

    Authentication({
        this.requestId,
        this.userName,
        this.passWord,
        this.otpNo,
        this.version,
        this.operatingSystem,
        this.token,
        this.deviceId,
        this.code,
        this.tokenPush,
        this.sodinhdanh,
    });

    factory Authentication.fromJson(Map<String, dynamic> json) => Authentication(
        requestId: json["requestId"],
        userName: json["userName"],
        passWord: json["passWord"],
        otpNo: json["otpNo"],
        version: json["version"],
        operatingSystem: json["operatingSystem"],
        token: json["token"],
        deviceId: json["deviceId"],
        code: json["code"],
        tokenPush: json["tokenPush"],
        sodinhdanh: json["sodinhdanh"],
    );

    Map<String, dynamic> toJson() => {
        "requestId": requestId,
        "userName": userName,
        "passWord": passWord,
        "otpNo": otpNo,
        "version": version,
        "operatingSystem": operatingSystem,
        "token": token,
        "deviceId": deviceId,
        "code": code,
        "tokenPush": tokenPush,
        "sodinhdanh": sodinhdanh,
    };
}
