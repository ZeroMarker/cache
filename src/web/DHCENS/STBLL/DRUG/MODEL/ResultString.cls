Class web.DHCENS.STBLL.DRUG.MODEL.ResultString Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLNAME = "Response";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 响应码
Property ResultCode As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "ResultCode");

/// 响应信息
Property ResultContent As %String(MAXLEN = 32767, TRUNCATE = 1, XMLNAME = "ResultContent");

}
