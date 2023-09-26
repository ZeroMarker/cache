Class DHCExternalService.BillInterface.DHCEntity.DepRecord Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// ResultCode
Property ResultCode As %String(TRUNCATE = 1);

/// ErrorMsg
Property ResultContent As %String(TRUNCATE = 1);

Property RecordInfo As list Of DHCExternalService.BillInterface.DHCEntity.RecordInfo(XMLITEMNAME = "RecordInfo", XMLPROJECTION = "COLLECTION");

}
