Class dhcinterface.PatRegisteredMsg Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Response";

Property ResultCode As %String(TRUNCATE = 1);

Property ErrorMsg As %String(TRUNCATE = 1);

Property PatRegisteredDatas As list Of PatRegisteredItem(XMLNAME = "RegItems");

}
