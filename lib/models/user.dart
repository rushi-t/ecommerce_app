class User {
  String uid;
  String name;
  String phone;
  String email;
  String address;
  bool enabled;

  User(String uid, {this.name, this.phone, this.email, this.address, this.enabled = true}) : this.uid = uid;

  Map<String, dynamic> toMap() {
    return {'uid': this.uid, 'name': this.name, 'phone': this.phone, 'email': this.email, 'enabled': this.enabled, 'address': this.address};
  }

  User.fromFireBaseSnapshot(Map snapshot)
      : uid = snapshot['uid'],
        name = snapshot['name'],
        phone = snapshot['phone'],
        email = snapshot['email'],
        enabled = snapshot['enabled'] != null ? snapshot['enabled'] : false,
        address = snapshot['address'];

  bool canOrder(){
    if(!enabled || phone == null || address == null ){
      return false;
    }
    return true;
  }
}
