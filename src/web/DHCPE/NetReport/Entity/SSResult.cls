Class web.DHCPE.NetReport.Entity.SSResult Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Property hispaadm As %String(TRUNCATE = 1);

Property stationresults As list Of web.DHCPE.NetReport.Entity.stationresult;

}
