/// 名称:地理信息-区域实体类
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期:2012-9-10
Class web.Entity.CT.CTRegion Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTRegion";

Property CTRGRowId As %String;

// 代码

Property CTRGCode As %String;

// 区域

Property CTRGDesc As %String;

// 国家

Property CTRGCountryDR As %String;

// 国家描述

Property CTRGCountryDRDesc As %String;

}
