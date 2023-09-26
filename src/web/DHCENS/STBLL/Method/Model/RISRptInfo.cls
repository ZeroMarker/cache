Class web.DHCENS.STBLL.Method.Model.RISRptInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "ExamReportInfo";

/// 报告号
Property RISRReportID As %Library.String(MAXLEN = 50);

/// 检查号
Property RISRExamID As %Library.String(MAXLEN = 50);

/// 医嘱ID
Property RISROrderItemID As %Library.String(MAXLEN = 100);

/// 患者ID
Property RISRPatientID As %Library.String(MAXLEN = 50);

/// 患者姓名
Property RISRPatientName As %Library.String(MAXLEN = 50);

/// 就诊类型
Property RISREncounterTypeCode As %Library.String(MAXLEN = 50);

/// 就诊科室代码
Property RISRAdmDeptCode As %Library.String(MAXLEN = 50);

/// 就诊科室名称
Property RISRAdmDeptDesc As %Library.String(MAXLEN = 50);

/// 医嘱子分类代码
Property RISROrdSubCatCode As %Library.String(MAXLEN = 50);

/// 医嘱子分类描述
Property RISROrdSubCatDesc As %Library.String(MAXLEN = 50);

/// 医嘱大类代码
Property RISROrdCatCode As %Library.String(MAXLEN = 50);

/// 医嘱大类描述
Property RISROrdCatDesc As %Library.String(MAXLEN = 50);

/// 医嘱接收科室代码
Property RISRRecDeptCode As %Library.String(MAXLEN = 50);

/// 医嘱接收科室名称
Property RISRRecDeptDesc As %Library.String(MAXLEN = 50);

/// 就诊号码
Property RISRVisitNumber As %Library.String(MAXLEN = 50);

/// 系统类型代码
Property RISRSysCode As %Library.String(MAXLEN = 30);

/// 报告医生代码 
Property RISRReportDocCode As %Library.String(MAXLEN = 50);

/// 报告医生描述
Property RISRReportDocDesc As %Library.String(MAXLEN = 100);

/// 报告日期
Property RISRReportDate As %Library.Date;

/// 报告时间
Property RISRReportTime As %Library.Time;

/// 审核医生代码
Property RISRCheckDocCode As %Library.String(MAXLEN = 50);

/// 审核医生描述
Property RISRCheckDocDesc As %Library.String(MAXLEN = 100);

/// 审核日期
Property RISRCheckDate As %Library.Date;

/// 审核时间
Property RISRCheckTime As %Library.Time;

/// 终审医生代码
Property RISRFinalCheckDocCode As %Library.String(MAXLEN = 50);

/// 终审医生描述
Property RISRFinalCheckDocDesc As %Library.String(MAXLEN = 100);

/// 终审日期
Property RISRFinalCheckDate As %Library.Date;

/// 终审时间
Property RISRFinalCheckTime As %Library.Time;

/// 检查项目描述
Property RISRItemDesc As %Library.String(MAXLEN = 128);

/// 检查部位代码
Property RISRBACode As %Library.String(MAXLEN = 50);

/// 检查部位描述
Property RISRBADesc As %Library.String(MAXLEN = 500);

/// 检查方法
Property RISRMethod As %Library.String(MAXLEN = 128);

/// 检查所见
Property RISRExamDesc As %Library.String(MAXLEN = 32000);

/// 诊断意见
Property RISRDiagDesc As %Library.String(MAXLEN = 32000);

/// ACR代码
Property RISRACRCode As %Library.String(MAXLEN = 50);

/// 报告建议
Property RISRAdviseDesc As %Library.String(MAXLEN = 1024);

/// 是否已领取
Property RISRIsGet As %Library.String(MAXLEN = 1);

/// 时间戳
Property RISRUpdateDate As %Library.Date [ InitialExpression = {$P($H,",")} ];

/// 时间戳
Property RISRUpdateTime As %Library.Time [ InitialExpression = {$P($H,",",2)} ];

/// 医嘱描述
Property RISROrderItemDesc As %String(MAXLEN = 100);

/// 图像链接
Property RISRImageSrc As %String(MAXLEN = 1000);

/// 图片报告链接
Property RISRReportImageSrc As %String(MAXLEN = 1000);

/// 是否危急
Property RISRWarnCode As %String(MAXLEN = 100);

/// 是否阳性
Property RISRIsPositive As %String(MAXLEN = 50);

/// 异常标记
Property RISRAbnormalFlags As %String(MAXLEN = 50);

/// 麻醉医师工号(扩展以下字段，用于检查中的介入性麻醉)
Property RISRAnesDocCode As %String(MAXLEN = 50);

/// 麻醉医师姓名
Property RISRAnesDocName As %String(MAXLEN = 50);

/// 麻醉方式代码
Property RISRAnesMethodCode As %String(MAXLEN = 50);

/// 麻醉方式描述
Property RISRAnesMethodDesc As %String(MAXLEN = 50);

/// 麻醉分级代码
Property RISRAnesLevelCode As %String(MAXLEN = 50);

/// 麻醉分级描述
Property RISRAnesLevelDesc As %String(MAXLEN = 50);

/// 麻醉开始时间
Property RISRAnesStartDateTime As %String(MAXLEN = 50);

/// 麻醉结束时间
Property RISRAnesEndDateTime As %String(MAXLEN = 50);

/// 冰冻号(病理)
Property RISRSliceFrozenNo As %String(MAXLEN = 50);

/// 送检材料(病理)
Property RISRInspMaterials As %String(MAXLEN = 50);

/// 免疫组化(病理)
Property RISRImmuneGrpNo As %String(MAXLEN = 50);

Property RISRItemResultList As list Of web.DHCENS.STBLL.Method.Model.RISRItemResult(XMLNAME = "RISRItemResult", XMLPROJECTION = "ELEMENT");

}
