/// 名称:职务字典代码
/// 编写者:基础数据平台组-鲁俊文
/// 编写日期: 2023-2-3
Class web.Entity.CT.HOSProfTitleDict Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

/// RowId
Property ID As %String;

/// 职务代码	
Property PROFTCCode As %String;

/// 职务名称
Property PROFTCDesc As %String;

/// 职务分类
Property PROFTCType As %String;

/// 职务等级
Property PROFTCPROFRCode As %String;

/// 职级范围
Property PROFTCRankRange As %String;

/// 是否有效(Y/N)
Property PROFTCActivity As %String;

/// 开始日期
Property PROFTCStartDate As %String;

/// 结束日期
Property PROFTCEndDate As %String;

/// 系统创建日期
Property PROFTCCreateDate As %String;

/// 系统创建时间
Property PROFTCCreateTime As %String;

/// 系统创建人
Property PROFTCCreateUser As %String;

/// 系统排序号
Property PROFTCSeqNo As %String;

/// 系统最后更新日期
Property PROFTCLastUpdateDate As %String;

/// 系统最后更新时间
Property PROFTCLastUpdateTime As %String;

/// 系统最新更新人
Property PROFTCLastUpdateUser As %String;

/// 拼音码
Property PROFTCPYCode As %String;

/// 五笔码
Property PROFTCWBCode As %String;

/// 备注
Property PROFTCMark As %String;

Parameter PersistentClassName = "web.Entity.CT.HOSProfTitleDict";

}
