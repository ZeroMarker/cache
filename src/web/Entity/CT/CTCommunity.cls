/// 名称: 社区信息-社区/村 
/// 编写者:sunfengchao
/// 编写日期:2016-5-10
Class web.Entity.CT.CTCommunity Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTCommunity";

Property CTCMUNTRowId As %String;

/// 代码
Property CTCMUNTCode As %String;

/// 城市
Property CTCMUNTDesc As %String;

/// 所属街道代码
Property CTCMUNTNationalCode As %String;

/// 有效
Property CTCMUNTActiveFlag As %String;

/// 所属街道描述
Property CTCMUNTNationalDesc As %String;

}
