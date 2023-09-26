/// 名称: 诊断与症状知识字典关联表
/// 描述: 实体类
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2016-8-24
Class web.Entity.KB.DHCPHDisLinkSym Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCPHDisLinkSym";

Property LSYRowId As %String;

Property LSYIcdDr As %String;

Property LSYSymDr As %String;

}
