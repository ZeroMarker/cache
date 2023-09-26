/// 患者就诊信息
Class BILL.EINV.DTO.COM.PatAdmInfo Extends %RegisteredObject
{

///  患者就诊编号(患者每次就诊一次就生成的一个新的编号)
Property AdmNo As %String(CAPTION = "患者就诊编号");

///  就诊科室编码
Property DepCode As %String(CAPTION = "就诊科室编码");

///  就诊科室名称
Property DepDesc As %String(CAPTION = "就诊科室名称");

///  特殊病种名称
Property SpecDesc As %String(CAPTION = "特殊病种名称");

///  出院科室编码
Property OutDepCode As %String(CAPTION = "出院科室编码");

///  出院科室名称
Property OutDepDesc As %String(CAPTION = "出院科室名称");

///  患者住院号(从入院到出院结束后，整个流程的唯一号)
Property IPNo As %String(CAPTION = "患者住院号");

///  住院就诊编号(住院期间，存在多次结算，结算后会重新生成一个住院就诊编号，如无就诊编号，可等于患者住院号)
Property AdmDr As %String(CAPTION = "住院就诊编号");

///  病历号
Property MedicalCode As %String(CAPTION = "病历号");

///  就诊日期(住院日期)(格式:yyyy-MM-dd)
Property AdmDate As %String(CAPTION = "就诊日期");

///  出院日期(格式:yyyy-MM-dd)
Property OutDate As %String(CAPTION = "出院日期");

///  住院天数 
Property IPDays As %String(CAPTION = "住院天数");

///  病区
Property WardDesc As %String(CAPTION = "病区");

///  床号
Property BedCode As %String(CAPTION = "床号");

/// add by xubaobao 2020 11 08 就诊医生
Property DocCode As %String(CAPTION = "就诊医生编码");

Property DocDesc As %String(CAPTION = "就诊医生名称");

/// 就诊时间(格式:HH:MM:SS)
Property AdmTime As %String(CAPTION = "就诊时间");

Property OutTime As %String(CAPTION = "出院日期");

}
