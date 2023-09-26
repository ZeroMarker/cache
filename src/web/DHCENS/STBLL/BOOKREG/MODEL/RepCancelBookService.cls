Class web.DHCENS.STBLL.BOOKREG.MODEL.RepCancelBookService Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "RepCancelBookService";

/// 交易流水号
Property TransactionId As %Library.String;

/// 预约单号
Property OrderCode As %Library.String;

}
