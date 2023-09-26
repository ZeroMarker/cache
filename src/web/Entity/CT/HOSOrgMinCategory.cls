/// 描述:组织机构小类字典
/// CreateDate:2022-11-10
/// Creator:钟荣枫
Class web.Entity.CT.HOSOrgMinCategory Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HOSOrgMinCategory";

Property ID As %String;

/// 组织机构小类代码
Property ORGMCCode As %String;

/// 组织机构小类名称
Property ORGMCDesc As %String;

/// 组织机构子类-外键
Property ORGMCORGSCode As %String;

/// 分类来源
Property ORGMCSource As %String;

/// 是否有效(Y/N)
Property ORGMCActivity As %String;

/// 开始日期
Property ORGMCStartDate As %String;

/// 结束日期
Property ORGMCEndDate As %String;

/// 系统创建日期
Property ORGMCCreateDate As %String;

/// 系统创建时间
Property ORGMCCreateTime As %String;

/// 系统创建人
Property ORGMCCreateUser As %String;

/// 系统排序号
Property ORGMCSeqNo As %String;

/// 系统最后更新日期
Property ORGMCLastUpdateDate As %String;

/// 系统最后更新时间
Property ORGMCLastUpdateTime As %String;

/// 系统最新更新人
Property ORGMCLastUpdateUser As %String;

/// 拼音码
Property ORGMCPYCode As %String;

/// 五笔码
Property ORGMCWBCode As %String;

/// 备注
Property ORGMCMark As %String;

}
