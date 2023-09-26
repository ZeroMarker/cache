/// 名称: DHCMed.NINF.Srv.InfReportAnti
/// 描述: 感染监测 抗菌用药 对外接口
/// 编写者：zhufei
/// 编写日期: 2013-06-17
Class DHCMed.NINF.Srv.InfReportAnti Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 医嘱ID
Property ArcimID As %String(TRUNCATE = 1);

/// 医嘱名称
Property ArcimDesc As %String(TRUNCATE = 1);

/// 开始日期
Property StartDate As %Date;

/// 开始时间
Property StartTime As %Time;

/// 结束日期
Property EndDate As %Date;

/// 结束时间
Property EndTime As %Time;

/// 剂量
Property DoseQty As %String(TRUNCATE = 1);

/// 剂量单位 指向CT_UOM
Property DoseUnit As %String(TRUNCATE = 1);

/// 频次 指向PHC_Freq
Property PhcFreq As %String(TRUNCATE = 1);

/// 用途
Property MedUsePurpose As DHCMed.NINF.Srv.Dictionary;

/// 给药途径
Property AdminRoute As DHCMed.NINF.Srv.Dictionary;

/// 目的
Property MedPurpose As DHCMed.NINF.Srv.Dictionary;

/// 治疗用药方式
Property TreatmentMode As DHCMed.NINF.Srv.Dictionary;

/// 预防用药指征
Property PreMedIndicat As DHCMed.NINF.Srv.Dictionary;

/// 预防用药效果
Property PreMedEffect As DHCMed.NINF.Srv.Dictionary;

/// 联合用药
Property CombinedMed As DHCMed.NINF.Srv.Dictionary;

/// 术前用药时间(分钟)
Property PreMedTime As %String(TRUNCATE = 1);

/// 术后用药天数(天)
Property PostMedDays As %String(TRUNCATE = 1);

}
