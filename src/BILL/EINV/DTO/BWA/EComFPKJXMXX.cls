/// 电子票据项目节点信息定义
Class BILL.EINV.DTO.BWA.EComFPKJXMXX Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

/// 发票行性质	
Property FPHXZ As %String(XMLPROJECTION = "ELEMENT");

/// 商品编码
Property SPBM As %String(XMLPROJECTION = "ELEMENT");

/// 自行编码
Property ZXBM As %String(XMLPROJECTION = "ELEMENT");

/// 优惠政策标识
Property YHZCBS As %String(XMLPROJECTION = "ELEMENT");

/// 零税率标识
Property LSLBS As %String(XMLPROJECTION = "ELEMENT");

/// 增值税特殊管理
Property ZZSTSGL As %String(XMLPROJECTION = "ELEMENT");

/// 项目名称
Property XMMC As %String(XMLPROJECTION = "ELEMENT");

/// 规格型号
Property GGXH As %String(XMLPROJECTION = "ELEMENT");

/// 单位
Property DW As %String(XMLPROJECTION = "ELEMENT");

/// 项目数量
Property XMSL As %String(XMLPROJECTION = "ELEMENT");

/// 项目单价
Property XMDJ As %String(XMLPROJECTION = "ELEMENT");

/// 项目金额
Property XMJE As %String(XMLPROJECTION = "ELEMENT");

/// 税率
Property SL As %String(XMLPROJECTION = "ELEMENT");

/// 税额
Property SE As %String(XMLPROJECTION = "ELEMENT");

}
