/// 名称:语音HIS-语音命令集场景命令指令表
/// 编写者:基础数据平台组 - 杨帆
/// 编写日期: 2020-01-09
Class web.Entity.ASR.ASRCommandSetScenesCmd Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.ASR.ASRCommandSetScenesCmd";

// ASRCParref

Property ASRCParref As %String;

// RowId

Property ASRCID As %String;

// 是否有参数命令（Y/N）

Property ASRCIsParamCommand As %String;

// 命令名

Property ASRCCommandName As %String;

// 命令描述或表达式

Property ASRCExpression As %String;

// 参数格式

Property ASRCParamFormat As %String;

// 参数类型

Property ASRCParamType As %String;

// 触发类型

Property ASRCTriggerType As %String;

// 触发类型表达式

Property ASRCTriggerTypeExpression As %String;

/// 命令参数
Property ASRCCommandParam As %String;

/// 命令参数说明
Property ASRCParamDescription As %String;

}
