Class BILL.EINV.DTO.TBTCA.PaperReceiveRes Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 0;

Parameter XMLNAME = "Voucher";

/// 门诊纸质票据信息
Property ReceiveInfos As list Of BILL.EINV.DTO.TBTCA.PaperReceiveInfos(XMLPROJECTION = "ELEMENT");

/// 错误代码
Property ResultCode As %String(XMLPROJECTION = "ELEMENT");

/// 错误描述
Property ResultMsg As %String(XMLPROJECTION = "ELEMENT");

}
