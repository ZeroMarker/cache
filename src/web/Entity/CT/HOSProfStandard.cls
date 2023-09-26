/// 名称:职务标准代码
/// 编写者:基础数据平台组-鲁俊文
/// 编写日期: 2022-11-14
Class web.Entity.CT.HOSProfStandard Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HOSProfStandard";

/// RowId
Property ID As %String;

/// 职务标准代码	
Property PROFSCode As %String;

/// 职务标准名称
Property PROFSDesc As %String;

/// 是否有效(Y/N)
Property PROFSActivity As %String;

/// 开始日期
Property PROFSStartDate As %String;

/// 结束日期
Property PROFSEndDate As %String;

/// 系统创建日期
Property PROFSCreateDate As %String;

/// 系统创建时间
Property PROFSCreateTime As %String;

/// 系统创建人
Property PROFSCreateUser As %String;

/// 系统排序号
Property PROFSSeqNo As %String;

/// 系统最后更新日期
Property PROFSLastUpdateDate As %String;

/// 系统最后更新时间
Property PROFSLastUpdateTime As %String;

/// 系统最新更新人
Property PROFSLastUpdateUser As %String;

/// 拼音码
Property PROFSPYCode As %String;

/// 五笔码
Property PROFSWBCode As %String;

/// 备注
Property PROFSMark As %String;

}
