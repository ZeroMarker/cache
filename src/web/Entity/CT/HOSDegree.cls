/// Function: HOS 学位代码
/// CreateDate:2023-02-07
/// Creator:gaoshanshan
Class web.Entity.CT.HOSDegree Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ Not ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HOSDegree";

Property ID As %String;

/// 学位代码
Property DEGCode As %String;

/// 学位名称
Property DEGDesc As %String;

/// 是否有效(Y/N)
Property DEGActivity As %String;

/// 开始日期
Property DEGStartDate As %String;

/// 结束日期
Property DEGEndDate As %String;

/// 系统创建日期
Property DEGCreateDate As %String;

/// 系统创建时间
Property DEGCreateTime As %String;

/// 系统创建人
Property DEGCreateUser As %String;

/// 系统排序号
Property DEGSeqNo As %String;

/// 系统最后更新日期
Property DEGLastUpdateDate As %String;

/// 系统最后更新时间
Property DEGLastUpdateTime As %String;

/// 系统最新更新人
Property DEGLastUpdateUser As %String;

/// 拼音码
Property DEGPYCode As %String;

/// 五笔码
Property DEGWBCode As %String;

/// 备注
Property DEGMark As %String;

}
