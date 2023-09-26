/// 试管数量
Class web.DHCEntity.CI.Response.TubeAmount Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// 对应医嘱的RowID
Property ORIRowID As %String(TRUNCATE = 1);

Property Amount As %String(TRUNCATE = 1);

}
