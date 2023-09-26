/// Function: HOS 医疗机构三级诊疗科目字典
/// CreateDate:2022-11-21
/// Creator:gaoshanshan
Class web.Entity.CT.HOSMedSpecItems Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HOSMedSpecItems";

Property ID As %String;

/// 三级诊疗科目代码
Property MSPECICode As %String;

/// 三级诊疗科目名称
Property MSPECIDesc As %String;

/// 二级诊疗科目-外键
Property MSPECIMSPECCode As %String;

/// 分类来源
Property MSPECISource As %String;

/// 是否有效(Y/N)
Property MSPECIActivity As %String;

/// 开始日期
Property MSPECIStartDate As %String;

/// 结束日期
Property MSPECIEndDate As %String;

/// 系统创建日期
Property MSPECICreateDate As %String;

/// 系统创建时间
Property MSPECICreateTime As %String;

/// 系统创建人
Property MSPECICreateUser As %String;

/// 系统排序号
Property MSPECISeqNo As %String;

/// 系统最后更新日期
Property MSPECILastUpdateDate As %String;

/// 系统最后更新时间
Property MSPECILastUpdateTime As %String;

/// 系统最新更新人
Property MSPECILastUpdateUser As %String;

/// 拼音码
Property MSPECIPYCode As %String;

/// 五笔码
Property MSPECIWBCode As %String;

/// 备注
Property MSPECIMark As %String;

}
