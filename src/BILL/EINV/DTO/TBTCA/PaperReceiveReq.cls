Class BILL.EINV.DTO.TBTCA.PaperReceiveReq Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "Voucher";

/// 领用开始日期YYYYMMDD
Property BeginDate As %String(XMLPROJECTION = "ELEMENT");

/// 领用截止日期YYYYMMDD
Property EndDate As %String(XMLPROJECTION = "ELEMENT");

/// 纸质票据代码
Property BillCode As %String(XMLPROJECTION = "ELEMENT");

/// 领用人工号
Property Receiver As %String(XMLPROJECTION = "ELEMENT");

}
