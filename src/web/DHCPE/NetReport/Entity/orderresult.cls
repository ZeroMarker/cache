Class web.DHCPE.NetReport.Entity.orderresult Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Property hisorderid As %String(TRUNCATE = 1);

Property detailresults As list Of web.DHCPE.NetReport.Entity.detailresult;

}
