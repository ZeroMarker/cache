Class DHCENS.LIS.Model.Refuse Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Refuse";

/// 检验号
Property LabNo As %String;

/// 医嘱号
Property Rowid As %String;

/// 拒绝原因
Property RefuseReason As %String;

/// 执行者
Property ExeUser As %String;

}
