Class User.DHCInterfaceOperation Extends (%RegisteredObject, %XML.Adaptor, User.Abstract) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Operation";

/// 手术字典表Id
Property OperId As %String(TRUNCATE = 1);

Property OperName As %String(TRUNCATE = 1);

Property OperICDCode As %String(TRUNCATE = 1);

}
