Class DHCDoc.Interface.Outside.TZWYHealthCard.Entity.RegisterRp Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Property success As %String(TRUNCATE = 1, XMLNAME = "success");

Property barcode As %String(TRUNCATE = 1, XMLNAME = "barcode");

Property errcode As %String(TRUNCATE = 1, XMLNAME = "errcode");

Property msg As %String(TRUNCATE = 1, XMLNAME = "msg");

Property eId As %String(TRUNCATE = 1, XMLNAME = "eId");

Property smsCheckCode As %String(TRUNCATE = 1, XMLNAME = "smsCheckCode");

Property dataFlag As %String(TRUNCATE = 1, XMLNAME = "dataFlag");

// "errcode"":"""",""msg"":"""",""eId"":""992E191793F26E99A1BE1F88FB81F213C7903AF0F103FF61E1B76F1FA7C1848E"",""success"":true,""dataFlag"":""exist"",

// ""smsCheckCode"":""900828"",""barcode"":""992E191793F26E99A1BE1F88FB81F213C7903AF0F103FF61E1B76F1FA7C1848E:1::1,C7B162528C58627EDBF5C3B1D918A988""}"

}
