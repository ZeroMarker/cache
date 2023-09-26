Class web.DHCPE.NetReport.Entity.CheckMainInfo Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLSEQUENCE = 1;

Property hisregno As %String(TRUNCATE = 1);

Property checkdate As %String(TRUNCATE = 1);

Property auditdate As %String(TRUNCATE = 1);

Property auditdoctor As %String(TRUNCATE = 1);

Property hispaadm As %String(TRUNCATE = 1);

Property workunit As %String(TRUNCATE = 1);

Property checkdoctor As %String(TRUNCATE = 1);

}
