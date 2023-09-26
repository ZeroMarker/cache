/// 名称:职务等级代码
/// 编写者:基础数据平台组-鲁俊文
/// 编写日期: 2022-11-11
Class web.Entity.CT.HOSProfRank Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

/// RowId
Property ID As %String;

/// 职务等级代码	
Property PROFRCode As %String;

/// 职务等级名称
Property PROFRDesc As %String;

/// 职务等级
Property PROFRRankValue As %String;

/// 是否有效(Y/N)
Property PROFRActivity As %String;

/// 开始日期
Property PROFRStartDate As %String;

/// 结束日期
Property PROFREndDate As %String;

/// 系统创建日期
Property PROFRCreateDate As %String;

/// 系统创建时间
Property PROFRCreateTime As %String;

/// 系统创建人
Property PROFRCreateUser As %String;

/// 系统排序号
Property PROFRSeqNo As %String;

/// 系统最后更新日期
Property PROFRLastUpdateDate As %String;

/// 系统最后更新时间
Property PROFRLastUpdateTime As %String;

/// 系统最新更新人
Property PROFRLastUpdateUser As %String;

/// 拼音码
Property PROFRPYCode As %String;

/// 五笔码
Property PROFRWBCode As %String;

/// 备注
Property PROFRMark As %String;

Parameter PersistentClassName = "web.Entity.CT.HOSProfRank";

}
