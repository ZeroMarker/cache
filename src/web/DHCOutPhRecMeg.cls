Class web.DHCOutPhRecMeg Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

//Pharmacy 药房名称

Property Pharmacy As %String(TRUNCATE = 1);

//Date 调整日期 格式为：yyyy-MM-dd

Property Date As %String(TRUNCATE = 1);

//变化药品明细

Property PhInformation As list Of web.DHCOutPhRecMegSub(XMLITEMNAME = "");

}
