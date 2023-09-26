/// 名称:群组关联个人通讯录表
/// 编写者:基础数据平台组 - 杨帆
/// 编写日期: 2020-12-25
Class web.Entity.CT.CTHCCSGroupLinkContList Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTHCCSGroupLinkContList";

// CGCLRowId

Property CGCLRowId As %String;

// CGCLParRef

Property CGCLParRef As %String;

// Childsub

Property CGCLChildsub As %String;

// 关联用户

Property CGCLContactListDR As %String;

}
