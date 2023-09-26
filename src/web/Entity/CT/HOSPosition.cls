/// Function: HOS组织职位
/// CreateDate:2022-11-10
/// Creator:钟荣枫
Class web.Entity.CT.HOSPosition Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HOSPosition";

Property ID As %String;

/// 组织职位代码
Property POSCode As %String;

/// 组织职位名称
Property POSDesc As %String;

/// 所属部门-外键
Property POSDeptCode As %String;

/// 职位字典代码-外键
Property POSPOSCCode As %String;

/// 额定人数
Property POSLimitedNum As %String;

/// 是否有效(Y/N)
Property POSActivity As %String;

/// 开始日期
Property POSStartDate As %String;

/// 结束日期
Property POSEndDate As %String;

/// 系统创建日期
Property POSCreateDate As %String;

/// 系统创建时间
Property POSCreateTime As %String;

/// 系统创建人
Property POSCreateUser As %String;

/// 系统排序号
Property POSSeqNo As %String;

/// 系统最后更新日期
Property POSLastUpdateDate As %String;

/// 系统最后更新时间
Property POSLastUpdateTime As %String;

/// 系统最新更新人
Property POSLastUpdateUser As %String;

/// 拼音码
Property POSPYCode As %String;

/// 五笔码
Property POSWBCode As %String;

/// 备注
Property POSMark As %String;

}
