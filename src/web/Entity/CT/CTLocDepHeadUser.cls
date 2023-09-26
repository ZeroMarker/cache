/// 项目：安徽淮南朝阳，张婷，科主任需要维护多个人
/// 描述: 科主任子表 Entity类
/// 表名：CT_LocDepHeadUser
/// 父表：科室病区User.CTLoc
/// 编写者：基础数据平台-likefan
/// 编写日期: 2021-01-06
Class web.Entity.CT.CTLocDepHeadUser Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.Entity.CT.CTLocDepHeadUser";

Property CTDHUParRef As %String;

Property CTDHURowId As %String;

Property CTDHUChildsub As %String;

Property CTDHUDepHeadUserDR As %String;

Property CTDHUDateFrom As %String;

Property CTDHUDateTo As %String;

}
