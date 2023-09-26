/// 名称: DHCMed.NINF.Srv.InfReportSumm
/// 描述: 医院感染报告 摘要信息(对外接口)
/// 编写者：LiYang
/// 编写日期: 2013-05-16
Class DHCMed.NINF.Srv.InfReportSumm Extends DHCMed.Abstract
{

/// 疾病转归("NINFInfDiseasePrognosis")
Property DiseasePrognosis As DHCMed.NINF.Srv.Dictionary;

/// 与死亡关系("NINFInfDeathRelation")
Property DeathRelation As DHCMed.NINF.Srv.Dictionary;

/// 诊断依据
Property DiagnosisBasis As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 感染性疾病病程
Property DiseaseCourse As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 易感因素("NINFInfInfFactors")
Property InfFactors As list Of DHCMed.NINF.Srv.Dictionary;

/// 侵入性操作("NINFInfInvasiveOper")
Property InvasiveOperation As list Of DHCMed.NINF.Srv.Dictionary;

/// 入住ICU("NINFInfICUBoolean")(是/否)
Property ICUBoolean As DHCMed.NINF.Srv.Dictionary;

/// ICU科室("NINFInfICULocation")
Property ICULocation As DHCMed.NINF.Srv.Dictionary;

/// 手术("NINFInfOprBoolean")(是/否)
Property OprBoolean As DHCMed.NINF.Srv.Dictionary;

/// 病原学检验("NINFInfLabBoolean")(是/否)
Property LabBoolean As DHCMed.NINF.Srv.Dictionary;

/// 使用抗菌药物("NINFInfAntiBoolean")(是/否)
Property AntiBoolean As DHCMed.NINF.Srv.Dictionary;

/// 不良反应("NINFInfAdverseReaction")(有/无)
Property AdverseReaction As DHCMed.NINF.Srv.Dictionary;

/// 二重感染("NINFInfSuperinfection")(有/无)
Property Superinfection As DHCMed.NINF.Srv.Dictionary;

/// 新生儿出生体重(KG)
Property BornWeight As %String(TRUNCATE = 1);

/// 转科记录 指向PA_AdmTransaction
Property TransID As %String(TRUNCATE = 1);

/// 转入科室 指向CT_Loc
Property TransLoc As DHCMed.NINF.Srv.Dictionary;

/// 入科来源 指向CT_Loc
Property TransFromLoc As DHCMed.NINF.Srv.Dictionary;

/// 出科去向 指向CT_Loc
Property TransToLoc As DHCMed.NINF.Srv.Dictionary;

/// 转入日期
Property TransInDate As %String;

/// 转出日期
Property TransOutDate As %String;

/// 转出ICU时状态(带管情况)("NINFICUOutICUStatus")
Property OutICUStatus As list Of DHCMed.NINF.Srv.Dictionary;

/// 转出ICU48小时内状态(带管情况)("NINFICUOutICU48Status")
Property OutICU48Status As list Of DHCMed.NINF.Srv.Dictionary;

/// 系统症状
Property SystemSymptom As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 局部症状/体征
Property LocalSymptom As %String(MAXLEN = 1000, TRUNCATE = 1);

}
