Class DHCExternalService.BillInterface.DHCEntity.DHCRBCReasonNotAvail Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// ID
Property ID As %String(TRUNCATE = 1);

/// Code
Property RNAVCode As %String(TRUNCATE = 1);

/// Date From
Property RNAVDateFrom As %String(TRUNCATE = 1);

/// Date To
Property RNAVDateTo As %String(TRUNCATE = 1);

/// Description
Property RNAVDesc As %String(TRUNCATE = 1);

/// Type
Property RNAVType As %String(TRUNCATE = 1);

}
