Class DHCINSU.PatBillDetails Extends (%SerialObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "PatBillDetails";

Property PBDr As %String;

//dhc_patbilldetails.rowid

Property PBDID As %String;

//单价

Property UnitPrice As %String;

//数量

Property BillQty As %String;

//金额

Property TotalAmount As %String;

//DHC_PatBillOrder.PBO_OrderDate

Property PBOOrderDate As %String;

//DHC_PatBillOrder.PBO_OrderTime

Property PBOOrderTime As %String;

//His收费项信息

Property HisTarItemInfo As DHCINSU.HisTarItemInfo;

//医保目录信息

Property InsuTarItemInfo As DHCINSU.InsuTarItemInfo;

//医保目录对照信息

Property InsuTarContrastInfo As DHCINSU.InsuTarContrastInfo;

//医嘱信息

Property OeordInfo As DHCINSU.OeordInfo;

//结算明细表信息

Property InsuDivideSubInfo As DHCINSU.InsuDivideSubInfo;

Relationship PatientBill As DHCINSU.PatientBill(XMLPROJECTION = "NONE") [ Cardinality = one, Inverse = PatBillDetails ];

}
