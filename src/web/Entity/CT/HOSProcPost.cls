/// 描述:流程岗位
/// 创建人：鲁俊文
/// 创建日期：2023-2-6
Class web.Entity.CT.HOSProcPost Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

/// RowId
Property ID As %String;

/// 流程岗位代码
Property PPOSTCode As %String;

/// 流程岗位名称
Property PPOSTDesc As %String;

/// 是否有效(Y/N)
Property PPRPActivity As %String;

/// 业务单元代码
Property PPOSTBUCode As %String;

/// 岗位字典代码
Property PPOSTPOSTCCode As %String;

/// 是否有效(Y/N)
Property PPOSTActivity As %String;

/// 开始日期
Property PPOSTStartDate As %String;

/// 结束日期
Property PPOSTEndDate As %String;

/// 系统创建日期
Property PPOSTCreateDate As %String;

/// 系统创建时间
Property PPOSTCreateTime As %String;

/// 系统创建人
Property PPOSTCreateUser As %String;

/// 系统排序号
Property PPOSTSeqNo As %String;

/// 系统最后更新日期
Property PPOSTLastUpdateDate As %String;

/// 系统最后更新时间
Property PPOSTLastUpdateTime As %String;

/// 系统最新更新人
Property PPOSTLastUpdateUser As %String;

/// 拼音码
Property PPOSTPYCode As %String;

/// 五笔码
Property PPOSTWBCode As %String;

/// 备注
Property PPOSTMark As %String;

Parameter PersistentClassName = "web.Entity.CT.HOSProcPost";

}
