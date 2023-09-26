/// Description：住院Demo-患者体征表
/// Table：User.DHCDSSDEMOSign
Class web.CDSSEntity.Demo.Sign Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.Demo.Sign";

/// RowId
Property RowId As %String;

/// 指向患者
Property PatDR As %String;

/// 体温
Property BodyTemperature As %String;

/// 物理降温
Property PhysicalCcooling As %String;

/// 血压
Property BloodPressure As %String;

/// 舒张压
Property DiastolicBlood As %String;

/// 收缩压
Property SystolicBlood As %String;

/// 脉搏
Property Pulse As %String;

/// 呼吸
Property BreathFeature As %String;

/// 心率
Property HeartRate As %String;

/// 血氧饱和度
Property OxygenSaturation As %String;

/// 瞳孔
Property Pupil As %String;

/// 角膜反射
Property CornealReflex As %String;

/// 身高
Property Height As %String;

/// 体重
Property Weight As %String;

/// 疼痛评分
Property PainScore As %String;

/// 大便次数
Property DefecateFreq As %String;

/// 总入量
Property TotalAmount As %String;

/// 尿量
Property UrineOutput As %String;

/// 总出量
Property TotalOutput As %String;

/// Barthel评分
Property BarthelScore As %String;

/// 测量时间
Property MeasureDate As %String;

/// 录入人员
Property Recorder As %String;

/// 病历原文
Property OriginalContent As %String;

}
