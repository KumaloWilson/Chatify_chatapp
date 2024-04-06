String? emailValidate(String? value) {
  if (value == null || value.isEmpty) {
    return 'This field is required';
  }
  if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(value)) {
    return 'Invalid Email format';
  }
  return null;
}
String? passwordValidate(String? value) {
  if (value == null || value.isEmpty) {
    return 'This field is required';
  }
  if (!RegExp(r'(?=.*[A-Za-z\d])[A-Za-z\d]*$'

).hasMatch(value)) {
    return 'Invalid Password Format';
  }
  if(value.length<6){
    return  "Password must be at least 6 characters long.";
  }
  return null;
}
String? nameValidate(String? value) {
  if (value == null || value.isEmpty) {
    return 'This field is required';
  }
  if (!RegExp(r'^[a-zA-Z_]+$').hasMatch(value)) {
    return 'Invalid Name format';
  }
  return null;
}