Class DHCINSU.InvPrtCol Extends (%SerialObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "InvPrtCol";

Property PaadmRowid As %String;

Property BillFlag As %String;

Relationship InvPrt As DHCINSU.InvPrt(XMLNAME = "InvPrt", XMLPROJECTION = "ELEMENT") [ Cardinality = many, Inverse = InvPrtCol ];

}
