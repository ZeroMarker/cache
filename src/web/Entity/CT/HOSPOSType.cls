/// Function: HOS 职位类型
/// CreateDate:2022-11-10
/// Creator:钟荣枫
Class web.Entity.CT.HOSPOSType Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HOSBusiDomain";

Property ID As %String;

/// 职位类型代码
Property POSKCode As %String;

/// 职位类型名称
Property POSKDesc As %String;

/// 是否有效(Y/N)
Property POSKActivity As %String;

/// 开始日期
Property POSKStartDate As %String;

/// 结束日期
Property POSKEndDate As %String;

/// 系统创建日期
Property POSKCreateDate As %String;

/// 系统创建时间
Property POSKCreateTime As %String;

/// 系统创建人
Property POSKCreateUser As %String;

/// 系统排序号
Property POSKSeqNo As %String;

/// 系统最后更新日期
Property POSKLastUpdateDate As %String;

/// 系统最后更新时间
Property POSKLastUpdateTime As %String;

/// 系统最新更新人
Property POSKLastUpdateUser As %String;

/// 拼音码
Property POSKPYCode As %String;

/// 五笔码
Property POSKWBCode As %String;

/// 备注
Property POSKMark As %String;

}
