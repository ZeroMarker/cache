Class CIS.AN.DTO.HIS.VitalSign Extends (CIS.AN.DTO.Abstract.Model, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLNAME = "VitalSign";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// 患者姓名
Property PatientName As %String(TRUNCATE = 1);

/// 日期时间（yyyy-MM-dd HH:mm:ss）
Property DateTime As %String(TRUNCATE = 1);

/// 体温（℃）
Property Temperature As %String(TRUNCATE = 1);

/// 脉搏（bpm）
Property Pulse As %String(TRUNCATE = 1);

/// 呼吸（次/分）
Property Breathing As %String(TRUNCATE = 1);

/// 无创收缩压（mmHg）
Property SystolicBP As %String(TRUNCATE = 1);

/// 无创舒张压（mmHg）
Property DiastolicBP As %String(TRUNCATE = 1);

/// 有创收缩压（mmHg）
Property ASBP As %String(TRUNCATE = 1);

/// 有创舒张压（mmHg）
Property ADBP As %String(TRUNCATE = 1);

/// 心率（bpm）
Property HR As %String(TRUNCATE = 1);

/// 身高（cm）
Property Height As %String(TRUNCATE = 1);

/// 体重（Kg）
Property Weight As %String(TRUNCATE = 1);

/// 出量
Property OutputQuantity As %String(TRUNCATE = 1);

/// 入量
Property InputQuantity As %String(TRUNCATE = 1);

/// 测量人编码
Property MeasureUserCode As %String(TRUNCATE = 1);

/// 测量日期，格式：yyyy-MM-DD
Property MeasureDate As %String(TRUNCATE = 1);

/// 测量时间，格式：HH:mm:ss
Property MeasureTime As %String(TRUNCATE = 1);

}
