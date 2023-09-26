/// 名称:地理信息-邮编实体类
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期:2012-9-12
Class web.Entity.CT.CTZip Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTZip";

Property CTZIPRowId As %String;

// 代码

Property CTZIPCode As %String;

// 邮编

Property CTZIPDesc As %String;

// 区域

Property CTZIPRegionDR As %String;

// 省

Property CTZIPProvinceDR As %String;

// 健康监护区域

Property CTZIPHCADR As %String;

// 城市

Property CTZIPCITYDR As %String;

// 城市区域

Property CTZIPCITYAREADR As %String;

// 开始日期

Property CTZIPDateFrom As %String;

// 结束日期

Property CTZIPDateTo As %String;

// 区域描述

Property CTZIPRegionDRDesc As %String;

// 省描述

Property CTZIPProvinceDRDesc As %String;

// 城市描述

Property CTZIPCITYDRDesc As %String;

// 城市区域描述

Property CTZIPCITYAREADRDesc As %String;

}
