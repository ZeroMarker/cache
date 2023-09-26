/// 检验结果
Class web.INSULISReportResult Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

/// 报告TS
Property TSCode As %String(CONTENT = "报告TS");

/// 项目代码
Property TestCode As %String(CONTENT = "项目代码");

/// 项目名称
Property TestName As %String(CONTENT = "项目名称");

/// 项目缩写
Property TestSync As %String(CONTENT = "项目缩写");

/// 结果
Property Result As %String(CONTENT = "结果");

/// 结果标志
Property ResFlag As %String(CONTENT = "结果标志");

/// 单位
Property Unit As %String(CONTENT = "单位");

/// 参考范围
Property Ranges As %String(CONTENT = "参考范围");

/// 检测方法
Property Method As %String(CONTENT = "检测方法");

/// 序号
Property Sequence As %String(CONTENT = "序号");

}
