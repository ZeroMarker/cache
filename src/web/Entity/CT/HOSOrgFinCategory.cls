/// 名称:机构小类
/// 编写者:基础数据平台组-鲁俊文
/// 编写日期: 2022-11-25
Class web.Entity.CT.HOSOrgFinCategory Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HOSOrgFinCategory";

/// RowId
Property ID As %String;

/// 父表ID
Property SecCategoryParRef As %String;

/// 机构小类代码	
Property OFCCode As %String;

/// 机构小类名称
Property OFCDesc As %String;

/// 注释
Property OFCComments As %String;

/// 分类来源
Property OFCSource As %String;

/// 是否有效(Y/N)
Property OFCActivity As %String;

/// 开始日期
Property OFCStartDate As %String;

/// 结束日期
Property OFCEndDate As %String;

/// 系统创建日期
Property OFCCreateDate As %String;

/// 系统创建时间
Property OFCCreateTime As %String;

/// 系统创建人
Property OFCCreateUser As %String;

/// 系统排序号
Property OFCSeqNo As %String;

/// 系统最后更新日期
Property OFCLastUpdateDate As %String;

/// 系统最后更新时间
Property OFCLastUpdateTime As %String;

/// 系统最新更新人
Property OFCLastUpdateUser As %String;

/// 拼音码
Property OFCPYCode As %String;

/// 五笔码
Property OFCWBCode As %String;

/// 备注
Property OFCMark As %String;

}
