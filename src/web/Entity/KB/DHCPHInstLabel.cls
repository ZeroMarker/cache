/// 名称: 知识库目录字典
/// 描述: 实体类
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2014-10-31
/// 最后修改日期: 2015-8-12
Class web.Entity.KB.DHCPHInstLabel Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCPHInstLabel";

/// PINL_RowID
Property PINLRowID As %String;

/// PINL_Desc
Property PINLDesc As %String;

/// PINL_OrderNum
Property PINLOrderNum As %String;

/// PINL_Code
Property PINLCode As %String;

/// PINL_ManageMode
Property PINLManageMode As %String;

Property PINLLabelDr As %String;

/// PINL_Icon
Property PINLIcon As %String;

/// PINL_AllFlag
Property PINLAllFlag As %String;

/// PINL_AlertMsg  2016/9/30
Property PINLAlertMsg As %String;

/// PINL_GenFlag  2018/01/26 在通用名目录显示
Property PINLGenFlag As %String;

/// PINL_ProFlag  2018/01/26 在商品名目录显示
Property PINLProFlag As %String;

/// PINL_Href 2018/01/26 js路径
Property PINLHref As %String;

}
