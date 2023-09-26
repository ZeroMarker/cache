/// 名称:职务大类代码
/// 编写者:基础数据平台组-鲁俊文
/// 编写日期: 2022-11-14
Class web.Entity.CT.HOSProfCategory Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HOSProfCategory";

/// RowId
Property ID As %String;

/// 职务标准代码	
Property PROFCCode As %String;

/// 职务标准名称
Property PROFCDesc As %String;

/// 是否有效(Y/N)
Property PROFCActivity As %String;

/// 职务分类来源
Property PROFCSource As %String;

/// 开始日期
Property PROFCStartDate As %String;

/// 结束日期
Property PROFCEndDate As %String;

/// 系统创建日期
Property PROFCCreateDate As %String;

/// 系统创建时间
Property PROFCCreateTime As %String;

/// 系统创建人
Property PROFCCreateUser As %String;

/// 系统排序号
Property PROFCSeqNo As %String;

/// 系统最后更新日期
Property PROFCLastUpdateDate As %String;

/// 系统最后更新时间
Property PROFCLastUpdateTime As %String;

/// 系统最新更新人
Property PROFCLastUpdateUser As %String;

/// 拼音码
Property PROFCPYCode As %String;

/// 五笔码
Property PROFCWBCode As %String;

/// 备注
Property PROFCMark As %String;

}
