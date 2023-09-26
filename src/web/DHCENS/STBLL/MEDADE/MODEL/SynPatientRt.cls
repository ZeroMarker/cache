Class web.DHCENS.STBLL.MEDADE.MODEL.SynPatientRt Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "SynPatientRt";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 患者来源
Property encounterSource As %Library.String(XMLNAME = "encounterSource");

/// 患者姓名
Property patientName As %Library.String(XMLNAME = "patientName");

/// 就诊号
Property encounterId As %Library.String(XMLNAME = "encounterId");

/// 病案号
Property patMediNo As %Library.String(XMLNAME = "patMediNo");

/// 患者性别代码
Property patGenderCode As %Library.String(XMLNAME = "patGenderCode");

/// 患者性别
Property patGenderDesc As %Library.String(XMLNAME = "patGenderDesc");

/// 患者年龄
Property patientAge As %Library.String(XMLNAME = "patientAge");

/// 出生日期
Property patBirthDate As %Library.String(XMLNAME = "patBirthDate");

/// 联系电话
Property patMobPhone As %Library.String(XMLNAME = "patMobPhone");

/// 民族代码
Property patNationCode As %Library.String(XMLNAME = "patNationCode");

/// 民族
Property patNationDesc As %Library.String(XMLNAME = "patNationDesc");

/// 患者体重
Property vitalSignWeight As %Library.String(XMLNAME = "vitalSignWeight");

/// 住院次数
Property inpatientTimes As %Library.String(XMLNAME = "inpatientTimes");

/// 入院/门诊科室id
Property encDeptId As %Library.String(XMLNAME = "encDeptId");

/// 就诊科室代码
Property encDeptCode As %Library.String(XMLNAME = "encDeptCode");

/// 就诊科室名称
Property encDeptDesc As %Library.String(XMLNAME = "encDeptDesc");

/// 入院/门诊日期
Property encounterDate As %Library.String(XMLNAME = "encounterDate");

/// 入院/门诊时间
Property encounterTime As %Library.String(XMLNAME = "encounterTime");

/// 就诊医生代码
Property encDocCode As %Library.String(XMLNAME = "encDocCode");

/// 就诊医生姓名
Property encDocName As %Library.String(XMLNAME = "encDocName");

/// 出院日期
Property dischargeDate As %Library.String(XMLNAME = "dischargeDate");

/// 出院时间
Property dischargeTime As %Library.String(XMLNAME = "dischargeTime");

/// 患者职业代码
Property patOccuCode As %Library.String(XMLNAME = "patOccuCode");

/// 患者职业
Property patOccuDesc As %Library.String(XMLNAME = "patOccuDesc");

/// 医疗类别
Property medicalType As %Library.String(XMLNAME = "medicalType");

/// 第一诊断代码
Property diagnoseCode As %Library.String(XMLNAME = "diagnoseCode");

/// 第一诊断名称
Property diagnoseDesc As %Library.String(XMLNAME = "diagnoseDesc");

/// 文化程度
Property patientDegree As %Library.String(XMLNAME = "patientDegree");

/// 登记号
Property patientId As %Library.String(XMLNAME = "patientId");

/// 操作标识
Property flag As %Library.String(XMLNAME = "flag");

/// 就诊状态
Property encStatusCode As %Library.String(XMLNAME = "encStatusCode");

/// 病床号
Property currBedNo As %Library.String(XMLNAME = "currBedNo");

}
