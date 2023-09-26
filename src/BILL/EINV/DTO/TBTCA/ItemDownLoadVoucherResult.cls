Class BILL.EINV.DTO.TBTCA.ItemDownLoadVoucherResult Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "Voucher";

/// 单位编码
Property IvcAgcCode As %String(XMLPROJECTION = "ELEMENT");

/// 项目信息
Property Items As BILL.EINV.DTO.TBTCA.ItemResult(XMLPROJECTION = "ELEMENT");

/// 错误代码
Property ResultCode As %String(XMLPROJECTION = "ELEMENT");

/// 错误描述
Property ResultMsg As %String(XMLPROJECTION = "ELEMENT");

}
