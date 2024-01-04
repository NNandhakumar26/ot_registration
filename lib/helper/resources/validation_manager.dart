class ValidationManager{

  static validateNonNullOrEmpty(value, fieldName){
    if(value == null || value.toString().isEmpty){
      return '$fieldName is required';
    }else{
      return null;
    }
  }

  static validateNonNull(String? value, String fieldName){
    if(value==null || value.isEmpty){
      return '$fieldName is required';
    }else{
      return null;
    }
  }

  static validateEmail(String? value){
    if(value==null || value.isEmpty){
      return 'Email Id is required';
    }else{
      final bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(value);

      if(!emailValid){
        return 'Enter a valid email address';
      }

      return null;
    }
  }

  static validatePhone(String? value){
    if(value==null || value.isEmpty){
      return 'Contact Number is required';
    }else if(value.length==10 || value.length==13){
      return null;
    }else{
      return 'Enter a valid contact number';
    }
  }

  static validateUrl(String? value){
    if(value==null || value.isEmpty){
      return 'Website is required';
    }else{
      final Uri? uri = Uri.tryParse(value);
      if (uri==null || !uri.hasAbsolutePath) {
          return 'Please enter valid url';
      }
      return null;
    }
  }

}