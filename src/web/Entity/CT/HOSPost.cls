/// Function: HOS 业务岗位
/// CreateDate:2022-11-10
/// Creator:钟荣枫
Class web.Entity.CT.HOSPost Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HOSBusiDomain";

Property ID As %String;

/// 岗位代码
Property POSTCode As %String;

/// 岗位名称
Property POSTDesc As %String;

/// 业务单元代码-外键
Property POSTBUCode As %String;

/// 岗位字典代码-外键
Property POSTPOSTCCode As %String;

/// 是否有效(Y/N)
Property POSTActivity As %String;

/// 开始日期
Property POSTStartDate As %String;

/// 结束日期
Property POSTEndDate As %String;

/// 系统创建日期
Property POSTCreateDate As %String;

/// 系统创建时间
Property POSTCreateTime As %String;

/// 系统创建人
Property POSTCreateUser As %String;

/// 系统排序号
Property POSTSeqNo As %String;

/// 系统最后更新日期
Property POSTLastUpdateDate As %String;

/// 系统最后更新时间
Property POSTLastUpdateTime As %String;

/// 系统最新更新人
Property POSTLastUpdateUser As %String;

/// 拼音码
Property POSTPYCode As %String;

/// 五笔码
Property POSTWBCode As %String;

/// 备注
Property POSTMark As %String;

/// 角色
Property POROROLECode As %String;

}
