/// Function: 职位字典
/// CreateDate:2022-11-10
/// Creator:钟荣枫
Class web.Entity.CT.HOSPositionDict Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HOSPositionDict";

Property ID As %String;

/// 职位代码
Property POSCCode As %String;

/// 职位名称
Property POSCDesc As %String;

/// 是否有效(Y/N)
Property POSCActivity As %String;

/// 开始日期
Property POSCStartDate As %String;

/// 结束日期
Property POSCEndDate As %String;

/// 系统创建日期
Property POSCCreateDate As %String;

/// 系统创建时间
Property POSCCreateTime As %String;

/// 系统创建人
Property POSCCreateUser As %String;

/// 系统排序号
Property POSCSeqNo As %String;

/// 系统最后更新日期
Property POSCLastUpdateDate As %String;

/// 系统最后更新时间
Property POSCLastUpdateTime As %String;

/// 系统最新更新人
Property POSCLastUpdateUser As %String;

/// 拼音码
Property POSCPYCode As %String;

/// 五笔码
Property POSCWBCode As %String;

/// 备注
Property POSCMark As %String;

}
