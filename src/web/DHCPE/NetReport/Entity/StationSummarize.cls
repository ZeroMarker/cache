Class web.DHCPE.NetReport.Entity.StationSummarize Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Property hispaadm As %String(TRUNCATE = 1);

Property stations As list Of web.DHCPE.NetReport.Entity.station;

}
