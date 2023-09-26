Class web.DHCENS.STBLL.BOOKREG.MODEL.RepBody Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Body";

Property ResultCode As %Library.String(XMLNAME = "ResultCode");

Property ResultContent As %Library.String(XMLNAME = "ResultContent");

/// 预约信息
Property BookService As web.DHCENS.STBLL.BOOKREG.MODEL.RepBookService(XMLNAME = "");

/// 取消预约信息
Property CancelBookService As web.DHCENS.STBLL.BOOKREG.MODEL.RepCancelBookService(XMLNAME = "");

/// 患者基本信息
Property GetPatInfo As web.DHCENS.STBLL.BOOKREG.MODEL.RepGetPatInfo(XMLNAME = "");

}
