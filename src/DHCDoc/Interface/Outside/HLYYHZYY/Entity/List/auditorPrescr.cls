Class DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.auditorPrescr Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 患者id
Property patientId As %String(TRUNCATE = 1, XMLNAME = "patientId");

/// 就诊流水号
Property serialNo As %String(TRUNCATE = 1, XMLNAME = "serialNo");

/// 入院标识
Property visitId As %String(TRUNCATE = 1, XMLNAME = "visitId");

/// 每次保存时的唯一标识
Property hisUuid As %String(TRUNCATE = 1, XMLNAME = "hisUuid");

/// 药品配伍主号
Property groupNo As %String(TRUNCATE = 1, XMLNAME = "groupNo");

/// 药品配伍子号
Property groupSubNo As %String(TRUNCATE = 1, XMLNAME = "groupSubNo");

/// 处方号
Property prescrNo As %String(TRUNCATE = 1, XMLNAME = "prescrNo");

/// 科室代码
Property deptCode As %String(TRUNCATE = 1, XMLNAME = "deptCode");

/// 科室名称
Property deptName As %String(TRUNCATE = 1, XMLNAME = "deptName");

/// 开立医生代码
Property doctorCode As %String(TRUNCATE = 1, XMLNAME = "doctorCode");

/// 开立医生名称
Property doctorName As %String(TRUNCATE = 1, XMLNAME = "doctorName");

/// 开立处方时间	格式：YYYY-MM-DD hh:mm:ss(24h)
Property startDateTime As %String(TRUNCATE = 1, XMLNAME = "startDateTime");

/// 是否当前处方/医嘱	0当前处方;1历史处方
Property isCurrent As %String(TRUNCATE = 1, XMLNAME = "isCurrent");

/// 药品唯一编码
Property drugCode As %String(TRUNCATE = 1, XMLNAME = "drugCode");

/// 药品名称
Property drugName As %String(TRUNCATE = 1, XMLNAME = "drugName");

/// 用药开始时间	格式：YYYY-MM-DD hh:mm:ss(24h)
Property beginUseDate As %String(TRUNCATE = 1, XMLNAME = "beginUseDate");

/// 用药结束时间	格式：YYYY-MM-DD hh:mm:ss(24h)
Property endUseDate As %String(TRUNCATE = 1, XMLNAME = "endUseDate");

/// 规格
Property drugSpec As %String(TRUNCATE = 1, XMLNAME = "drugSpec");

/// 单次剂量
Property dosage As %String(TRUNCATE = 1, XMLNAME = "dosage");

/// 剂量单位
Property dosageUnits As %String(TRUNCATE = 1, XMLNAME = "dosageUnits");

/// 剂量总量
Property qnty As %String(TRUNCATE = 1, XMLNAME = "qnty");

/// 总量单位
Property qntyUnit As %String(TRUNCATE = 1, XMLNAME = "qntyUnit");

/// 药品数量
Property total As %String(TRUNCATE = 1, XMLNAME = "total");

/// 药品数量单位
Property totalUnit As %String(TRUNCATE = 1, XMLNAME = "totalUnit");

/// 一天给药的次数
Property freqTimes As %String(TRUNCATE = 1, XMLNAME = "freqTimes");

/// 单价
Property price As %String(TRUNCATE = 1, XMLNAME = "price");

/// 给药途径代码
Property administrationCode As %String(TRUNCATE = 1, XMLNAME = "administrationCode");

/// 给药途径
Property administration As %String(TRUNCATE = 1, XMLNAME = "administration");

/// 长期/临时	0为临时医嘱;1为长期医嘱
Property longOnceFlag As %String(TRUNCATE = 1, XMLNAME = "longOnceFlag");

/// 频次代码
Property frequencyCode As %String(TRUNCATE = 1, XMLNAME = "frequencyCode");

/// 频次名称
Property frequencyName As %String(TRUNCATE = 1, XMLNAME = "frequencyName");

}
