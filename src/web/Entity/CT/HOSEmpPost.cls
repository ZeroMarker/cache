/// Function: HOS 人员岗位表
/// CreateDate:2022-11-15
/// Creator:gaoshanshan
Class web.Entity.CT.HOSEmpPost Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HOSEmpPost";

Property ID As %String;

/// 人员唯一标识码
Property EMPPOSTPAPersonID As %String;

/// 组织部门代码
Property EMPPOSTDeptCode As %String;

/// 岗位代码
Property EMPPOSTPOSTCode As %String;

/// 上岗日期
Property EMPPOSTBeginDate As %String;

/// 下岗日期
Property EMPPOSTRemoveDate As %String;

/// 状态   外键？？
Property EMPPOSTStatus As %String;

/// 是否默认岗位
Property EMPPOSTDefaultFlag As %String;

/// 是否有效(Y/N)
Property EMPPOSTActivity As %String;

/// 开始日期
Property EMPPOSTStartDate As %String;

/// 结束日期
Property EMPPOSTEndDate As %String;

/// 系统创建日期
Property EMPPOSTCreateDate As %String;

/// 系统创建时间
Property EMPPOSTCreateTime As %String;

/// 系统创建人
Property EMPPOSTCreateUser As %String;

/// 系统排序号
Property EMPPOSTSeqNo As %String;

/// 系统最后更新日期
Property EMPPOSTLastUpdateDate As %String;

/// 系统最后更新时间
Property EMPPOSTLastUpdateTime As %String;

/// 系统最新更新人
Property EMPPOSTLastUpdateUser As %String;

/// 拼音码
Property EMPPOSTPYCode As %String;

/// 五笔码
Property EMPPOSTWBCode As %String;

/// 备注
Property EMPPOSTMark As %String;

}
