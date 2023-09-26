Class web.DHCENS.STBLL.MEDADE.MODEL.SynPrescRt Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "SynMedRt";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 医嘱代码
Property orderCode As %Library.String(XMLNAME = "orderCode");

/// 医嘱名称
Property orderDesc As %Library.String(XMLNAME = "orderDesc");

/// 批准文号
Property approvalNumber As %Library.String(XMLNAME = "approvalNumber");

/// 商品名称
Property commodityName As %Library.String(XMLNAME = "commodityName");

/// 通用名称（含剂型）
Property medGeneDesc As %Library.String(XMLNAME = "medGeneDesc");

/// 生产厂家
Property medicineManufacturer As %Library.String(XMLNAME = "medicineManufacturer");

/// 生产批号
Property medBatNo As %Library.String(XMLNAME = "medBatNo");

/// 用法描述
Property medUsageDesc As %Library.String(XMLNAME = "medUsageDesc");

/// 单次用量
Property medicineDosage As %Library.String(XMLNAME = "medicineDosage");

/// 用量单位
Property medDosUnitCode As %Library.String(XMLNAME = "medDosUnitCode");

/// 开始时间
Property ordStartTime As %Library.String(XMLNAME = "ordStartTime");

/// 结束时间
Property ordEndTime As %Library.String(XMLNAME = "ordEndTime");

/// 用药原因
Property medicalReasons As %Library.String(XMLNAME = "medicalReasons");

/// 药品规格
Property medSpecId As %Library.String(XMLNAME = "medSpecId");

/// 供应商
Property medicineVendor As %Library.String(XMLNAME = "medicineVendor");

/// 数量
Property orderQuantity As %Library.String(XMLNAME = "orderQuantity");

/// 剂型Id
Property medDoseFormId As %Library.String(XMLNAME = "medDoseFormId");

/// 剂型代码
Property medDoseFormCode As %Library.String(XMLNAME = "medDoseFormCode");

/// 剂型描述
Property medDoseFormDesc As %Library.String(XMLNAME = "medDoseFormDesc");

/// 频次代码
Property medFreqCode As %Library.String(XMLNAME = "medFreqCode");

/// 频次描述
Property medFreqDesc As %Library.String(XMLNAME = "medFreqDesc");

/// 操作标识
Property flag As %Library.String(XMLNAME = "flag");

}
