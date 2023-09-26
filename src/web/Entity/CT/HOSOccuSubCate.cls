Class web.Entity.CT.HOSOccuSubCate Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.HOSOccuSubCate";

/// RowId
Property ID As %String;

/// 职业子类代码	
Property OCCUSCCode As %String;

/// 职业子类名称
Property OCCUSCDesc As %String;

/// 职业大类
Property OCCUSCOCCUCCode As %String;

/// 是否有效(Y/N)
Property OCCUSCActivity As %String;

/// 开始日期
Property OCCUSCStartDate As %String;

/// 结束日期
Property OCCUSCEndDate As %String;

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
