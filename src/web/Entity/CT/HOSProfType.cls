/// 名称:职务类型代码
/// 编写者:基础数据平台组-鲁俊文
/// 编写日期: 2022-11-11
Class web.Entity.CT.HOSProfType Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HOSProfType";

/// RowId
Property ID As %String;

/// 职务类型代码	
Property PROFTYCode As %String;

/// 职务类型名称
Property PROFTYDesc As %String;

/// 是否有效(Y/N)
Property PROFTYActivity As %String;

/// 开始日期
Property PROFTYStartDate As %String;

/// 结束日期
Property PROFTYEndDate As %String;

/// 系统创建日期
Property PROFTYCreateDate As %String;

/// 系统创建时间
Property PROFTYCreateTime As %String;

/// 系统创建人
Property PROFTYCreateUser As %String;

/// 系统排序号
Property PROFTYSeqNo As %String;

/// 系统最后更新日期
Property PROFTYLastUpdateDate As %String;

/// 系统最后更新时间
Property PROFTYLastUpdateTime As %String;

/// 系统最新更新人
Property PROFTYLastUpdateUser As %String;

/// 拼音码
Property PROFTYPYCode As %String;

/// 五笔码
Property PROFTYWBCode As %String;

/// 备注
Property PROFTYMark As %String;

}
