/// Function: HOS 医疗机构二级诊疗科目字典
/// CreateDate:2022-11-18
/// Creator:gaoshanshan
Class web.Entity.CT.HOSMedSpecialties Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HOSMedSpecialties";

Property ID As %String;

/// 二级诊疗科目代码
Property MSPECCode As %String;

/// 二级诊疗科目名称
Property MSPECDesc As %String;

/// 一级诊疗科目-外键
Property MSPECMSUBCode As %String;

/// 分类来源
Property MSPECSource As %String;

/// 是否有效(Y/N)
Property MSPECActivity As %String;

/// 开始日期
Property MSPECStartDate As %String;

/// 结束日期
Property MSPECEndDate As %String;

/// 系统创建日期
Property MSPECCreateDate As %String;

/// 系统创建时间
Property MSPECCreateTime As %String;

/// 系统创建人
Property MSPECCreateUser As %String;

/// 系统排序号
Property MSPECSeqNo As %String;

/// 系统最后更新日期
Property MSPECLastUpdateDate As %String;

/// 系统最后更新时间
Property MSPECLastUpdateTime As %String;

/// 系统最新更新人
Property MSPECLastUpdateUser As %String;

/// 拼音码
Property MSPECPYCode As %String;

/// 五笔码
Property MSPECWBCode As %String;

/// 备注
Property MSPECMark As %String;

}
