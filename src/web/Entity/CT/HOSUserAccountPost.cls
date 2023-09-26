/// 描述:系统账户岗位表
/// 创建人：基础数据平台 gaoshanshan
/// 创建日期：2022-11-30
Class web.Entity.CT.HOSUserAccountPost Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HOSUserAccountPost";

Property USERPOSTRowId As %String;

/// 用户表（父表）
Property USERPOSTParRef As %String;

/// 岗位代码-外键
Property USERPOSTPostCode As %String;

/// 是否有效(Y/N)
Property USERPOSTActivity As %String;

/// 开始日期
Property USERPOSTStartDate As %String;

/// 结束日期
Property USERPOSTEndDate As %String;

/// 系统创建日期
Property USERPOSTCreateDate As %String;

/// 系统创建时间
Property USERPOSTCreateTime As %String;

/// 系统创建人
Property USERPOSTCreateUser As %String;

/// 系统排序号
Property USERPOSTSeqNo As %String;

/// 系统最后更新日期
Property USERPOSTLastUpdateDate As %String;

/// 系统最后更新时间
Property USERPOSTLastUpdateTime As %String;

/// 系统最新更新人
Property USERPOSTLastUpdateUser As %String;

/// 拼音码
Property USERPOSTPYCode As %String;

/// 五笔码
Property USERPOSTWBCode As %String;

/// 备注
Property USERPOSTMark As %String;

/// 默认标识
Property USERPOSTDefault As %String;

}
