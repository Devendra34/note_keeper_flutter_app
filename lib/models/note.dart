import 'package:note_keeper/constants/constants.dart';
class Note{
  int _id;
  String _title;
  String _description;
  String _date;
  int _priority;
  String _password;

  Note(this._title, this._date, this._priority, [this._description]);

  Note.withId(this._id, this._title, this._date, this._priority, [this._description]);

  int get priority => _priority;

  String get date => _date;

  String get description => _description;

  String get title => _title;

  int get id => _id;

  String get password => _password;

  set priority(int newPriority) {
    _priority = newPriority;
  }

  set date(String newDate) {
    _date = newDate;
  }

  set description(String newDescription) {
    _description = newDescription;
  }

  set title(String newTitle) {
    _title = newTitle;
  }

  set password(String newPassword){
    _password = newPassword;
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    if(_id != null){
      map[Constants.ID_KEY] = _id;
    }
    map[Constants.TITLE_KEY] = _title;
    map[Constants.DESCRIPTION_KEY] = _description;
    map[Constants.DATE_KEY] = _date;
    map[Constants.PRIORITY_KEY] = _priority;
    map[Constants.PASSWORD_KEY] = _password;
    return map;
  }

  Note.fromMapObject(Map<String, dynamic> map){
    this._id = map[Constants.ID_KEY];
    this._title = map[Constants.TITLE_KEY];
    this._description = map[Constants.DESCRIPTION_KEY];
    this._date = map[Constants.DATE_KEY];
    this._priority = map[Constants.PRIORITY_KEY];
    this._password = map[Constants.PASSWORD_KEY];
  }
}