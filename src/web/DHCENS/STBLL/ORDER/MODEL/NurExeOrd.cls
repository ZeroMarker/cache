Class web.DHCENS.STBLL.ORDER.MODEL.NurExeOrd Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "NurExeOrd";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 执行医嘱明细ID
Property ExeOEORItemID As %Library.String(MAXLEN = 30, XMLNAME = "ExeOEORItemID");

/// 执行人医护人员Code
Property ExeOEORUserCode As %Library.String(MAXLEN = 30, XMLNAME = "ExeOEORUserCode");

/// 执行日期时间
Property ExeOEORDateTime As %Library.String(MAXLEN = 30, XMLNAME = "ExeOEORDateTime");

/// 要求执行日期时间
Property ExStDateTime As %Library.String(MAXLEN = 30, XMLNAME = "ExStDateTime");

}
