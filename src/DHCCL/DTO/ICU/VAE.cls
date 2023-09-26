/// VAE 监测，通过 VAE 判定标准，分析呼吸机相关 PEEP、FiO2 数据，监测 VAE 感染患者
Class DHCCL.DTO.ICU.VAE Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

/// 重症数据 ID
Property ICUOrderID As %String;

/// 结果类型 PEEP 或FiO2
Property ResultType As %String;

/// 日期
Property ResultDate As %String;

/// 时间
Property ResultTime As %String;

/// 记录值
Property Result As %String;

/// 记录人
Property RegUser As %String;

/// 是否有效
Property RstIsActive As %String;

}
