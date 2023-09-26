/// CTOR: QP
/// DATE: 2019-05-13
/// DESC: 碳青霉烯类及替加环素抗菌药物DTO-北京版
Class DHCAnt.Base.Dto.CQMXBJ Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 1 就诊id
Property Admid As %Library.String(TRUNCATE = 1);

/// 2 科室
Property Locid As %Library.String(TRUNCATE = 1);

/// 3 医嘱项
Property ArcimDr As %Library.String(TRUNCATE = 1);

/// 4 使用目的
Property AimDr As %Library.String(TRUNCATE = 1);

/// 5 申请表
Property ApplyDr As %Library.String(TRUNCATE = 1);

/// 6 入院第一诊断
Property FirstDiagnosisDr As %Library.String(TRUNCATE = 1);

/// 7 APACHEII评分
Property ApacheII As %Library.String(TRUNCATE = 1);

/// 8 感染部位
Property InfectionSite As %Library.String(TRUNCATE = 1);

/// 9 是否院感
Property SenseHospital As %Library.String(TRUNCATE = 1);

/// 10 感染诊断
Property InfectionDiagnosisDr As %Library.String(TRUNCATE = 1);

/// 11 适应症
Property Indication As %Library.String(TRUNCATE = 1);

/// 12 处方权限
Property PrescAuth As %Library.String(TRUNCATE = 1);

/// 13 用药日期
Property MedicationDate As %Library.String(TRUNCATE = 1);

/// 14 停药日期
Property StopMedicationDate As %Library.String(TRUNCATE = 1);

/// 15 用药次数
Property MedicationNum As %Library.String(TRUNCATE = 1);

/// 16 用药效果
Property MedicationEffect As %Library.String(TRUNCATE = 1);

/// 17 调整方案
Property AdjustPlan As %Library.String(TRUNCATE = 1);

/// 18 用法（次/日）
Property Instruction As %Library.String(TRUNCATE = 1);

/// 19 剂量（0~10g）
Property Dose As %Library.String(TRUNCATE = 1);

/// 20 病原学证据(有/无)
Property EtiologyEvidence As %Library.String(TRUNCATE = 1);

/// 21 送检日期
Property LabDate As %Library.String(TRUNCATE = 1);

/// 22 报告日期
Property ReportDate As %Library.String(TRUNCATE = 1);

/// 23 标本类型
Property SpecimenType As %Library.String(TRUNCATE = 1);

/// 24 送检结果(1阴性/2阳性)
Property LabResult As %Library.String(TRUNCATE = 1);

/// 25 细菌名称
Property BacteriaName As %Library.String(TRUNCATE = 1);

/// 26 是否耐碳氢霉烯
Property CQMXResist As %Library.String(TRUNCATE = 1);

/// 27 CQMX药敏名称
Property CQMXResistName As %Library.String(TRUNCATE = 1);

/// 28 CQMX MIC值
Property CQMXMic As %Library.String(TRUNCATE = 1);

/// 29 是否耐替加环素
Property TGCResist As %Library.String(TRUNCATE = 1);

/// 30 TGC药敏名称
Property TGCResistName As %Library.String(TRUNCATE = 1);

/// 31 TGC MIC值
Property TGCMic As %Library.String(TRUNCATE = 1);

/// 32 送检标本是否与感染诊断相关
Property LabRelateInfectDiag As %Library.String(TRUNCATE = 1);

/// 33 使用碳青霉烯/替加环素类抗菌药物后的不良反应
Property SideEffect As %Library.String(TRUNCATE = 1);

/// 34 碳氢霉烯耐药铜绿假单胞菌-送检标本
Property TLJSpecimen As %Library.String(TRUNCATE = 1);

/// 35 碳氢霉烯耐药铜绿假单胞菌-送检时间
Property TLJLabDate As %Library.String(TRUNCATE = 1);

/// 36 碳氢霉烯耐药铜绿假单胞菌-报告时间
Property TLJReportDate As %Library.String(TRUNCATE = 1);

/// 37 碳氢霉烯耐药不动杆菌-送检标本
Property BDGJSpecimen As %Library.String(TRUNCATE = 1);

/// 38 碳氢霉烯耐药不动杆菌-送检时间
Property BDGJLabDate As %Library.String(TRUNCATE = 1);

/// 39 碳氢霉烯耐药不动杆菌-报告时间
Property BDGJReportDate As %Library.String(TRUNCATE = 1);

/// 40 碳氢霉烯耐药肠杆菌-送检标本
Property CGJSpecimen As %Library.String(TRUNCATE = 1);

/// 41 碳氢霉烯耐药肠杆菌-送检时间
Property CGJLabDate As %Library.String(TRUNCATE = 1);

/// 42 碳氢霉烯耐药肠杆菌-报告时间
Property CGJReportDate As %Library.String(TRUNCATE = 1);

}
