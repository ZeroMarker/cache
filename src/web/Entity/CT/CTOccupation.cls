/// 名称: 职业维护
/// 描述: 实体类
/// 编写者：基础数据平台组-李森
/// 编写日期: 2012-8-31
Class web.Entity.CT.CTOccupation Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTOccupation";

/// RowId号
Property CTOCCRowId As %String;

/// 代码
Property CTOCCCode As %String;

/// 描述
Property CTOCCDesc As %String;

/// 开始日期
Property CTOCCDateFrom As %String;

/// 结束日期
Property CTOCCDateTo As %String;

/// 职业大类-外键
Property OCCUOCCUCCode As %String;

/// 是否有效(Y/N)
Property OCCUSCActivity As %String;

/// 系统创建日期
Property OCCUSCCreateDate As %String;

/// 系统创建时间
Property OCCUSCCreateTime As %String;

/// 系统创建人
Property OCCUSCCreateUser As %String;

/// 系统排序号
Property OCCUSCSeqNo As %String;

/// 系统最后更新日期
Property OCCUSCLastUpdateDate As %String;

/// 系统最后更新时间
Property OCCUSCLastUpdateTime As %String;

/// 系统最新更新人
Property OCCUSCLastUpdateUser As %String;

/// 拼音码
Property OCCUSCPYCode As %String;

/// 五笔码
Property OCCUSCWBCode As %String;

/// 备注
Property OCCUSCMark As %String;

}
