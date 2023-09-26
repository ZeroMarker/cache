/// 名称:厂商表
/// 编写者:基础数据平台-likefan
/// 编写日期: 2020-09-24
Class web.Entity.ASR.ASRCompany Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.ASR.ASRCompany";

/// RowId
Property ASRCID As %String;

/// 应用名
Property ASRCAppName As %String;

/// 公司名
Property ASRCCompanyName As %String;

/// 应用版本
Property ASRCAppVersion As %String;

/// 通信模块协议版本
Property ASRCProtocolVersion As %String;

/// 产商
Property ASRCCompany As %String;

/// 产商初始化命令串
Property ASRCCompanyCmd As %String;

/// 开始日期
Property ASRCStartDate As %String;

/// 结束日期
Property ASRCEndDate As %String;

/// 服务路径
Property ASRCServicePath As %String;

}
