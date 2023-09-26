/// 项目：重庆人民医院，添加专项护理字典维护界面
/// 描述: 专项护理子表 entity
/// 表名：CTLocLinkSpNur
/// 编写者：基础数据平台组 李可凡
/// 编写日期: 2019年8月22日
Class web.Entity.CT.CTLocLinkSpNur Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.Entity.CT.CTLocLinkSpNur";

Property SpNurParRef As %String;

Property SpNurRowId As %String;

Property SpNurChildsub As %String;

Property SpNurDR As %String;

}
