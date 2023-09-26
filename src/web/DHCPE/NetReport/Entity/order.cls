Class web.DHCPE.NetReport.Entity.order Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Property hisorderid As %String(TRUNCATE = 1);

Property ordername As %String(TRUNCATE = 1);

Property reportformt As %String(TRUNCATE = 1);

Property checkdoctor As %String(TRUNCATE = 1);

Property checkdate As %String(TRUNCATE = 1);

Property auditdoctor As %String(TRUNCATE = 1);

Property auditdate As %String(TRUNCATE = 1);

Property sort As %String(TRUNCATE = 1);

}
