/// 名称:地理信息-城市实体类
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2012-9-11
Class web.Entity.CT.CTCity Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTCity";

Property CTCITRowId As %String;

// 代码

Property CTCITCode As %String;

// 城市

Property CTCITDesc As %String;

// 开始日期

Property CTCITDateFrom As %String;

// 结束日期

Property CTCITDateTo As %String;

// 省

Property CTCITProvinceDR As %String;

// 省

Property CTCITProvinceDRDesc As %String;

/// 市级行政区罗马代码add@20220923
Property CTCITRomanCode As %String;

/// 市级行政区罗马名称
Property CTCITRomanDesc As %String;

/// 是否有效(Y/N)
Property CTCITActivity As %String;

/// 系统创建日期
Property CTCITCreateDate As %String;

/// 系统创建时间
Property CTCITCreateTime As %String;

/// 系统创建人
Property CTCITCreateUser As %String;

/// 系统排序号
Property CTCITSeqNo As %String;

/// 系统最后更新日期
Property CTCITLastUpdateDate As %String;

/// 系统最后更新时间
Property CTCITLastUpdateTime As %String;

/// 系统最新更新人
Property CTCITLastUpdateUser As %String;

/// 拼音码
Property CTCITPYCode As %String;

/// 五笔码
Property CTCITWBCode As %String;

/// 备注
Property CTCITMark As %String;

}
