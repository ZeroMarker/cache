Class DHCINSU.PatientBill Extends (%SerialObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "PatientBill";

Property PBDr As %String;

//账单状态

Property PBPayedFlag As %String;

//账单开始日期

Property PBDateFrom As %String;

//账单结束日期

Property PBDateTo As %String;

//结算人Dr

Property PBUpdateUserDr As %String;

//结算人

Property PBUpdateUser As %String;

//更新日期

Property UpdateDate As %String;

//更新时间

Property UpdateTime As %String;

//账单总金额

Property PBTotalAmount As %String;

//pb_admdr

Property PBAdmDr As %String;

//INSUPID

Property INSUPID As %String;

Relationship PatBillDetails As DHCINSU.PatBillDetails(XMLNAME = "PatBillDetails", XMLPROJECTION = "ELEMENT") [ Cardinality = many, Inverse = PatientBill ];

Relationship InvPrt As DHCINSU.InvPrt(XMLPROJECTION = "NONE") [ Cardinality = one, Inverse = PatientBill ];

}
