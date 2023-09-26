/// Function: HOS 医疗机构的所有制形式
/// CreateDate:2022-11-17
/// Creator:gaoshanshan
Class web.Entity.CT.HOSHORGOwnerShip Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HOSHORGOwnerShip";

Property ID As %String;

/// 所有制形式代码
Property HORGOSCode As %String;

/// 所有制形式名称
Property HORGOSDesc As %String;

/// 分类来源
Property HORGOSSource As %String;

/// 是否有效(Y/N)
Property HORGOSActivity As %String;

/// 开始日期
Property HORGOSStartDate As %String;

/// 结束日期
Property HORGOSEndDate As %String;

/// 系统创建日期
Property HORGOSCreateDate As %String;

/// 系统创建时间
Property HORGOSCreateTime As %String;

/// 系统创建人
Property HORGOSCreateUser As %String;

/// 系统排序号
Property HORGOSSeqNo As %String;

/// 系统最后更新日期
Property HORGOSLastUpdateDate As %String;

/// 系统最后更新时间
Property HORGOSLastUpdateTime As %String;

/// 系统最新更新人
Property HORGOSLastUpdateUser As %String;

/// 拼音码
Property HORGOSPYCode As %String;

/// 五笔码
Property HORGOSWBCode As %String;

/// 备注
Property HORGOSMark As %String;

}
