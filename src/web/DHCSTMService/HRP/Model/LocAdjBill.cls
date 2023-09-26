Class web.DHCSTMService.HRP.Model.LocAdjBill Extends XmlCommon
{

Parameter XMLNAME = "LocAdjBill";

Property LocDesc As %String(MAXLEN = "", XMLNAME = "LocDesc");

Property UserInital As %String(MAXLEN = "", XMLNAME = "UserInital");

Property Remarks As %String(MAXLEN = "", XMLNAME = "Remarks");

Property Type As %String(MAXLEN = "", XMLNAME = "Type");

Property BillItemList As list Of web.DHCSTMService.HRP.Model.LocAdjBillItem(XMLNAME = "LocAdjBillItem", XMLPROJECTION = "element");

}
