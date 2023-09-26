/// 名称: 年龄字典
/// 描述: 实体类
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2014-10-30
Class web.Entity.KB.DHCPHPatAgeList Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCPHPatAgeList";

/// RowId号
Property PDARowID As %String;

/// PDA_AgeCode
Property PDAAgeCode As %String;

/// PDA_AgeDesc
Property PDAAgeDesc As %String;

/// PDA_AgeMin
Property PDAAgeMin As %String;

/// PDA_AgeMax
Property PDAAgeMax As %String;

/// PDA_ActiveFlag
Property PDAActiveFlag As %String;

/// PDA_SysFlag
Property PDASysFlag As %String;

Property PDAUomDr As %String;

}
