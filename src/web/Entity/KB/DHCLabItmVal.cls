/// 名称: 检验项目与指标关联表
/// 描述: 实体类
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2014-11-5
Class web.Entity.KB.DHCLabItmVal Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCLabItmVal";

Property PHLFIRowId As %String;

Property PHLFIParRefDr As %String;

Property PHLFIChildsub As %String;

Property PHLFIGenDr As %String;

Property PHLFIVal As %String;

Property PHLFIRelation As %String;

}
