// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:collection/collection.dart';

class Birthday {
  final String id;
  final String createdBy;
  final String createdDate;
  final String date;
  final String time;
  final String location;
  final String contact;
  final String childsName;
  final String turningAge;
  final String email;
  final String package;
  final String price;
  final List<String> entertainers;
  final String saleCollector;
  final bool finalized = false;
  final String note;

  Birthday({
    required this.id,
    required this.createdBy,
    required this.createdDate,
    required this.date,
    required this.time,
    required this.location,
    required this.contact,
    required this.childsName,
    required this.turningAge,
    required this.email,
    required this.package,
    required this.price,
    required this.entertainers,
    required this.saleCollector,
    required this.note,
  });

  Birthday copyWith({
    String? id,
    String? createdBy,
    String? createdDate,
    String? date,
    String? time,
    String? location,
    String? contact,
    String? childsName,
    String? turningAge,
    String? email,
    String? package,
    String? price,
    List<String>? entertainers,
    String? saleCollector,
    String? note,
  }) {
    return Birthday(
      id: id ?? this.id,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
      date: date ?? this.date,
      time: time ?? this.time,
      location: location ?? this.location,
      contact: contact ?? this.contact,
      childsName: childsName ?? this.childsName,
      turningAge: turningAge ?? this.turningAge,
      email: email ?? this.email,
      package: package ?? this.package,
      price: price ?? this.price,
      entertainers: entertainers ?? this.entertainers,
      saleCollector: saleCollector ?? this.saleCollector,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'createdBy': createdBy,
      'createdDate': createdDate,
      'date': date,
      'time': time,
      'location': location,
      'contact': contact,
      'childsName': childsName,
      'turningAge': turningAge,
      'email': email,
      'package': package,
      'price': price,
      'entertainers': entertainers,
      'saleCollector': saleCollector,
      'note': note,
    };
  }

  factory Birthday.fromMap(Map<String, dynamic> map) {
    return Birthday(
      id: map['id'] as String,
      createdBy: map['createdBy'] as String,
      createdDate: map['createdDate'] as String,
      date: map['date'] as String,
      time: map['time'] as String,
      location: map['location'] as String,
      contact: map['contact'] as String,
      childsName: map['childsName'] as String,
      turningAge: map['turningAge'] as String,
      email: map['email'] as String,
      package: map['package'] as String,
      price: map['price'] as String,
      entertainers: List<String>.from((map['entertainers'] as List<String>)),
      saleCollector: map['saleCollector'] as String,
      note: map['note'] as String,
    );
  }

  @override
  String toString() {
    return 'Birthday(id: $id, createdBy: $createdBy, createdDate: $createdDate, date: $date, time: $time, location: $location, contact: $contact, childsName: $childsName, turningAge: $turningAge, email: $email, package: $package, price: $price, entertainers: $entertainers, saleCollector: $saleCollector, note: $note)';
  }

  @override
  bool operator ==(covariant Birthday other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.id == id &&
        other.createdBy == createdBy &&
        other.createdDate == createdDate &&
        other.date == date &&
        other.time == time &&
        other.location == location &&
        other.contact == contact &&
        other.childsName == childsName &&
        other.turningAge == turningAge &&
        other.email == email &&
        other.package == package &&
        other.price == price &&
        listEquals(other.entertainers, entertainers) &&
        other.saleCollector == saleCollector &&
        other.note == note;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        createdBy.hashCode ^
        createdDate.hashCode ^
        date.hashCode ^
        time.hashCode ^
        location.hashCode ^
        contact.hashCode ^
        childsName.hashCode ^
        turningAge.hashCode ^
        email.hashCode ^
        package.hashCode ^
        price.hashCode ^
        entertainers.hashCode ^
        saleCollector.hashCode ^
        note.hashCode;
  }
}
