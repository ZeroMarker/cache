/// 名称: 收费项别名
/// 描述: 新物流维护页面用到
/// 编写者：基础数据平台组-陈莹
/// 编写日期: 2015-7-28
Class web.Entity.CT.DHCTarItemAlias Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.DHCTarItemAlias";

Property TIARowId As %Library.String;

/// TIA_TARI_DR 
Property TIATARIDR As %Library.String;

/// Tariff Description
Property TIADesc As %Library.String;

///  TIA_Alias
Property TIAAlias As %Library.String;

}
