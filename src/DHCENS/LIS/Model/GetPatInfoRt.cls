Class DHCENS.LIS.Model.GetPatInfoRt Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "GetPatInfo";

/// 卡号
Property CardNo As %String(MAXLEN = 32767);

/// 病人唯一号
Property RegisterNo As %String(MAXLEN = 32767);

}
