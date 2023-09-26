/// 名称:流程中心词
/// 编写者:基础数据平台组-鲁俊文
/// 编写日期: 2023-3-2
Class web.Entity.CT.HOSFlowHeadWord Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

/// RowId
Property ID As %String;

/// 流程中心词代码
Property FHWCode As %String;

/// 流程中心词名称
Property FHWDesc As %String;

/// 业务域代码
Property FHWDomainCode As %String;

/// 是否有效(Y/N)
Property FHWActivity As %String;

/// 开始日期
Property FHWStartDate As %String;

/// 结束日期
Property FHWEndDate As %String;

/// 系统创建日期
Property FHWCreateDate As %String;

/// 系统创建时间
Property FHWCreateTime As %String;

/// 系统创建人
Property FHWCreateUser As %String;

/// 系统排序号
Property FHWSeqNo As %String;

/// 系统最后更新日期
Property FHWLastUpdateDate As %String;

/// 系统最后更新时间
Property FHWLastUpdateTime As %String;

/// 系统最新更新人
Property FHWLastUpdateUser As %String;

/// 拼音码
Property FHWPYCode As %String;

/// 五笔码
Property FHWWBCode As %String;

/// 备注
Property FHWMark As %String;

Parameter PersistentClassName = "web.Entity.CT.HOSFlowHeadWord";

}
