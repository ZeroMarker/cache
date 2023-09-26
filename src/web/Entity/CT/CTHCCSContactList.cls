/// 名称:个人通讯录
/// 编写者:基础数据平台组 - 杨帆
/// 编写日期: 2020-12-17
Class web.Entity.CT.CTHCCSContactList Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTHCCSContactList";

// HCCSCLRowId

Property HCCSCLRowId As %String;

// 用户代码

Property HCCSCLUserCode As %String;

// 用户(代码+名称)

Property HCCSCLUser As %String;

// 科室代码

Property HCCSCLLocCode As %String;

// VOIP号码

Property HCCSCLVOIPNumber As %String;

// 开始日期

Property HCCSCLDateFrom As %String;

// 结束日期

Property HCCSCLDateTo As %String;

// 用户描述

Property HCCSCLUserDesc As %String;

// 科室描述

Property HCCSCLLocDesc As %String;

// 患者标志--项目上新增

Property HCCSCLPatientFlag As %String;

// 人员分类

Property HCCSCLType As %String;

}
