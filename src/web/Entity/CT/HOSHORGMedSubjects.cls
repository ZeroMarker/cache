/// Function: HOS 医疗机构诊疗科目
/// CreateDate:2022-11-21
/// Creator:gaoshanshan
Class web.Entity.CT.HOSHORGMedSubjects Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HOSHORGMedSubjects";

Property ID As %String;

/// 医疗机构代码
Property HORGMSORGCode As %String;

/// 一级诊疗科目代码
Property HORGMSMSUBCode As %String;

/// 二级诊疗科目代码
Property HORGMSMSPECCode As %String;

/// 三级诊疗科目代码
Property HORGMSMSPECICode As %String;

/// 分类来源
Property HORGMSSource As %String;

/// 是否有效(Y/N)
Property HORGMSActivity As %String;

/// 开始日期
Property HORGMSStartDate As %String;

/// 结束日期
Property HORGMSEndDate As %String;

/// 系统创建日期
Property HORGMSCreateDate As %String;

/// 系统创建时间
Property HORGMSCreateTime As %String;

/// 系统创建人
Property HORGMSCreateUser As %String;

/// 系统排序号
Property HORGMSSeqNo As %String;

/// 系统最后更新日期
Property HORGMSLastUpdateDate As %String;

/// 系统最后更新时间
Property HORGMSLastUpdateTime As %String;

/// 系统最新更新人
Property HORGMSLastUpdateUser As %String;

/// 拼音码
Property HORGMSPYCode As %String;

/// 五笔码
Property HORGMSWBCode As %String;

/// 备注
Property HORGMSMark As %String;

}
