Class BILL.EINV.DTO.BWA.PReqComBody Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Property yylxdm As %String(XMLPROJECTION = "ATTRIBUTE");

/// 开票终端标识
Property kpzdbs As %String(XMLPROJECTION = "ELEMENT");

/// 发票类型代码
Property fplxdm As %String(XMLPROJECTION = "ELEMENT");

/// 发票请求流水号
Property fpqqlsh As %String(XMLPROJECTION = "ELEMENT");

/// 开票类型
Property kplx As %String(XMLPROJECTION = "ELEMENT");

/// 特殊票种标识
Property tspz As %String(XMLPROJECTION = "ELEMENT");

/// 销货单位识别号
Property xhdwsbh As %String(XMLPROJECTION = "ELEMENT");

/// 销货单位名称
Property xhdwmc As %String(XMLPROJECTION = "ELEMENT");

/// 销货单位地址电话
Property xhdwdzdh As %String(XMLPROJECTION = "ELEMENT");

/// 销货单位银行帐号
Property xhdwyhzh As %String(XMLPROJECTION = "ELEMENT");

/// 购货单位识别号
Property ghdwsbh As %String(XMLPROJECTION = "ELEMENT");

/// 购货单位名称
Property ghdwmc As %String(XMLPROJECTION = "ELEMENT");

/// 购货单位地址电话
Property ghdwdzdh As %String(XMLPROJECTION = "ELEMENT");

/// 购货单位银行帐号
Property ghdwyhzh As %String(XMLPROJECTION = "ELEMENT");

/// 清单标志
Property qdbz As %String(XMLPROJECTION = "ELEMENT");

/// 征税方式
Property zsfs As %String(XMLPROJECTION = "ELEMENT");

Property fyxm As BILL.EINV.DTO.BWA.PComFYMX(XMLPROJECTION = "ELEMENT");

/// 合计金额
Property hjje As %String(XMLPROJECTION = "ELEMENT");

/// 合计税额
Property hjse As %String(XMLPROJECTION = "ELEMENT");

/// 价税合计
Property jshj As %String(XMLPROJECTION = "ELEMENT");

/// 差额征税扣除额
Property kce As %String(XMLPROJECTION = "ELEMENT");

/// 备注
Property bz As %String(XMLPROJECTION = "ELEMENT");

/// 收款人
Property skr As %String(XMLPROJECTION = "ELEMENT");

/// 复核人
Property fhr As %String(XMLPROJECTION = "ELEMENT");

/// 开票人
Property kpr As %String(XMLPROJECTION = "ELEMENT");

/// 信息表编号
Property tzdbh As %String(XMLPROJECTION = "ELEMENT");

/// 原发票代码
Property yfpdm As %String(XMLPROJECTION = "ELEMENT");

/// 原发票号码
Property yfphm As %String(XMLPROJECTION = "ELEMENT");

}
