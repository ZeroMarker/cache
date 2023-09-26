/// 名称:语音HIS-语音命令集场景
/// 编写者:基础数据平台组 - 杨帆
/// 编写日期: 2020-01-09
Class web.Entity.ASR.CommandSetScenes Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.ASR.CommandSetScenes";

// ASRCParref

Property ASRSParRef As %String;

// ASRSID

Property ASRSID As %String;

// 场景

Property ASRSScenes As %String;

// 场景命令名

Property ASRSScenesCommandName As %String;

// 有效标识（Y/N）

Property ASRSActiveFlag As %String;

// 备注说明

Property ASRSRemark As %String;

}
