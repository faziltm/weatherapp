class Solution{
  List<String> uniquePhoneNumbers(){
    List<String> phoneNumbersWC=new List<String>(); //Initialize the list without country code
    List<String> phoneNumbersS=new List<String>(); //Initialize the list for removing spaces and - symbol
    List<String> phoneNumbersLast=new List<String>();//Initialize the remove duplication
    
    List<String> phoneNumbers = 
    ['6789998212',
    '+91-6789998213',
    '+91-6789998212',
    '916789998212',
    '91 678999 8212', 
    '67899-98214'];

    phoneNumbersWC=removeCountryCode(phoneNumbers);
    phoneNumbersS=removeSpaces(phoneNumbersWC);
    phoneNumbersLast=phoneNumbersS.toSet().toList();

    print(phoneNumbersLast);

    return phoneNumbersLast;
  }


  List<String> removeCountryCode(List<String> phoneNumbers){

    List<String> list=new List<String>();
      for(int i=0;i<phoneNumbers.length;i++){
          var rx = new RegExp(r"(\+91-)|(\+91 )|(\91)");
          var match = rx.firstMatch(phoneNumbers[i]);
          var result = "";
            if (match != null) {
                if (match.group(1) != null) {
                  result =  match.group(1);
                  //remove "+91-"
                  list.add(phoneNumbers[i].replaceAll(result,""));
                } else if(match.group(2) != null){
                  result =  match.group(2);
                  //remove "+91 "
                  list.add(phoneNumbers[i].replaceAll(result,""));
                } else if(match.group(3) != null){
                  result = match.group(3);
                  //remove "+91"
                  list.add(phoneNumbers[i].replaceAll(result,""));
                }
            } else{
              list.add(phoneNumbers[i]);
            }
      
        }

    return list;

  }


    List<String> removeSpaces(List<String> phoneNumbers){
       List<String> list=new List<String>();

       for(int i=0;i<phoneNumbers.length;i++){
       
       //removing spaces and "-" and adding to new list
          list.add(phoneNumbers[i].replaceAll(" ", "").replaceAll("-", ""));


       }

       return list;
    }
}


