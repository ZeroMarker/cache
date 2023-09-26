/// 描述:组织机构行政属性字典
/// 创建人：基础数据平台 zrf 
/// 创建日期：2022-11-29
Class web.Entity.CT.HOSOrgAdminType Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HOSOrgAdminType";

Property ID As %String;

/// 组织机构行政属性代码
Property ORGACCode As %String;

/// 组织机构行政属性名称
Property ORGACDesc As %String;

/// 是否有效(Y/N)
Property ORGACActivity As %String;

/// 开始日期
Property ORGACStartDate As %String;

/// 结束日期
Property ORGACEndDate As %String;

/// 系统创建日期
Property ORGACCreateDate As %String;

/// 系统创建时间
Property ORGACCreateTime As %String;

/// 系统创建人
Property ORGACCreateUser As %String;

/// 系统排序号
Property ORGACSeqNo As %String;

/// 系统最后更新日期
Property ORGACLastUpdateDate As %String;

/// 系统最后更新时间
Property ORGACLastUpdateTime As %String;

/// 系统最新更新人
Property ORGACLastUpdateUser As %String;

/// 拼音码
Property ORGACPYCode As %String;

/// 五笔码
Property ORGACWBCode As %String;

/// 备注
Property ORGACMark As %String;

}
