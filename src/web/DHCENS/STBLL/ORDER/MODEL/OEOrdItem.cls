Class web.DHCENS.STBLL.ORDER.MODEL.OEOrdItem Extends (%RegisteredObject, %XML.Adaptor, BusinessField)
{

Parameter XMLNAME = "OEORIInfo";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 医嘱明细ID
Property OEORIOrderItemID As %Library.String(MAXLEN = 30, XMLNAME = "OEORIOrderItemID");

/// 医嘱组号  1
Property OEORIOEORIDR As %Library.String(MAXLEN = 30, XMLNAME = "OEORIOEORIDR");

/// 医嘱项目代码
Property OEORIARCItmMastCode As %Library.String(MAXLEN = 30, XMLNAME = "OEORIARCItmMastCode");

/// 医嘱项目描述
Property OEORIARCItmMastDesc As %Library.String(MAXLEN = 100, XMLNAME = "OEORIARCItmMastDesc");

/// 医嘱类型代码
Property OEORIPriorityCode As %Library.String(MAXLEN = 10, XMLNAME = "OEORIPriorityCode");

/// 医嘱类型描述
Property OEORIPriorityDesc As %Library.String(MAXLEN = 30, XMLNAME = "OEORIPriorityDesc");

/// 医嘱状态代码
Property OEORIStatusCode As %Library.String(MAXLEN = 10, XMLNAME = "OEORIStatusCode");

/// 医嘱状态描述
Property OEORIStatusDesc As %Library.String(MAXLEN = 30, XMLNAME = "OEORIStatusDesc");

/// 医嘱类别代码
Property OEORIClass As %Library.String(MAXLEN = 30, XMLNAME = "OEORIClass");

/// 医嘱类别描述
Property OEORIClassDesc As %Library.String(MAXLEN = 30, XMLNAME = "OEORIClassDesc");

/// 处方号
Property OEORIPrescNo As %Library.String(MAXLEN = 20, XMLNAME = "OEORIPrescNo");

/// 剂型代码
Property OEORIDoseFormsCode As %Library.String(MAXLEN = 10, XMLNAME = "OEORIDoseFormsCode");

/// 剂型描述
Property OEORIDoseFormsDesc As %Library.String(MAXLEN = 30, XMLNAME = "OEORIDoseFormsDesc");

/// 单次剂量
Property OEORIDoseQty As %Library.String(MAXLEN = 10, XMLNAME = "OEORIDoseQty");

/// 单次剂量单位代码
Property OEORIDoseUnitCode As %Library.String(MAXLEN = 6, XMLNAME = "OEORIDoseUnitCode");

/// 单次剂量单位描述
Property OEORIDoseUnitDesc As %Library.String(MAXLEN = 20, XMLNAME = "OEORIDoseUnitDesc");

/// 频次代码
Property OEORIFreqCode As %Library.String(MAXLEN = 3, XMLNAME = "OEORIFreqCode");

/// 频次描述
Property OEORIFreqDesc As %Library.String(MAXLEN = 20, XMLNAME = "OEORIFreqDesc");

/// 用药途径代码
Property OEORIInstrCode As %Library.String(MAXLEN = 3, XMLNAME = "OEORIInstrCode");

/// 用药途径描述
Property OEORIInstrDesc As %Library.String(MAXLEN = 20, XMLNAME = "OEORIInstrDesc");

/// 疗程代码
Property OEORIDurationCode As %Library.String(MAXLEN = 3, XMLNAME = "OEORIDurationCode");

/// 疗程描述
Property OEORIDurationDesc As %Library.String(MAXLEN = 20, XMLNAME = "OEORIDurationDesc");

/// 医嘱数量
Property OEORIOrderQty As %Library.String(MAXLEN = 3, XMLNAME = "OEORIOrderQty");

/// 医嘱结果状态代码
Property OEORIResultStatusCode As %Library.String(MAXLEN = 3, XMLNAME = "OEORIResultStatusCode");

/// 医嘱结果状态描述
Property OEORIResultStatusDesc As %Library.String(MAXLEN = 20, XMLNAME = "OEORIResultStatusDesc");

/// 医嘱备注信息
Property OEORIRemarks As %Library.String(MAXLEN = 100, XMLNAME = "OEORIRemarks");

/// 医嘱开立者代码
Property OEORIEnterDocCode As %Library.String(MAXLEN = 50, XMLNAME = "OEORIEnterDocCode");

/// 医嘱开立者描述
Property OEORIEnterDocDesc As %Library.String(MAXLEN = 50, XMLNAME = "OEORIEnterDocDesc");

/// 医嘱开立日期
Property OEORIEnterDate As %Library.String(MAXLEN = 10, XMLNAME = "OEORIEnterDate");

/// 医嘱开立时间
Property OEORIEnterTime As %Library.String(MAXLEN = 10, XMLNAME = "OEORIEnterTime");

/// 医嘱开立科室代码
Property OEORIEnterDeptCode As %Library.String(MAXLEN = 50, XMLNAME = "OEORIEnterDeptCode");

/// 医嘱开立科室
Property OEORIEnterDeptDesc As %Library.String(MAXLEN = 50, XMLNAME = "OEORIEnterDeptDesc");

/// 医嘱执行科室代码
Property OEORIExecDeptCode As %Library.String(MAXLEN = 50, XMLNAME = "OEORIExecDeptCode");

/// 医嘱执行科室
Property OEORIExecDeptDesc As %Library.String(MAXLEN = 50, XMLNAME = "OEORIExecDeptDesc");

/// 要求执行日期
Property OEORIRequireExecDate As %Library.String(MAXLEN = 10, XMLNAME = "OEORIRequireExecDate");

/// 要求执行时间
Property OEORIRequireExecTime As %Library.String(MAXLEN = 10, XMLNAME = "OEORIRequireExecTime");

/// 医嘱停止日期
Property OEORIStopDate As %Library.String(MAXLEN = 10, XMLNAME = "OEORIStopDate");

/// 医嘱停止时间
Property OEORIStopTime As %Library.String(MAXLEN = 10, XMLNAME = "OEORIStopTime");

/// 停止医嘱者代码
Property OEORIStopDocCode As %Library.String(MAXLEN = 50, XMLNAME = "OEORIStopDocCode");

/// 停止医嘱者描述
Property OEORIStopDocDesc As %Library.String(MAXLEN = 50, XMLNAME = "OEORIStopDocDesc");

/// 是否皮试
Property OEORIIsSkinTest As %Library.String(MAXLEN = 5, XMLNAME = "OEORIIsSkinTest");

/// 是否紧急
Property OEORIISEmergency As %Library.String(MAXLEN = 5, XMLNAME = "OEORIISEmergency");

/// 父医嘱ID
Property OEORIParentOrderID As %Library.String(MAXLEN = 50, XMLNAME = "OEORIParentOrderID");

/// 标本号
Property OEORISpecimenID As %Library.String(MAXLEN = 20, XMLNAME = "OEORISpecimenID");

/// 标本代码
Property OEORISpecimenCode As %Library.String(MAXLEN = 20, XMLNAME = "OEORISpecimenCode");

/// 材料条形码
Property MaterialBarcode As %Library.String(MAXLEN = 30, XMLNAME = "MaterialBarcode");

/// 医嘱价格
Property OEORIPrice As %Library.String(MAXLEN = 10, XMLNAME = "OEORIPrice");

/// 规格
Property OEORISpecification As %Library.String(MAXLEN = 30, XMLNAME = "OEORISpecification");

/// 医嘱收费状态代码
Property OEORIBillStatusCode As %Library.String(MAXLEN = 30, XMLNAME = "OEORIBillStatusCode");

}
