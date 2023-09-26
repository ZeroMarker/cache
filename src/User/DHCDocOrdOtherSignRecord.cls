/// 其它医嘱信息签名记录,此类为非持久化类,为User.DHCDocSignVeify.SVOEORIOtherSignRecord存储使用
Class User.DHCDocOrdOtherSignRecord Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

/// 医嘱CA认证 数据资源类型定义关联(定义是那一段数据的认证)
Property OSVSignResTypeDR As User.DHCSignResType;

/// 医嘱信息原文(使用XML数据格式)
Property OSVInfo As %String;

/// 签名证书(仅数据签名服务器验签需要此参数,其它P7和XML都封装在签名信息中)
Property OSVSignCert As %String;

/// 签名信息
Property OSVSignValue As %String;

}
