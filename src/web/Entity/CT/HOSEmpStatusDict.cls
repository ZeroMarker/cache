Class web.Entity.CT.HOSEmpStatusDict Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

/// RowId
Property ID As %String;

/// 人员状态代码
Property ESDCode As %String;

/// 人员状态名称
Property ESDDesc As %String;

/// 是否有效(Y/N)
Property ESDActivity As %String;

/// 开始日期
Property ESDStartDate As %String;

/// 结束日期
Property ESDEndDate As %String;

/// 系统创建日期
Property ESDCreateDate As %String;

/// 系统创建时间
Property ESDCreateTime As %String;

/// 系统创建人
Property ESDCreateUser As %String;

/// 系统排序号
Property ESDSeqNo As %String;

/// 系统最后更新日期
Property ESDLastUpdateDate As %String;

/// 系统最后更新时间
Property ESDLastUpdateTime As %String;

/// 系统最新更新人
Property ESDLastUpdateUser As %String;

/// 拼音码
Property ESDPYCode As %String;

/// 五笔码
Property ESDWBCode As %String;

/// 备注
Property ESDMark As %String;

Parameter PersistentClassName = "web.Entity.CT.HOSEmpStatusDict";

}
