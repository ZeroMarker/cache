/// 描述:组织机构行业分类字典
/// CreateDate:2022-11-10
/// Creator:钟荣枫
Class web.Entity.CT.HOSOrgInduCategory Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HOSOrgInduCategory";

Property ID As %String;

/// 组织机构行业分类代码
Property ORGICCode As %String;

/// 组织机构行业分类名称
Property ORGICDesc As %String;

/// 分类来源
Property ORGICSource As %String;

/// 是否有效(Y/N)
Property ORGICActivity As %String;

/// 开始日期
Property ORGICStartDate As %String;

/// 结束日期
Property ORGICEndDate As %String;

/// 系统创建日期
Property ORGICCreateDate As %String;

/// 系统创建时间
Property ORGICCreateTime As %String;

/// 系统创建人
Property ORGICCreateUser As %String;

/// 系统排序号
Property ORGICSeqNo As %String;

/// 系统最后更新日期
Property ORGICLastUpdateDate As %String;

/// 系统最后更新时间
Property ORGICLastUpdateTime As %String;

/// 系统最新更新人
Property ORGICLastUpdateUser As %String;

/// 拼音码
Property ORGICPYCode As %String;

/// 五笔码
Property ORGICWBCode As %String;

/// 备注
Property ORGICMark As %String;

}
