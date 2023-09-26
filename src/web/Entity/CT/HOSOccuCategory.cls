/// 名称:职业大类字典
/// 编写者:基础数据平台组-鲁俊文
/// 编写日期: 2022-11-18
Class web.Entity.CT.HOSOccuCategory Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HOSOccuCategory";

/// RowId
Property ID As %String;

/// 职业大类代码	
Property OCCUCCode As %String;

/// 职业大类名称
Property OCCUCDesc As %String;

/// 是否有效(Y/N)
Property OCCUCActivity As %String;

/// 开始日期
Property OCCUCStartDate As %String;

/// 结束日期
Property OCCUCEndDate As %String;

/// 系统创建日期
Property OCCUCCreateDate As %String;

/// 系统创建时间
Property OCCUCCreateTime As %String;

/// 系统创建人
Property OCCUCCreateUser As %String;

/// 系统排序号
Property OCCUCSeqNo As %String;

/// 系统最后更新日期
Property OCCUCLastUpdateDate As %String;

/// 系统最后更新时间
Property OCCUCLastUpdateTime As %String;

/// 系统最新更新人
Property OCCUCLastUpdateUser As %String;

/// 拼音码
Property OCCUCPYCode As %String;

/// 五笔码
Property OCCUCWBCode As %String;

/// 备注
Property OCCUCMark As %String;

}
