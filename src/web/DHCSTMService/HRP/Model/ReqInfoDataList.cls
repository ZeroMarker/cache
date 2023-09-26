Class web.DHCSTMService.HRP.Model.ReqInfoDataList Extends XmlCommon
{

Parameter XMLNAME = "data";

///  科室编码
Property deptcode As %Library.String(MAXLEN = "", XMLNAME = "dept_code");

///  单据号
Property billno As %Library.String(MAXLEN = "", XMLNAME = "bill_no");

///  备注
Property remark As %Library.String(MAXLEN = "", XMLNAME = "remark");

///  制单人
Property maker As %Library.String(MAXLEN = "", XMLNAME = "maker");

///  制单日期
Property createdate As %String(MAXLEN = "", XMLNAME = "create_date");

Property detail As list Of web.DHCSTMService.HRP.Model.ReqItmInfo(XMLNAME = "detail", XMLPROJECTION = "element");

}
