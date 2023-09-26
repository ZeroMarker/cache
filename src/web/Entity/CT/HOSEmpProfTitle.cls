/// Function: HOS 人员职务表
/// CreateDate:2022-11-15
/// Creator:gaoshanshan
Class web.Entity.CT.HOSEmpProfTitle Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HOSEmpProfTitle";

Property ID As %String;

///  人员唯一标识码
Property EMPPROFPAPersonID As %String;

///  组织部门代码
Property EMPPROFDeptCode As %String;

/// 部门职务代码
Property EMPPROFPROFTCode As %String;

/// 聘用日期
Property EMPPROFEngageDate As %String;

/// 解聘日期
Property EMPPROFRemoveDate As %String;

/// 任职状态 -外键？？
Property EMPPROFStatus As %String;

/// 是否有效(Y/N)
Property EMPPROFActivity As %String;

/// 开始日期
Property EMPPROFStartDate As %String;

/// 结束日期
Property EMPPROFEndDate As %String;

/// 系统创建日期
Property EMPPROFCreateDate As %String;

/// 系统创建时间
Property EMPPROFCreateTime As %String;

/// 系统创建人
Property EMPPROFCreateUser As %String;

/// 系统排序号
Property EMPPROFSeqNo As %String;

/// 系统最后更新日期
Property EMPPROFLastUpdateDate As %String;

/// 系统最后更新时间
Property EMPPROFLastUpdateTime As %String;

/// 系统最新更新人
Property EMPPROFLastUpdateUser As %String;

/// 拼音码
Property EMPPROFPYCode As %String;

/// 五笔码
Property EMPPROFWBCode As %String;

/// 备注
Property EMPPROFMark As %String;

}
