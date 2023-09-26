/// 描述:组织机构子类字典
/// 创建人：基础数据平台 zrf 
/// 创建日期：2022-09-21
Class web.Entity.CT.HOSOrgSubCategory Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HOSOrgInduCategory";

Property ID As %String;

/// 组织机构子类代码
Property ORGSCCode As %String;

/// 组织机构子类名称
Property ORGSCDesc As %String;

/// 组织机构大类-外键
Property ORGSCORGCCode As %String;

/// 分类来源
Property ORGSCSource As %String;

/// 是否有效(Y/N)
Property ORGSCActivity As %String;

/// 开始日期
Property ORGSCStartDate As %String;

/// 结束日期
Property ORGSCEndDate As %String;

/// 系统创建日期
Property ORGSCCreateDate As %String;

/// 系统创建时间
Property ORGSCCreateTime As %String;

/// 系统创建人
Property ORGSCCreateUser As %String;

/// 系统排序号
Property ORGSCSeqNo As %String;

/// 系统最后更新日期
Property ORGSCLastUpdateDate As %String;

/// 系统最后更新时间
Property ORGSCLastUpdateTime As %String;

/// 系统最新更新人
Property ORGSCLastUpdateUser As %String;

/// 拼音码
Property ORGSCPYCode As %String;

/// 五笔码
Property ORGSCWBCode As %String;

/// 备注
Property ORGSCMark As %String;

}
