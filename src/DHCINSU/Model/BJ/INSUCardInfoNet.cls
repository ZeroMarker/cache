Class DHCINSU.Model.BJ.INSUCardInfoNet Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNORENULL = 1;

Property persontype As %String;

Property isinredlist As %String;

Property isspecifiedhosp As %String;

Property ischronichosp As %String;

Property personcount As %String;

Property chroniccode As %String;

}
