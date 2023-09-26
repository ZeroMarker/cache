Class web.DHCOutPhRecADJPriceMeg Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLNAME = "TarAdjust";

//Pharmacy 调价单号

//Property AdjNo As %String;

//Date 调整日期 格式为：yyyy-MM-dd

Property Date1 As %String(TRUNCATE = 1);

//变化药品明细

Property PhInformation As list Of web.DHCOutPhRecADJPriceMegSub(XMLITEMNAME = "");

}
