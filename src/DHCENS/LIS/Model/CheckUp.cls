Class DHCENS.LIS.Model.CheckUp Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "CheckUp";

/// 检验号
Property LabNo As %String;

/// 医嘱号
Property Rowid As %String;

/// 是否计费
Property BilledFlag As %String;

/// 执行者
Property ExeUser As %String;

/// 接收日期
Property AcceptDate As %String;

/// 接收时间
Property AcceptTime As %String;

}
