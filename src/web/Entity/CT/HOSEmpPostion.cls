/// Function: HOS 人员职位表
/// CreateDate:2022-11-14
/// Creator:gaoshanshan
Class web.Entity.CT.HOSEmpPostion Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HOSEmpPostion";

Property ID As %String;

/// 人员唯一标识码
Property EMPPOSPAPersonID As %String;

/// 组织部门代码
Property EMPPOSDeptCode As %String;

/// 职位代码
Property EMPPOSPOSCode As %String;

/// 任职日期
Property EMPPOSAppointDate As %String;

/// 免职日期
Property EMPPOSRemoveDate As %String;

/// 任职状态 是否在职
Property EMPPOSStatus As %String;

/// 是否行政归属部门
Property EMPPOSAdminFlag As %String;

/// 是否有效(Y/N)
Property EMPPOSActivity As %String;

/// 开始日期
Property EMPPOSStartDate As %String;

/// 结束日期
Property EMPPOSEndDate As %String;

/// 系统创建日期
Property EMPPOSCreateDate As %String;

/// 系统创建时间
Property EMPPOSCreateTime As %String;

/// 系统创建人
Property EMPPOSCreateUser As %String;

/// 系统排序号
Property EMPPOSSeqNo As %String;

/// 系统最后更新日期
Property EMPPOSLastUpdateDate As %String;

/// 系统最后更新时间
Property EMPPOSLastUpdateTime As %String;

/// 系统最新更新人
Property EMPPOSLastUpdateUser As %String;

/// 拼音码
Property EMPPOSPYCode As %String;

/// 五笔码
Property EMPPOSWBCode As %String;

/// 备注
Property EMPPOSMark As %String;

}
