class HasDateTime {

  final String hasDateTime;
          //String 으로 날짜를 받는다
  HasDateTime({
    required this.hasDateTime
  });

  get gethasDateTime => DateTime.utc(
                            int.parse(hasDateTime.substring(0,4)),
                            int.parse(hasDateTime.substring(5,7)),
                            int.parse(hasDateTime.substring(8,10))
                            );
        //String으로 받은 날짜를 DateTime으로 변환 시켜준다
  @override
  String toString() {
    // TODO: implement toString
    return gethasDateTime.toString();
  }
}