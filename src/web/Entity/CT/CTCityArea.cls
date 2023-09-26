/// 名称:地理信息-城市区域实体类
/// 编写者:基础平台组 - 陈莹
/// 编写日期:2013-12-24
Class web.Entity.CT.CTCityArea Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTCityArea";

Property CITAREARowId As %String;

// 代码

Property CITAREACode As %String;

// 城市区域/县

Property CITAREADesc As %String;

// 开始日期

Property CITAREADateFrom As %String;

// 结束日期

Property CITAREADateTo As %String;

// 市

Property CITAREACityDR As %String;

// 市

Property CITAREACityDRDesc As %String;

/// 县级行政区罗马代码add@20220923
Property CITAREARomanCode As %String;

/// 县级行政区罗马代码
Property CITAREARomanDesc As %String;

/// 是否有效(Y/N)
Property CITAREAActivity As %String;

/// 系统创建日期
Property CITAREACreateDate As %String;

/// 系统创建时间
Property CITAREACreateTime As %String;

/// 系统创建人
Property CITAREACreateUser As %String;

/// 系统排序号
Property CITAREASeqNo As %String;

/// 系统最后更新日期
Property CITAREALastUpdateDate As %String;

/// 系统最后更新时间
Property CITAREALastUpdateTime As %String;

/// 系统最新更新人
Property CITAREALastUpdateUser As %String;

/// 拼音码
Property CITAREAPYCode As %String;

/// 五笔码
Property CITAREAWBCode As %String;

/// 备注
Property CITAREAMark As %String;

}
