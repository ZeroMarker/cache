/// 名称: 检验项目与结果关联表
/// 描述: 实体类
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2014-11-7
Class web.Entity.KB.DHCLabItmResult Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCLabItmResult";

Property PHLFIRowId As %String;

Property PHLFIParRefDr As %String;

Property PHLFIChildsub As %String;

Property PHLFIGenDr As %String;

Property PHLFIResult As %String;

}
