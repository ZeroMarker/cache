/// Function: HOS 组织人员表-组织和人员的关联表
/// CreateDate:2022-11-14
/// Creator:gaoshanshan
Class web.Entity.CT.HOSORGEmployee Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HOSORGEmployee";

Property ID As %String;

/// 组织代码
Property EMPORGCode As %String;

/// 人员唯一标识码
Property EMPPAPersonID As %String;

/// 工号
Property EMPPAPersonNo As %String;

/// 入职日期
Property EMPJoinDate As %String;

/// 工作状态-外键？？
Property EMPStatus As %String;

/// 离职日期
Property EMPSeparationDate As %String;

/// 是否有效(Y/N)
Property EMPActivity As %String;

/// 开始日期
Property EMPStartDate As %String;

/// 结束日期
Property EMPEndDate As %String;

/// 系统创建日期
Property EMPCreateDate As %String;

/// 系统创建时间
Property EMPCreateTime As %String;

/// 系统创建人
Property EMPCreateUser As %String;

/// 系统排序号
Property EMPSeqNo As %String;

/// 系统最后更新日期
Property EMPLastUpdateDate As %String;

/// 系统最后更新时间
Property EMPLastUpdateTime As %String;

/// 系统最新更新人
Property EMPLastUpdateUser As %String;

/// 拼音码
Property EMPPYCode As %String;

/// 五笔码
Property EMPWBCode As %String;

/// 备注
Property EMPMark As %String;

}
