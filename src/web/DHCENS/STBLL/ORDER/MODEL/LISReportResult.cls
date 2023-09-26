Class web.DHCENS.STBLL.ORDER.MODEL.LISReportResult Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "LIS_ReportResult";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 报告ID
Property LISRRReportID As %Library.String(MAXLEN = 50, XMLNAME = "LISRR_ReportID");

/// 样本号
Property LISSRSpecimenID As %Library.String(MAXLEN = 50, XMLNAME = "LISRR_SpecimenID");

/// 就诊号
Property LISRRVisitNumber As %Library.String(MAXLEN = 50, XMLNAME = "LISRR_VisitNumber");

/// 报告科室代码
Property LISRRReportDeptCode As %Library.String(MAXLEN = 50, XMLNAME = "LISRR_ReportDeptCode");

/// 初审日期
Property LISRRFirstCheckDate As %Library.String(XMLNAME = "LISRR_FirstCheckDate");

/// 初审时间
Property LISRRFirstCheckTime As %Library.String(XMLNAME = "LISRR_FirstCheckTime");

/// 初审医生代码
Property LISRRFirstCheckUserCode As %Library.String(MAXLEN = 10, XMLNAME = "LISRR_FirstCheckUserCode");

/// 审核日期
Property LISRRCheckDate As %Library.String(XMLNAME = "LISRR_CheckDate");

/// 审核时间
Property LISRRCheckTime As %Library.String(XMLNAME = "LISRR_CheckTime");

/// 审核医生代码
Property LISRRCheckUserCode As %Library.String(MAXLEN = 10, XMLNAME = "LISRR_CheckUserCode");

/// 上机日期
Property LISRRMachineDate As %Library.String(XMLNAME = "LISRR_MachineDate");

/// 上机时间
Property LISRRMachineTime As %Library.String(XMLNAME = "LISRR_MachineTime");

/// 检测日期
Property LISRRTestDate As %Library.String(XMLNAME = "LISRR_TestDate");

/// 检测时间
Property LISRRTestTime As %Library.String(XMLNAME = "LISRR_TestTime");

/// 作废日期
Property LISRRCancelDate As %Library.String(XMLNAME = "LISRR_CancelDate");

/// 作废时间
Property LISRRCancelTime As %Library.String(XMLNAME = "LISRR_CancelTime");

/// 作废医生代码
Property LISRRCancelUserCode As %Library.String(MAXLEN = 10, XMLNAME = "LISRR_CancelUserCode");

/// 作废原因
Property LISRRCancelReason As %Library.String(MAXLEN = 100, XMLNAME = "LISRR_CancelReason");

/// 报告内容Xml
Property LISRRReprotXml As %Library.GlobalCharacterStream(XMLNAME = "LISRR_ReprotXml");

/// 报告内容Pdf
Property LISRRReprotPdf As %Library.GlobalCharacterStream(XMLNAME = "LISRR_ReprotPdf");

/// 报告类型
Property LISRRReprotType As %Library.String(MAXLEN = 4, XMLNAME = "LISRR_ReprotType");

/// 备注
Property LISRRRemarks As %Library.String(MAXLEN = 100, XMLNAME = "LISRR_Remarks");

Property LISItemResultList As list Of web.DHCENS.STBLL.ORDER.MODEL.LISItemResult(XMLNAME = "LIS_ItemResultList");

}
