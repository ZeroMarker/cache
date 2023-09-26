/// 名称:岗位中心词
/// 编写者:基础数据平台组-鲁俊文
/// 编写日期: 2023-3-2
Class web.Entity.CT.HOSPostHeadWord Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

/// RowId
Property ID As %String;

/// 岗位中心词代码
Property PHWCode As %String;

/// 岗位中心词名称
Property PHWDesc As %String;

/// 业务域代码
Property PHWDomainCode As %String;

/// 是否有效(Y/N)
Property PHWActivity As %String;

/// 开始日期
Property PHWStartDate As %String;

/// 结束日期
Property PHWEndDate As %String;

/// 系统创建日期
Property PHWCreateDate As %String;

/// 系统创建时间
Property PHWCreateTime As %String;

/// 系统创建人
Property PHWCreateUser As %String;

/// 系统排序号
Property PHWSeqNo As %String;

/// 系统最后更新日期
Property PHWLastUpdateDate As %String;

/// 系统最后更新时间
Property PHWLastUpdateTime As %String;

/// 系统最新更新人
Property PHWLastUpdateUser As %String;

/// 拼音码
Property PHWPYCode As %String;

/// 五笔码
Property PHWWBCode As %String;

/// 备注
Property PHWMark As %String;

Parameter PersistentClassName = "web.Entity.CT.HOSPostHeadWord";

}
