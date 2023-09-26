/// 细菌结果
Class web.INSULISReportResultGerm Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

/// 细菌报告TS
Property TSCode As %String(CONTENT = "细菌报告TS");

/// 项目代码
Property TestCode As %String(CONTENT = "项目代码(细菌)");

/// 项目名称
Property TestName As %String(CONTENT = "项目名称(细菌)");

/// 项目缩写
Property TestSync As %String(CONTENT = "项目缩写(细菌)");

/// 结果
Property Result As %String(CONTENT = "结果(细菌)");

/// 结果标志
Property ResFlag As %String(CONTENT = "结果标志(细菌)");

/// 单位
Property Unit As %String(CONTENT = "单位(细菌)");

/// 参考范围
Property Ranges As %String(CONTENT = "参考范围(细菌)");

/// 检测方法
Property Method As %String(CONTENT = "检测方法(细菌)");

/// 序号
Property Sequence As %String(CONTENT = "序号(细菌)");

/// 药敏结果
Property ResultSenDetails As list Of web.INSULISReportResultSen;

}
