Class web.DHCEntity.CI.Response Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// /B超返回的Xml
Property BCXmlInfo As %String(TRUNCATE = 1);

Property ErrorMsg As %String(TRUNCATE = 1);

/// /Lis返回的Xml
Property LISXmlInfo As %String(TRUNCATE = 1);

Property ResultCode As %String(TRUNCATE = 1);

/// / PACS返回的XML
Property PACSXmlInfo As %String(TRUNCATE = 1);

/// 检验标本号码
Property SpecimenCode As %String(TRUNCATE = 1);

Property TubeAmount As web.DHCEntity.CI.Response.TubeAmount;

}
