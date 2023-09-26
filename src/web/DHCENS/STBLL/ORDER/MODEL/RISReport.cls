Class web.DHCENS.STBLL.ORDER.MODEL.RISReport Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "RIS_Report";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 报告号
Property RISRReportID As %Library.Integer(XMLNAME = "RISR_ReportID");

/// 检查号
Property RISRExamID As %Library.String(MAXLEN = 30, XMLNAME = "RISR_ExamID");

/// 报告医生代码
Property RISRReportDocCode As %Library.String(MAXLEN = 10, XMLNAME = "RISR_ReportDocCode");

/// 报告日期
Property RISRReportDate As %Library.String(XMLNAME = "RISR_ReportDate");

/// 报告时间
Property RISRReportTime As %Library.String(XMLNAME = "RISR_ReportTime");

/// 审核医生代码
Property RISRCheckDocCode As %Library.String(MAXLEN = 10, XMLNAME = "RISR_CheckDocCode");

/// 审核日期
Property RISRCheckDate As %Library.String(XMLNAME = "RISR_CheckDate");

/// 审核时间
Property RISRCheckTime As %Library.String(XMLNAME = "RISR_CheckTime");

/// 终审医生代码
Property RISRFinalCheckDocCode As %Library.String(MAXLEN = 10, XMLNAME = "RISR_FinalCheckDocCode");

/// 终审日期
Property RISRFinalCheckDate As %Library.String(XMLNAME = "RISR_FinalCheckDate");

/// 终审时间
Property RISRFinalCheckTime As %Library.String(XMLNAME = "RISR_FinalCheckTime");

/// 检查项目描述
Property RISRItemDesc As %Library.String(MAXLEN = 128, XMLNAME = "RISR_ItemDesc");

/// 检查方法
Property RISRMethod As %Library.String(MAXLEN = 128, XMLNAME = "RISR_Method");

/// 检查所见
Property RISRExamDesc As %Library.String(MAXLEN = 1024, XMLNAME = "RISR_ExamDesc");

/// 诊断意见
Property RISRDiagDesc As %Library.String(MAXLEN = 512, XMLNAME = "RISR_DiagDesc");

/// ARC代码
Property RISRACRCode As %Library.String(MAXLEN = 16, XMLNAME = "RISR_ACRCode");

/// 报告内容
Property RISRContentXml As %Library.GlobalCharacterStream(XMLNAME = "RISR_ContentXml");

/// 报告内容PDF
Property RISRContentPdf As %Library.GlobalCharacterStream(XMLNAME = "RISR_ContentPdf");

/// 报告建议
Property RISRAdviseDesc As %Library.String(MAXLEN = 128, XMLNAME = "RISR_AdviseDesc");

/// 是否已领取
Property RISRIsGet As %Library.String(MAXLEN = 1, XMLNAME = "RISR_IsGet");

/// 医嘱ID
Property RISOOrderItemID As %Library.String(MAXLEN = 128, XMLNAME = "RISO_OrderItemID");

}
