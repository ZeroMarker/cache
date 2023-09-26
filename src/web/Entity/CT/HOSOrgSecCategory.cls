/// 名称:机构分类中类
/// 编写者:基础数据平台组-鲁俊文
/// 编写日期: 2022-11-24
Class web.Entity.CT.HOSOrgSecCategory Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HOSOrgSecCategory";

/// RowId
Property ID As %String;

/// 父表ID
Property PriCategoryParRef As %String;

/// 机构分类中类代码	
Property OSCCode As %String;

/// 机构分类中类名称
Property OSCDesc As %String;

/// 分类来源
Property OSCSource As %String;

/// 是否有效(Y/N)
Property OSCActivity As %String;

/// 开始日期
Property OSCStartDate As %String;

/// 结束日期
Property OSCEndDate As %String;

/// 系统创建日期
Property OSCCreateDate As %String;

/// 系统创建时间
Property OSCCreateTime As %String;

/// 系统创建人
Property OSCCreateUser As %String;

/// 系统排序号
Property OSCSeqNo As %String;

/// 系统最后更新日期
Property OSCLastUpdateDate As %String;

/// 系统最后更新时间
Property OSCLastUpdateTime As %String;

/// 系统最新更新人
Property OSCLastUpdateUser As %String;

/// 拼音码
Property OSCPYCode As %String;

/// 五笔码
Property OSCWBCode As %String;

/// 备注
Property OSCMark As %String;

}
