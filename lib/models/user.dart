class User {
  final String uid;
  final String name;
  final String phone;
  final String email;
  final String address;
  final bool enabled;

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
}
