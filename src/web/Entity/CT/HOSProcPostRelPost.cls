/// 描述:流程岗位与业务岗位关系
/// 创建人：鲁俊文
/// 创建日期：2023-2-2
Class web.Entity.CT.HOSProcPostRelPost Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HOSProcPostRelPost";

/// RowId
Property ID As %String;

/// 流程岗位代码
Property PPRPProcPostCode As %String;

/// 业务岗位代码
Property PPRPPostCode As %String;

/// 是否有效(Y/N)
Property PPRPActivity As %String;

/// 开始日期
Property PPRPStartDate As %String;

/// 结束日期
Property PPRPEndDate As %String;

/// 系统创建日期
Property PPRPCreateDate As %String;

/// 系统创建时间
Property PPRPCreateTime As %String;

/// 系统创建人
Property PPRPCreateUser As %String;

/// 系统排序号
Property PPRPSeqNo As %String;

/// 系统最后更新日期
Property PPRPLastUpdateDate As %String;

/// 系统最后更新时间
Property PPRPLastUpdateTime As %String;

/// 系统最新更新人
Property PPRPLastUpdateUser As %String;

/// 拼音码
Property PPRPPYCode As %String;

/// 五笔码
Property PPRPWBCode As %String;

/// 备注
Property PPRPMark As %String;

}
