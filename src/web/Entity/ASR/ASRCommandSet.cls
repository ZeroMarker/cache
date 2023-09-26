/// 名称:语音HIS-语音命令集
/// 编写者:基础数据平台组 - 杨帆
/// 编写日期: 2020-01-09
Class web.Entity.ASR.ASRCommandSet Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.ASR.ASRCommandSet";

// RowId

Property ASRID As %String;

// 应用名

Property ASRAppName As %String;

// 公司名

Property ASRCompanyName As %String;

// 应用版本

Property ASRAppVersion As %String;

// 通信模块协议版本

Property ASRProtocolVersion As %String;

// 产商

Property ASRCompany As %String;

// 产商初始化命令串

Property ASRCompanyCmd As %String;

// 开始日期

Property ASRStartDate As %String;

// 结束日期

Property ASREndDate As %String;

// 服务路径

Property ASRServicePath As %String;

// 声纹认证分值

Property ASRVoiceprintScore As %String;

}
