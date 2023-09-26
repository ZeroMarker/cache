/// 名称:用户医护人员
/// 描述: 实体类
/// 编写者：基础数据平台组-陈莹
/// 编写日期: 2017-03-16
Class web.BDPExt.SSUserEntity Extends (web.Entity.CT.SSUser, web.Entity.CT.CTCareProv, web.Entity.CT.SSUserOtherLogonLoc, web.Entity.CT.RBResource, web.Entity.CT.BDPAlias)
{

Parameter PersistentClassName = "web.BDPExt.SSUserEntity";

Property Type As %String;

Property DeptLoc As %String;

/// 管制药品分类权限（/分隔）   麻醉药品/一类精神/二类精神/毒性药品 2020-04-17
Property CTCareProvPHCPoison As %String;

/// 关联处方权（/分隔）   中草药/西药/藏药	2021-01-06
Property CTCareProvPrescriptSet As %String;

}
