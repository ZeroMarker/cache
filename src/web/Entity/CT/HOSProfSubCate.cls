/// 名称:职务子类代码
/// 编写者:基础数据平台组-鲁俊文
/// 编写日期: 2022-11-11
Class web.Entity.CT.HOSProfSubCate Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HOSProfSubCate";

/// RowId
Property ID As %String;

/// 父表ID
Property CategoryParRef As %String;

/// 职务子类代码	
Property PROFSCCode As %String;

/// 职务子类名称
Property PROFSCDesc As %String;

/// 分类来源
Property PROFSCSource As %String;

/// 是否有效(Y/N)
Property PROFSCActivity As %String;

/// 开始日期
Property PROFSCStartDate As %String;

/// 结束日期
Property PROFSCEndDate As %String;

/// 系统创建日期
Property PROFSCCreateDate As %String;

/// 系统创建时间
Property PROFSCCreateTime As %String;

/// 系统创建人
Property PROFSCCreateUser As %String;

/// 系统排序号
Property PROFSCSeqNo As %String;

/// 系统最后更新日期
Property PROFSCLastUpdateDate As %String;

/// 系统最后更新时间
Property PROFSCLastUpdateTime As %String;

/// 系统最新更新人
Property PROFSCLastUpdateUser As %String;

/// 拼音码
Property PROFSCPYCode As %String;

/// 五笔码
Property PROFSCWBCode As %String;

/// 备注
Property PROFSCMark As %String;

}
