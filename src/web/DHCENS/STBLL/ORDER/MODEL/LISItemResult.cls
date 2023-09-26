Class web.DHCENS.STBLL.ORDER.MODEL.LISItemResult Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "LIS_ItemResult";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 序列ID
Property LISIRRowID As %Library.Integer(XMLNAME = "LISIR_RowID");

/// 报告ID
Property LISIRReportID As %Library.Integer(XMLNAME = "LISIR_ReportID");

/// 患者主索引
Property LISIRPatientID As %Library.String(MAXLEN = 30, XMLNAME = "LISIR_PatientID");

/// 化验项目代码
Property LISIRItemCode As %Library.String(MAXLEN = 20, XMLNAME = "LISIR_ItemCode");

/// 化验项目描述
Property LISIRItemDesc As %Library.String(MAXLEN = 50, XMLNAME = "LISIR_ItemDesc");

/// 结果
Property LISIRResult As %Library.String(MAXLEN = 100, XMLNAME = "LISIR_Result");

/// 单位
Property LISIRUint As %Library.String(MAXLEN = 50, XMLNAME = "LISIR_Uint");

/// 定性结果
Property LISIRTextResult As %Library.String(MAXLEN = 40, XMLNAME = "LISIR_TextResult");

/// 扩展结果
Property LISIRExtraResult As %Library.String(MAXLEN = 40, XMLNAME = "LISIR_ExtraResult");

/// 结果说明
Property LISIRResultExplain As %Library.String(MAXLEN = 100, XMLNAME = "LISIR_ResultExplain");

/// 异常标志
Property LISIRAbnormalFlags As %Library.String(MAXLEN = 5, XMLNAME = "LISIR_AbnormalFlags");

/// 参考范围
Property LISIRRanges As %Library.String(MAXLEN = 100, XMLNAME = "LISIR_Ranges");

/// 检测方法
Property LISIRTestMethod As %Library.String(MAXLEN = 20, XMLNAME = "LISIR_TestMethod");

/// 检测仪器
Property LISIRTestMachine As %Library.String(MAXLEN = 20, XMLNAME = "LISIR_TestMachine");

/// 检测人代码
Property LISIRTestUserCode As %Library.String(MAXLEN = 10, XMLNAME = "LISIR_TestUserCode");

/// 显示序号
Property LISIRShowSeq As %Library.Integer(XMLNAME = "LISIR_ShowSeq");

/// 检测日期
Property LISIRTestDate As %Library.String(XMLNAME = "LISIR_TestDate");

/// 检测时间
Property LISIRTestTime As %Library.String(XMLNAME = "LISIR_TestTime");

Property LISItemSenResult As list Of web.DHCENS.STBLL.ORDER.MODEL.LISItemSenResult(XMLNAME = "LIS_ItemSenResultList");

}
