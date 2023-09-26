/// Function: HOS 医院等级
/// CreateDate:2022-11-18
/// Creator:gaoshanshan
Class web.Entity.CT.HOSHORGGrade Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HOSHORGGrade";

Property ID As %String;

/// 医院等级代码
Property HORGGCCode As %String;

/// 医院等级名称
Property HORGGCDesc As %String;

/// 医院级别代码 
Property HORGGCGrade As %String;

/// 医院子级代码 
Property HORGGCGradeClass As %String;

/// 分类来源
Property HORGGCSource As %String;

/// 是否有效(Y/N)
Property HORGGCActivity As %String;

/// 开始日期
Property HORGGCStartDate As %String;

/// 结束日期
Property HORGGCEndDate As %String;

/// 系统创建日期
Property HORGGCCreateDate As %String;

/// 系统创建时间
Property HORGGCCreateTime As %String;

/// 系统创建人
Property HORGGCCreateUser As %String;

/// 系统排序号
Property HORGGCSeqNo As %String;

/// 系统最后更新日期
Property HORGGCLastUpdateDate As %String;

/// 系统最后更新时间
Property HORGGCLastUpdateTime As %String;

/// 系统最新更新人
Property HORGGCLastUpdateUser As %String;

/// 拼音码
Property HORGGCPYCode As %String;

/// 五笔码
Property HORGGCWBCode As %String;

/// 备注
Property HORGGCMark As %String;

}
