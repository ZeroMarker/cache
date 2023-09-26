Class DHCENS.BC.Model.GetPatListRt Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "GetPatList";

/// 卡值
Property CardValue As %String(MAXLEN = 32767);

/// 卡类型
Property CardTypes As %String(MAXLEN = 32767);

/// 开始日期
Property StartDate As %String(MAXLEN = 32767);

/// 结束日期
Property EndDate As %String(MAXLEN = 32767);

/// 接受科室
Property ExeLoc As %String(MAXLEN = 32767);

/// 状态
Property Status As %String(MAXLEN = 32767);

}
