Class DHCExternalService.BillInterface.DHCEntity.PayList Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// ResultCode
Property ResultCode As %String(TRUNCATE = 1);

/// ErrorMsg
Property ResultContent As %String(TRUNCATE = 1);

Property PayListInfo As list Of DHCExternalService.BillInterface.DHCEntity.PayListInfo(XMLITEMNAME = "PayListInfo", XMLNAME = "PayListInfos", XMLPROJECTION = "COLLECTION");

}
