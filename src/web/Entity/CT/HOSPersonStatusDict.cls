Class web.Entity.CT.HOSPersonStatusDict Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HOSPersonStatusDict";

/// RowId
Property ID As %String;

/// 人员状态代码
Property PSDCode As %String;

/// 人员状态名称
Property PSDDesc As %String;

/// 是否有效(Y/N)
Property PSDActivity As %String;

/// 开始日期
Property PSDStartDate As %String;

/// 结束日期
Property PSDEndDate As %String;

/// 系统创建日期
Property PSDCreateDate As %String;

/// 系统创建时间
Property PSDCreateTime As %String;

/// 系统创建人
Property PSDCreateUser As %String;

/// 系统排序号
Property PSDSeqNo As %String;

/// 系统最后更新日期
Property PSDLastUpdateDate As %String;

/// 系统最后更新时间
Property PSDLastUpdateTime As %String;

/// 系统最新更新人
Property PSDLastUpdateUser As %String;

/// 拼音码
Property PSDPYCode As %String;

/// 五笔码
Property PSDWBCode As %String;

/// 备注
Property PSDMark As %String;

}
