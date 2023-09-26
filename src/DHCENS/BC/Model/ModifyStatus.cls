Class DHCENS.BC.Model.ModifyStatus Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "ModifyStauts";

/// 医嘱Rowid
Property Rowid As %String;

/// 医嘱状态
Property Status As %String;

/// 执行者
Property ExeUser As %String;

}
