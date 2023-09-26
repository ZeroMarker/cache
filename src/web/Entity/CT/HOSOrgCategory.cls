/// 描述:组织机构大类字典
/// CreateDate:2022-11-10
/// Creator:钟荣枫
Class web.Entity.CT.HOSOrgCategory Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HOSOrgInduCategory";

Property ID As %String;

/// 组织机构大类代码
Property ORGCCode As %String;

/// 组织机构大类名称
Property ORGCDesc As %String;

/// 分类来源
Property ORGCSource As %String;

/// 是否有效(Y/N)
Property ORGCActivity As %String;

/// 开始日期
Property ORGCStartDate As %String;

/// 结束日期
Property ORGCEndDate As %String;

/// 系统创建日期
Property ORGCCreateDate As %String;

/// 系统创建时间
Property ORGCCreateTime As %String;

/// 系统创建人
Property ORGCCreateUser As %String;

/// 系统排序号
Property ORGCSeqNo As %String;

/// 系统最后更新日期
Property ORGCLastUpdateDate As %String;

/// 系统最后更新时间
Property ORGCLastUpdateTime As %String;

/// 系统最新更新人
Property ORGCLastUpdateUser As %String;

/// 拼音码
Property ORGCPYCode As %String;

/// 五笔码
Property ORGCWBCode As %String;

/// 备注
Property ORGCMark As %String;

}
