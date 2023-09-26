Class BILL.EINV.DTO.BWA.ESearchResKpxxGrp Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Property xh As %String(XMLPROJECTION = "ATTRIBUTE");

/// 发票代码
Property fpdm As %String(XMLPROJECTION = "ELEMENT");

/// 发票号码
Property fphm As %String(XMLPROJECTION = "ELEMENT");

/// 发票状态
Property fpzt As %String(XMLPROJECTION = "ELEMENT");

/// 上传标志
Property scbz As %String(XMLPROJECTION = "ELEMENT");

/// 开票日期YYYYMMDDHHMMSS
Property kprq As %String(XMLPROJECTION = "ELEMENT");

/// 税控服务器编号
Property jqbh As %String(XMLPROJECTION = "ELEMENT");

/// 税控码
Property skm As %String(XMLPROJECTION = "ELEMENT");

/// 校验码
Property jym As %String(XMLPROJECTION = "ELEMENT");

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

/// 编码表版本号
Property bmbbbh As %String(XMLPROJECTION = "ELEMENT");

/// 征税方式
Property zsfs As %String(XMLPROJECTION = "ELEMENT");

Property fyxm As BILL.EINV.DTO.BWA.ESearchResFyxm(XMLPROJECTION = "ELEMENT");

Property qdxm As BILL.EINV.DTO.BWA.ESearchResQdxm(XMLPROJECTION = "ELEMENT");

Property qtxm As BILL.EINV.DTO.BWA.ESearchResQtxm(XMLPROJECTION = "ELEMENT");

/// 综合税率
Property zhsl As %String(XMLPROJECTION = "ELEMENT");

/// 合计金额
Property hjje As %String(XMLPROJECTION = "ELEMENT");

/// 合计税额
Property hjse As %String(XMLPROJECTION = "ELEMENT");

/// 价税合计
Property jshj As %String(XMLPROJECTION = "ELEMENT");

/// 备注
Property bz As %String(XMLPROJECTION = "ELEMENT");

/// 收款人
Property skr As %String(XMLPROJECTION = "ELEMENT");

/// 复核人
Property fhr As %String(XMLPROJECTION = "ELEMENT");

/// 开票人
Property kpr As %String(XMLPROJECTION = "ELEMENT");

/// 加密版本号
Property jmbbh As %String(XMLPROJECTION = "ELEMENT");

/// 主要商品名称
Property zyspmc As %String(XMLPROJECTION = "ELEMENT");

/// 商品税目
Property spsm As %String(XMLPROJECTION = "ELEMENT");

/// 清单标志
Property qdbz As %String(XMLPROJECTION = "ELEMENT");

/// 所属月份
Property ssyf As %String(XMLPROJECTION = "ELEMENT");

/// 开票机号
Property kpjh As %String(XMLPROJECTION = "ELEMENT");

/// 信息表编号
Property tzdbh As %String(XMLPROJECTION = "ELEMENT");

/// 原发票代码
Property yfpdm As %String(XMLPROJECTION = "ELEMENT");

/// 原发票号码
Property yfphm As %String(XMLPROJECTION = "ELEMENT");

/// 作废日期
Property zfrq As %String(XMLPROJECTION = "ELEMENT");

/// 作废人
Property zfr As %String(XMLPROJECTION = "ELEMENT");

/// 签名参数
Property qmcs As %String(XMLPROJECTION = "ELEMENT");

/// 签名值
Property qmz As %String(XMLPROJECTION = "ELEMENT");

/// 已开负数金额
Property ykfsje As %String(XMLPROJECTION = "ELEMENT");

/// 二维码
Property ewm As %String(XMLPROJECTION = "ELEMENT");

}
