Class web.DHCEntity.CI.PaPatMas Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// 指令 迎合第三方接口
Property Instruction As %String(TRUNCATE = 1);

/// 接口类型
Property InterfaceType As %String(TRUNCATE = 1);

Property PAADMs As list Of PaAdm;

Property RowID As %String(TRUNCATE = 1, XMLNAME = "PMI");

}
