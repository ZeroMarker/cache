Class web.DHCENS.STBLL.RIS.MODEL.OrderList Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "OrderList";

/// 主述	2019-10-15
Property RISRArExaReqSym As %Library.String(MAXLEN = 3000, XMLNAME = "RISRArExaReqSym");

/// 诊断	2019-10-15
Property RISRPatDiag As %Library.String(MAXLEN = 300, XMLNAME = "RISRPatDiag");

/// 检查目的	2019-10-15
Property RISRArPurpose As %Library.String(MAXLEN = 3000, XMLNAME = "RISRArPurpose");

/// 检查申请单编号
Property RISRAppNum As %Library.String(MAXLEN = 50, XMLNAME = "RISRAppNum");

/// 检查号
Property RISRExamID As %Library.String(MAXLEN = 50, XMLNAME = "RISRExamID");

/// 检查注意事项
Property RISRMattersAttention As %Library.String(MAXLEN = 1000, XMLNAME = "RISRMattersAttention");

/// 检查特殊病史编码（高血压/心脏病）
Property RISRSpecalMedicalRecord As %Library.String(MAXLEN = 300, XMLNAME = "RISRSpecalMedicalRecord");

/// 检查送检医生代码
Property RISRSubmitDocCode As %Library.String(MAXLEN = 50, XMLNAME = "RISRSubmitDocCode");

/// 检查送检医生姓名
Property RISRSubmitDocDesc As %Library.String(MAXLEN = 50, XMLNAME = "RISRSubmitDocDesc");

/// 检查申请时间
Property RISRSubmitTime As %Library.String(MAXLEN = 50, XMLNAME = "RISRSubmitTime");

/// 检查接收科室代码
Property RISRAcceptDeptCode As %Library.String(MAXLEN = 50, XMLNAME = "RISRAcceptDeptCode");

/// 检查接收科室描述
Property RISRAcceptDeptDesc As %Library.String(MAXLEN = 50, XMLNAME = "RISRAcceptDeptDesc");

/// 检查科室位置
Property RISRDeptLocation As %Library.String(MAXLEN = 100, XMLNAME = "RISRDeptLocation");

/// 检查是否加急
Property RISRISEmergency As %Library.String(MAXLEN = 10, XMLNAME = "RISRISEmergency");

/// 检查临床所见
Property RISRClinicalSymptoms As %Library.String(MAXLEN = 3000, XMLNAME = "RISRClinicalSymptoms");

/// 申请科室
Property AppDeptDesc As %Library.String(MAXLEN = 50, XMLNAME = "AppDeptDesc");

/// 申请科室代码
Property AppDeptCode As %Library.String(MAXLEN = 50, XMLNAME = "AppDeptCode");

/// 医嘱明细ID
Property OEORIOrderItemID As %Library.String(MAXLEN = 30, XMLNAME = "OEORIOrderItemID");

/// 检查部位代码
Property RISRPositionCode As %Library.String(MAXLEN = 100, XMLNAME = "RISRPositionCode");

/// 检查体位代码
Property RISRPostureCode As %Library.String(MAXLEN = 30, XMLNAME = "RISRPostureCode");

/// 检查代码
Property RISRCode As %Library.String(MAXLEN = 30, XMLNAME = "RISRCode");

/// 检查描述
Property RISRDesc As %Library.String(MAXLEN = 50, XMLNAME = "RISRDesc");

/// 医嘱价格 
Property RISRPrice As %Library.String(MAXLEN = 50, XMLNAME = "RISRPrice");

/// 医嘱子类代码
Property OrdSubCatCode As %String(MAXLEN = 50, XMLNAME = "OrdSubCatCode");

/// 医嘱子类描述
Property OrdSubCatDesc As %String(MAXLEN = 100, XMLNAME = "OrdSubCatDesc");

/// 医嘱大类代码
Property OrdCatCode As %String(MAXLEN = 50, XMLNAME = "OrdCatCode");

/// 医嘱大类描述
Property OrdCatDesc As %String(MAXLEN = 100, XMLNAME = "OrdCatDesc");

/// 计费状态
Property OrdBillStatus As %String(MAXLEN = 100, XMLNAME = "OrdBillStatus");

/// 生理周期代码
Property PhysiCycleCode As %String(MAXLEN = "");

/// 生理周期
Property PhysiCycle As %String(MAXLEN = "");

}
