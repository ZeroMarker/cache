Class BILL.EINV.DTO.BWA.ESearchResFyxmGrp Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Property xh As %String(XMLPROJECTION = "ATTRIBUTE");

/// 发票行性质
Property fphxz As %String(XMLPROJECTION = "ELEMENT");

/// 商品名称
Property spmc As %String(XMLPROJECTION = "ELEMENT");

/// 商品税目
Property spsm As %String(XMLPROJECTION = "ELEMENT");

/// 规格型号
Property ggxh As %String(XMLPROJECTION = "ELEMENT");

/// 单位
Property dw As %String(XMLPROJECTION = "ELEMENT");

/// 商品数量
Property spsl As %String(XMLPROJECTION = "ELEMENT");

/// 单价
Property dj As %String(XMLPROJECTION = "ELEMENT");

/// 金额
Property je As %String(XMLPROJECTION = "ELEMENT");

/// 税率
Property sl As %String(XMLPROJECTION = "ELEMENT");

/// 税额
Property se As %String(XMLPROJECTION = "ELEMENT");

/// 含税标志
Property hsbz As %String(XMLPROJECTION = "ELEMENT");

/// 商品编码
Property spbm As %String(XMLPROJECTION = "ELEMENT");

/// 纳税人自行编码
Property zxbm As %String(XMLPROJECTION = "ELEMENT");

/// 优惠政策标识
Property yhzcbs As %String(XMLPROJECTION = "ELEMENT");

/// 零税率标识
Property lslbs As %String(XMLPROJECTION = "ELEMENT");

/// 增值税特殊管理
Property zzstsgl As %String(XMLPROJECTION = "ELEMENT");

}
