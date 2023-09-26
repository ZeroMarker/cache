Class web.DHCENS.STBLL.PIS.MODEL.PisAppInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "AddRisAppBillRt";

/// 检查申请单编号
Property RISRAppNum As %Library.String(MAXLEN = 20, XMLNAME = "RISRAppNum");

/// 患者主索引
Property PATPatientID As %Library.String(MAXLEN = 30, XMLNAME = "PATPatientID");

/// 就诊号码
Property PAADMVisitNumber As %Library.String(MAXLEN = 30, XMLNAME = "PAADMVisitNumber");

/// 检查注意事项
Property RISRMattersAttention As %Library.String(MAXLEN = 1000, XMLNAME = "RISRMattersAttention");

/// 检查特殊病史编码（高血压/心脏病）
Property RISRSpecalMedicalRecord As %Library.String(MAXLEN = 10, XMLNAME = "RISRSpecalMedicalRecord");

/// 检查送检医生代码
Property RISRSubmitDocCode As %Library.String(MAXLEN = 50, XMLNAME = "RISRSubmitDocCode");

/// 检查送检医生姓名
Property RISRSubmitDocDesc As %Library.String(MAXLEN = 50, XMLNAME = "RISRSubmitDocDesc");

/// 检查申请时间
Property RISRSubmitTime As %Library.String(MAXLEN = 50, XMLNAME = "RISRSubmitTime");

/// 检查接收科室代码
Property RISRAcceptDeptCode As %Library.String(MAXLEN = 50, XMLNAME = "RISRAcceptDeptCode");

/// 检查科室位置
Property RISRDeptLocation As %Library.String(MAXLEN = 100, XMLNAME = "RISRDeptLocation");

/// 检查是否加急
Property RISRISEmergency As %Library.String(MAXLEN = 10, XMLNAME = "RISRISEmergency");

/// 检查临床所见
Property RISRClinicalSymptoms As %Library.String(MAXLEN = 200, XMLNAME = "RISRClinicalSymptoms");

/// 医嘱列表
Property OrderList As list Of web.DHCENS.STBLL.PIS.MODEL.Order;

/// 最后更新人编码
Property UpdateUserCode As %Library.String(MAXLEN = 20, XMLNAME = "UpdateUserCode");

/// 最后更新日期
Property UpdateDate As %Library.String(MAXLEN = 50, XMLNAME = "UpdateDate");

/// 最后更新时间
Property UpdateTime As %Library.String(MAXLEN = 50, XMLNAME = "UpdateTime");

/// 申请科室
Property AppDeptDesc As %Library.String(MAXLEN = 50, XMLNAME = "AppDeptDesc");

/// 就诊类型代码
Property PAADMEncounterTypeCode As %Library.String(MAXLEN = 50, XMLNAME = "PAADMEncounterTypeCode");

}
