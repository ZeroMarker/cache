/// 名称:岗位类型
/// 编写者:基础数据平台组-鲁俊文
/// 编写日期: 2023-3-2
Class web.Entity.CT.HOSPostType Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HOSPostType";

/// RowId
Property ID As %String;

/// 岗位类型代码
Property PTCode As %String;

/// 岗位类型名称
Property PTDesc As %String;

/// 是否有效(Y/N)
Property PTActivity As %String;

/// 开始日期
Property PTStartDate As %String;

/// 结束日期
Property PTEndDate As %String;

/// 系统创建日期
Property PTCreateDate As %String;

/// 系统创建时间
Property PTCreateTime As %String;

/// 系统创建人
Property PTCreateUser As %String;

/// 系统排序号
Property PTSeqNo As %String;

/// 系统最后更新日期
Property PTLastUpdateDate As %String;

/// 系统最后更新时间
Property PTLastUpdateTime As %String;

/// 系统最新更新人
Property PTLastUpdateUser As %String;

/// 拼音码
Property PTPYCode As %String;

/// 五笔码
Property PTWBCode As %String;

/// 备注
Property PTMark As %String;

}
