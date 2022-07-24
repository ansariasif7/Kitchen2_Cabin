// for Building model to retreive data from firestore


class Sellers{
  String? sellerUID;
  String? sellerName;
  String? sellerAvatarUrl;
  String? sellerEmail;

  Sellers({
   this.sellerUID,
    this.sellerName,
    this.sellerEmail,
    this.sellerAvatarUrl,
  });

  Sellers.fromJson(Map<String,dynamic> json){

    sellerUID = json["sellerUID"];
    sellerName = json["sellerName"];
    sellerEmail = json["sellerEmail"];
    sellerAvatarUrl = json["sellerAvatarUrl"];


  }

  Map<String,dynamic> toJson()
  {
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data["sellerUID"] = this.sellerUID;
    data["sellerName"] = this.sellerName;
    data["sellerEmail"] = this.sellerEmail;
    data["sellerAvatarUrl"] = this.sellerAvatarUrl;
    return data;
  }


}