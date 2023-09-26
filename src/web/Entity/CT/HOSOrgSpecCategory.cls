/// 描述:组织机构专业分类
/// 创建人：基础数据平台 zrf 
/// 创建日期：2022-09-21
Class web.Entity.CT.HOSOrgSpecCategory Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HOSOrgSpecCategory";

Property ID As %String;

/// 组织机构专业分类代码
Property ORGSPCCode As %String;

/// 组织机构专业分类名称
Property ORGSPCDesc As %String;

/// 组织机构小类-外键
Property ORGSPCORGSPCCode As %String;

/// 分类来源
Property ORGSPCSource As %String;

/// 是否有效(Y/N)
Property ORGSPCActivity As %String;

/// 开始日期
Property ORGSPCStartDate As %String;

/// 结束日期
Property ORGSPCEndDate As %String;

/// 系统创建日期
Property ORGSPCCreateDate As %String;

/// 系统创建时间
Property ORGSPCCreateTime As %String;

/// 系统创建人
Property ORGSPCCreateUser As %String;

/// 系统排序号
Property ORGSPCSeqNo As %String;

/// 系统最后更新日期
Property ORGSPCLastUpdateDate As %String;

/// 系统最后更新时间
Property ORGSPCLastUpdateTime As %String;

/// 系统最新更新人
Property ORGSPCLastUpdateUser As %String;

/// 拼音码
Property ORGSPCPYCode As %String;

/// 五笔码
Property ORGSPCWBCode As %String;

/// 备注
Property ORGSPCMark As %String;

}
