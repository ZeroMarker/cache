/// 查询接口参数返回值
Class BILL.EINV.DTO.HTXXA.EInvQueryRes Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "EIFeiBasicQueryResponse";

Property HoldSerialBiz As %String(CAPTION = "业务流水号", XMLPROJECTION = "ELEMENT");

Property EInvoiceCode As %String(CAPTION = "电子票据代码", XMLPROJECTION = "ELEMENT");

Property EInvoiceNumber As %String(CAPTION = "电子票据号码", XMLPROJECTION = "ELEMENT");

Property RandomNumber As %String(CAPTION = "校验码", XMLPROJECTION = "ELEMENT");

Property TotalAmount As %String(CAPTION = "总金额", XMLPROJECTION = "ELEMENT");

Property IssueDateTime As %String(CAPTION = "开票日期", XMLPROJECTION = "ELEMENT");

Property BillCurStatus As %String(CAPTION = "票据当前状态", XMLPROJECTION = "ELEMENT");

Property WindowNo As %String(CAPTION = "窗口号", XMLPROJECTION = "ELEMENT");

}
