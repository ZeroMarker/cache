/// Function: HOS 业务域
/// CreateDate:2022-11-10
/// Creator:钟荣枫
Class web.Entity.CT.HOSBusiDomain Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HOSBusiDomain";

Property ID As %String;

/// 业务域代码
Property DomainCode As %String;

/// 业务域名称
Property DomainDesc As %String;

/// 父级业务域代码-外键
Property DomainParentCode As %String;

/// 业务域层级
Property DomainLevel As %String;

/// 是否有效(Y/N)
Property DomainActivity As %String;

/// 开始日期
Property DomainStartDate As %String;

/// 结束日期
Property DomainEndDate As %String;

/// 系统创建日期
Property DomainCreateDate As %String;

/// 系统创建时间
Property DomainCreateTime As %String;

/// 系统创建人
Property DomainCreateUser As %String;

/// 系统排序号
Property DomainSeqNo As %String;

/// 系统最后更新日期
Property DomainLastUpdateDate As %String;

/// 系统最后更新时间
Property DomainLastUpdateTime As %String;

/// 系统最新更新人
Property DomainLastUpdateUser As %String;

/// 拼音码
Property DomainPYCode As %String;

/// 五笔码
Property DomainWBCode As %String;

/// 备注
Property DomainMark As %String;

}
