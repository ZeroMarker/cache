/// 名称:语音备忘类型字典
/// 编写者:基础数据平台组 - 丁亚男
/// 编写日期: 2021-01-25
Class web.Entity.CT.CTHCCSVoiceDeviceType Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTHCCSVoiceDeviceType";

// VDTRowId

Property VDTRowId As %String;

// 代码

Property VDTCode As %String;

// 描述

Property VDTDesc As %String;

// 是否启用

Property VDTActiveFlag As %String;

// 应用类型

Property VDTType As %String;

// 备注

Property VDTRemarks As %String;

}
