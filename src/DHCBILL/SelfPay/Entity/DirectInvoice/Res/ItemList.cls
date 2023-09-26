/// / Creator:TianZJ
/// / CreatDate:2022-04-14
/// / Description:获取导诊单打印数据出参类
Class DHCBILL.SelfPay.Entity.DirectInvoice.Res.ItemList Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// Itm 项目名称
Property Itm As %String(TRUNCATE = 1);

/// Qty 数量
Property Qty As %String(TRUNCATE = 1);

/// Price 单价
Property Price As %String(TRUNCATE = 1);

/// Amount 金额
Property Amount As %String(TRUNCATE = 1);

/// Unit 单位
Property Unit As %String(TRUNCATE = 1);

/// ItemSpecs 项目规格
Property ItemSpecs As %String(TRUNCATE = 1);

/// Adress 地址
Property Adress As %String(TRUNCATE = 1);

/// ArcType 项目分类
Property ArcType As %String(TRUNCATE = 1);

}
