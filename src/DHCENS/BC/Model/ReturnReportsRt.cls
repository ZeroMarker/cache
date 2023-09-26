Class DHCENS.BC.Model.ReturnReportsRt Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "ReturnReports";

/// 医嘱号
Property Rowid As %String(MAXLEN = 32767);

/// 检查号（第三方号）	
Property StudyNo As %String(MAXLEN = 32767);

/// 取材医生
Property GetDoc As %String(MAXLEN = 32767);

/// 报告状态
Property ReportStatus As %String(MAXLEN = 32767);

/// 未发报告原因
Property UnsendCause As %String(MAXLEN = 32767);

/// 报告医生
Property ReportDoc As %String(MAXLEN = 32767);

/// 审核医生
Property AuditDoc As %String(MAXLEN = 32767);

/// 报告日期
Property ReportDate As %String(MAXLEN = 32767);

/// 审核日期
Property AuditDate As %String(MAXLEN = 32767);

/// 报告时间
Property ReportTime As %String(MAXLEN = 32767);

/// 审核时间
Property AuditTime As %String(MAXLEN = 32767);

/// 备注
Property Memo As %String(MAXLEN = 32767);

/// 图像的路径（多幅图使用@分割）
Property ImageFile As %String(MAXLEN = 32767);

/// HIS归档标记
Property HisArchiveTag As %String(MAXLEN = 32767);

/// 肉眼所见(用于病理取材)
Property EyeSee As %String(MAXLEN = 32767);

/// 检查所见
Property ExamSee As %String(MAXLEN = 32767);

/// 诊断结果
Property Diagnose As %String(MAXLEN = 32767);

}
