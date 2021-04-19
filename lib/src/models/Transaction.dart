class Transaction {
  String id;
  String hotel;
  String thumbnail;
  String guestName;
  String bookingDate;
  int room;
  int guest;
  String rating;

  Transaction(
      {this.id,
      this.hotel,
      this.thumbnail,
      this.guestName,
      this.bookingDate,
      this.room,
      this.guest,
      this.rating});

  Transaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hotel = json['hotel'];
    thumbnail = json['thumbnail'];
    guestName = json['guestName'];
    bookingDate = json['bookingDate'];
    room = json['room'];
    guest = json['guest'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['hotel'] = this.hotel;
    data['thumbnail'] = this.thumbnail;
    data['guestName'] = this.guestName;
    data['bookingDate'] = this.bookingDate;
    data['room'] = this.room;
    data['guest'] = this.guest;
    data['rating'] = this.rating;
    return data;
  }
}
