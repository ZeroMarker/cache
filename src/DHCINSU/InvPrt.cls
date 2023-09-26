Class DHCINSU.InvPrt Extends (%SerialObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "InvPrt";

Property InvPrtNo As %String;

Property PaadmRowid As %String;

Property TmpInvRowid As %String;

Property InvAdmReason As %String;

Property InvTotal As %String;

Property INSUOPDiagInfoCol As list Of DHCINSU.Model.BJ.INSUOPDiagInfo;

Relationship PatientBill As DHCINSU.PatientBill(XMLNAME = "PatientBill", XMLPROJECTION = "ELEMENT") [ Cardinality = many, Inverse = InvPrt ];

Relationship InvPrtCol As DHCINSU.InvPrtCol(XMLPROJECTION = "NONE") [ Cardinality = one, Inverse = InvPrt ];

}
