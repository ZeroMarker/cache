/// 名称:职务专业代码
/// 编写者:基础数据平台组-鲁俊文
/// 编写日期: 2022-11-15
Class web.Entity.CT.HOSProfMajor Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HOSProfMajor";

/// RowId
Property ID As %String;

/// 父表ID
Property SubCateParRef As %String;

/// 职务专业代码	
Property PROFMCode As %String;

/// 职务专业名称
Property PROFMDesc As %String;

/// 分类来源
Property PROFMSource As %String;

/// 是否有效(Y/N)
Property PROFMActivity As %String;

/// 开始日期
Property PROFMStartDate As %String;

/// 结束日期
Property PROFMEndDate As %String;

/// 系统创建日期
Property PROFMCreateDate As %String;

/// 系统创建时间
Property PROFMCreateTime As %String;

/// 系统创建人
Property PROFMCreateUser As %String;

/// 系统排序号
Property PROFMSeqNo As %String;

/// 系统最后更新日期
Property PROFMLastUpdateDate As %String;

/// 系统最后更新时间
Property PROFMLastUpdateTime As %String;

/// 系统最新更新人
Property PROFMLastUpdateUser As %String;

/// 拼音码
Property PROFMPYCode As %String;

/// 五笔码
Property PROFMWBCode As %String;

/// 备注
Property PROFMMark As %String;

}
