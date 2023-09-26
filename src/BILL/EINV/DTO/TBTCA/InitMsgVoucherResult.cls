Class BILL.EINV.DTO.TBTCA.InitMsgVoucherResult Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "Voucher";

/// 授权凭证
Property AccessToken As %String(XMLPROJECTION = "ELEMENT");

/// 有效时间
Property ExpiresIn As %String(XMLPROJECTION = "ELEMENT");

/// 错误代码
Property ResultCode As %String(XMLPROJECTION = "ELEMENT");

/// 错误描述
Property ResultMsg As %String(XMLPROJECTION = "ELEMENT");

// Property ErrInfo As BILL.EINV.DTO.TBTCA.ErrInfo;

}
