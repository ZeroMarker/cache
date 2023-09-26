/// 财务结算时用的界面
Class web.DHCEntity.OPC.INSReport Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Property EndDate As %String(TRUNCATE = 1);

Property StDate As %String(TRUNCATE = 1);

}
