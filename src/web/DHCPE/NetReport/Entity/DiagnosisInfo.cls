Class web.DHCPE.NetReport.Entity.DiagnosisInfo Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Property hispaadm As %String(TRUNCATE = 1);

Property diagnosiss As list Of web.DHCPE.NetReport.Entity.diagnosis;

}
