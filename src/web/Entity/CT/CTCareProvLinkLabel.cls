/// 基础数据平台-李可凡
/// 2021-11-11
/// 医护人员关联标签表，一个人可以关联多个标签
/// User.CTCareProvLinkLabel
Class web.Entity.CT.CTCareProvLinkLabel Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.Entity.CT.CTCareProvLinkLabel";

Property CPLLParRef As %String;

Property CPLLRowId As %String;

Property CPLLChildsub As %String;

Property CPLLLabelDR As %String;

}
