Class BILL.EINV.DTO.TBTCA.OPEInvTurnPaperRes Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 0;

Parameter XMLNAME = "Voucher";

/// 主单信息
Property Main As BILL.EINV.DTO.TBTCA.OPEInvTurnPaperMain(XMLPROJECTION = "ELEMENT");

/// 门诊纸质票据信息
Property BillInfos As list Of BILL.EINV.DTO.TBTCA.OPEInvTurnPaperBillInfos(XMLPROJECTION = "ELEMENT");

/// 错误代码
Property ResultCode As %String(XMLPROJECTION = "ELEMENT");

/// 错误描述
Property ResultMsg As %String(XMLPROJECTION = "ELEMENT");

}
