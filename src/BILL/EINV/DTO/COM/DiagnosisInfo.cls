/// 诊断信息对象
Class BILL.EINV.DTO.COM.DiagnosisInfo Extends %RegisteredObject
{

Property DiagnosValue As %String(CAPTION = "诊断表ID");

Property DiagnosCodeRowid As %String(CAPTION = "诊断代码表ID");

Property DiagnosICDCode As %String(CAPTION = "诊断代码表ICD代码");

Property DiagnosDesc As %String(CAPTION = "ICD诊断描述");

Property DiagnosMRDesc As %String(CAPTION = "诊断注释");

Property DiagnosType As %String(CAPTION = "诊断类型描述");

Property DiagnosDate As %String(CAPTION = "诊断日期");

Property DiagnosOnsetDate As %String(CAPTION = "发病日期");

Property DiagStat As %String(CAPTION = "诊断状态描述");

Property DiagnosLeavel As %String(CAPTION = "诊断级别(数字)");

Property InsuDiagCode As %String(CAPTION = "医保诊断编码");

Property InsuDiagDesc As %String(CAPTION = "医保诊断名称");

Property MainDiagFlag As %String(CAPTION = "是否主诊断");

}
