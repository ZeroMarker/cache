Class web.DHCENS.STBLL.RIS.MODEL.RisAppInfo Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "AddRisAppBillRt";

/// 检查号^医嘱号(主要格式转换需要)
Property Input As %Library.String(MAXLEN = 30, XMLNAME = "Input");

/// 检查申请单编号
Property RISRAppNum As %Library.String(MAXLEN = 20, XMLNAME = "RISRAppNum");

/// 检查号
Property RISRExamID As %Library.String(MAXLEN = 20, XMLNAME = "RISRExamID");

/// 患者主索引
Property PATPatientID As %Library.String(MAXLEN = 30, XMLNAME = "PATPatientID");

/// 就诊号码
Property PAADMVisitNumber As %Library.String(MAXLEN = 30, XMLNAME = "PAADMVisitNumber");

/// 就诊类型代码
Property PAADMEncounterTypeCode As %Library.String(MAXLEN = 30, XMLNAME = "PAADMEncounterTypeCode");

/// 入院病区描述
Property PAADMAdmWardCode As %Library.String(MAXLEN = 30, XMLNAME = "PAADMAdmWardCode");

/// 入院病区描述
Property PAADMAdmWardDesc As %Library.String(MAXLEN = 30, XMLNAME = "PAADMAdmWardDesc");

/// 病床号
Property PAADMCurBedNo As %Library.String(MAXLEN = 30, XMLNAME = "PAADMCurBedNo");

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
Property OrderList As list Of web.DHCENS.STBLL.RIS.MODEL.Order;

/// 最后更新人编码
Property UpdateUserCode As %Library.String(MAXLEN = 20, XMLNAME = "UpdateUserCode");

/// 最后更新日期
Property UpdateDate As %Library.String(MAXLEN = 50, XMLNAME = "UpdateDate");

/// 最后更新时间
Property UpdateTime As %Library.String(MAXLEN = 50, XMLNAME = "UpdateTime");

/// 申请科室
Property AppDeptDesc As %Library.String(MAXLEN = 50, XMLNAME = "AppDeptDesc");

/// *->增加非循环结构,暂时解决两层循环结构数据绑定问题20160820 chenjiang*/
/// 医嘱明细ID
Property OEORIOrderItemID As %Library.String(MAXLEN = 30, XMLNAME = "OEORIOrderItemID");

/// 检查部位代码
Property RISRPositionCode As %Library.String(MAXLEN = 30, XMLNAME = "RISRPositionCode");

/// 检查体位代码
Property RISRPostureCode As %Library.String(MAXLEN = 30, XMLNAME = "RISRPostureCode");

/// 检查代码
Property RISRCode As %Library.String(MAXLEN = 30, XMLNAME = "RISRCode");

/// *<- 检查描述
Property RISRDesc As %Library.String(MAXLEN = 50, XMLNAME = "RISRDesc");

}
