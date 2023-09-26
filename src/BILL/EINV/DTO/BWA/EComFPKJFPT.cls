/// 发票概要信息节点 COMMON_FPKJ_FPT
Class BILL.EINV.DTO.BWA.EComFPKJFPT Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Property class As %String(XMLPROJECTION = "ATTRIBUTE");

/// 发票请求流水号
Property FPQQLSH As %String(XMLPROJECTION = "ELEMENT");

/// 订单号
Property ORDERID As %String(XMLPROJECTION = "ELEMENT");

/// 开票类型
Property KPLX As %String(XMLPROJECTION = "ELEMENT");

/// 编码表版本号
Property BMBBBH As %String(XMLNAME = "BMB_BBH", XMLPROJECTION = "ELEMENT");

/// 征税方式
Property ZSFS As %String(XMLPROJECTION = "ELEMENT");

/// 特殊票种标识
Property TSPZ As %String(XMLPROJECTION = "ELEMENT");

/// 销售方纳税人识别号
Property XSFNSRSBH As %String(XMLNAME = "XSF_NSRSBH", XMLPROJECTION = "ELEMENT");

/// 销售方名称
Property XSFMC As %String(XMLNAME = "XSF_MC", XMLPROJECTION = "ELEMENT");

/// 销售方地址、电话
Property XSFDZDH As %String(XMLNAME = "XSF_DZDH", XMLPROJECTION = "ELEMENT");

/// 销售方银行账号
Property XSFYHZH As %String(XMLNAME = "XSF_YHZH", XMLPROJECTION = "ELEMENT");

/// 销售方移动电话或邮箱
Property XSFLXFS As %String(XMLNAME = "XSF_LXFS", XMLPROJECTION = "ELEMENT");

/// 购买方纳税人识别号
Property GMFNSRSBH As %String(XMLNAME = "GMF_NSRSBH", XMLPROJECTION = "ELEMENT");

/// 购买方名称
Property GMFMC As %String(XMLNAME = "GMF_MC", XMLPROJECTION = "ELEMENT");

/// 购买方地址、电话
Property GMFDZDH As %String(XMLNAME = "GMF_DZDH", XMLPROJECTION = "ELEMENT");

/// 购买方银行账号
Property GMFYHZH As %String(XMLNAME = "GMF_YHZH", XMLPROJECTION = "ELEMENT");

/// 购买方移动电话或邮箱
Property GMFLXFS As %String(XMLNAME = "GMF_LXFS", XMLPROJECTION = "ELEMENT");

/// add 发票代码
Property FPDM As %String(XMLNAME = "FP_DM", XMLPROJECTION = "ELEMENT");

/// add 发票号码
Property FPHM As %String(XMLNAME = "FP_HM", XMLPROJECTION = "ELEMENT");

/// add 开具日期
Property KPRQ As %String(XMLNAME = "KPRQ", XMLPROJECTION = "ELEMENT");

/// add 密文
Property FPMW As %String(XMLNAME = "FP_MW", XMLPROJECTION = "ELEMENT");

/// add 校验码
Property JYM As %String(XMLNAME = "JYM", XMLPROJECTION = "ELEMENT");

/// 开票人
Property KPR As %String(XMLPROJECTION = "ELEMENT");

/// 收款人
Property SKR As %String(XMLPROJECTION = "ELEMENT");

/// 复核人
Property FHR As %String(XMLPROJECTION = "ELEMENT");

/// 原发票代码
Property YFPDM As %String(XMLNAME = "YFP_DM", XMLPROJECTION = "ELEMENT");

/// 原发票号码
Property YFPHM As %String(XMLNAME = "YFP_HM", XMLPROJECTION = "ELEMENT");

/// 价税合计
Property JSHJ As %String(XMLPROJECTION = "ELEMENT");

/// 合计金额
Property HJJE As %String(XMLPROJECTION = "ELEMENT");

/// 合计税额
Property HJSE As %String(XMLPROJECTION = "ELEMENT");

/// 扣除额
Property KCE As %String(XMLPROJECTION = "ELEMENT");

/// 备注
Property BZ As %String(XMLPROJECTION = "ELEMENT");

}
