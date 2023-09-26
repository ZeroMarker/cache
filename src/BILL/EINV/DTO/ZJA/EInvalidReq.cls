Class BILL.EINV.DTO.ZJA.EInvalidReq Extends %RegisteredObject
{

/// 访问id
Property acceskeyid As %String(XMLPROJECTION = "ELEMENT");

/// 业务类型
Property businessType As %String(XMLPROJECTION = "ELEMENT");

/// 身份认证获取的票据
Property token As %String(XMLPROJECTION = "ELEMENT");

/// 随机数
Property nonce As %String(XMLPROJECTION = "ELEMENT");

/// 时间戳
Property timestamp As %String(XMLPROJECTION = "ELEMENT");

/// 时间戳
/// Property content As BILL.EINV.DTO.ZJA.EInvalidContextReq(XMLPROJECTION = "ELEMENT");
Property content As %String(XMLPROJECTION = "ELEMENT");

}
