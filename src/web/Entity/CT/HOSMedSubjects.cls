/// Function: HOS 医疗机构一级诊疗科目字典
/// CreateDate:2022-11-18
/// Creator:gaoshanshan
Class web.Entity.CT.HOSMedSubjects Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HOSMedSubjects";

Property ID As %String;

/// 一级诊疗科目代码
Property MSUBCode As %String;

/// 一级诊疗科目名称
Property MSUBDesc As %String;

/// 分类来源
Property MSUBSource As %String;

/// 是否有效(Y/N)
Property MSUBActivity As %String;

/// 开始日期
Property MSUBStartDate As %String;

/// 结束日期
Property MSUBEndDate As %String;

/// 系统创建日期
Property MSUBCreateDate As %String;

/// 系统创建时间
Property MSUBCreateTime As %String;

/// 系统创建人
Property MSUBCreateUser As %String;

/// 系统排序号
Property MSUBSeqNo As %String;

/// 系统最后更新日期
Property MSUBLastUpdateDate As %String;

/// 系统最后更新时间
Property MSUBLastUpdateTime As %String;

/// 系统最新更新人
Property MSUBLastUpdateUser As %String;

/// 拼音码
Property MSUBPYCode As %String;

/// 五笔码
Property MSUBWBCode As %String;

/// 备注
Property MSUBMark As %String;

}
