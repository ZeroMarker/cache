/// 名称:语音HIS-语音命令集场景参数
/// 编写者:基础数据平台组 - 杨帆
/// 编写日期: 2020-01-09
Class web.Entity.ASR.ASRCommandParams Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.ASR.ASRCommandParams";

// RowId

Property ASRPID As %String;

// 场景关联

Property ASRPScenesDR As %String;

// 自定义命令名

Property ASRPCustomCommandName As %String;

// 自定义命令类型

Property ASRPCustomCommandType As %String;

// 自定义命令类型值

Property ASRPCustomCommandTypeValue As %String;

// 备注说明

Property ASRPRemark As %String;

}
