/// 名称:系统配置 - 1 登陆语言
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2013-7-3
Class web.Entity.CT.SSLanguage Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.SSLanguage";

Property CTLANRowId As %String;

// 代码

Property CTLANCode As %String;

// ASA分级

Property CTLANDesc As %String;

/// 是否有效(Y/N)
Property CTLANActivity As %String;

/// 开始日期
Property CTLANStartDate As %String;

/// 结束日期
Property CTLANEndDate As %String;

/// 系统创建日期
Property CTLANCreateDate As %String;

/// 系统创建时间
Property CTLANCreateTime As %String;

/// 系统创建人
Property CTLANCreateUser As %String;

/// 系统排序号
Property CTLANSeqNo As %String;

/// 系统最后更新日期
Property CTLANLastUpdateDate As %String;

/// 系统最后更新时间
Property CTLANLastUpdateTime As %String;

/// 系统最新更新人
Property CTLANLastUpdateUser As %String;

/// 拼音码
Property CTLANPYCode As %String;

/// 五笔码
Property CTLANWBCode As %String;

/// 备注
Property CTLANMark As %String;

}
