Class web.Entity.MKB.MKBGlobalReference Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.MKB.MKBGlobalReference";

/// RowId
Property MKBGRRowid As %String;

/// 发起引用，主动引用标识
Property InitiativeFlag As %String;

/// 发起引用词的ID
Property InitiativeID As %String;

/// 被引用词的ID
Property PassiveID As %String;

/// 被引用词的名称列表ID
Property PassiveAliasID As %String;

}
