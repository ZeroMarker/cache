/// Function: HOS 组织级次
/// CreateDate:2022-11-10
/// Creator:钟荣枫
Class web.Entity.CT.HOSORGHierarchy Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HOSORGHierarchy";

Property ID As %String;

/// 组织层级代码
Property ORGHCode As %String;

/// 组织层级名称
Property ORGHDesc As %String;

/// 组织层级数值
Property ORGHHierarchyValue As %String;

/// 是否有效(Y/N)
Property ORGHActivity As %String;

/// 开始日期
Property ORGHStartDate As %String;

/// 结束日期
Property ORGHEndDate As %String;

/// 系统创建日期
Property ORGHCreateDate As %String;

/// 系统创建时间
Property ORGHCreateTime As %String;

/// 系统创建人
Property ORGHCreateUser As %String;

/// 系统排序号
Property ORGHSeqNo As %String;

/// 系统最后更新日期
Property ORGHLastUpdateDate As %String;

/// 系统最后更新时间
Property ORGHLastUpdateTime As %String;

/// 系统最新更新人
Property ORGHLastUpdateUser As %String;

/// 拼音码
Property ORGHPYCode As %String;

/// 五笔码
Property ORGHWBCode As %String;

/// 备注
Property ORGHMark As %String;

}
