/// 名称:机构分类大类
/// 编写者:基础数据平台组-鲁俊文
/// 编写日期: 2022-11-24
Class web.Entity.CT.HOSOrgPriCategory Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HOSOrgPriCategory";

/// RowId
Property ID As %String;

/// 机构分类大类代码	
Property OPCCode As %String;

/// 机构分类大类名称
Property OPCDesc As %String;

/// 是否有效(Y/N)
Property OPCActivity As %String;

/// 职务分类来源
Property OPCSource As %String;

/// 开始日期
Property OPCStartDate As %String;

/// 结束日期
Property OPCEndDate As %String;

/// 系统创建日期
Property OPCCreateDate As %String;

/// 系统创建时间
Property OPCCreateTime As %String;

/// 系统创建人
Property OPCCreateUser As %String;

/// 系统排序号
Property OPCSeqNo As %String;

/// 系统最后更新日期
Property OPCLastUpdateDate As %String;

/// 系统最后更新时间
Property OPCLastUpdateTime As %String;

/// 系统最新更新人
Property OPCLastUpdateUser As %String;

/// 拼音码
Property OPCPYCode As %String;

/// 五笔码
Property OPCWBCode As %String;

/// 备注
Property OPCMark As %String;

}
