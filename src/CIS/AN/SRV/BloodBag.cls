Class CIS.AN.SRV.BloodBag Extends (%RegisteredObject, %XML.Adaptor)
{

/// 患者就诊号
Property PaadmNo As %String;

/// 患者姓名
Property PatName As %String;

/// 患者性别
Property PatGender As %String;

/// 患者年龄
Property PatAge As %String;

/// 患者所在科室
Property PatDept As %String;

/// 患者所在床位
Property PatBed As %String;

/// 患者住院号
Property MedNo As %String;

/// 输血史
Property TransHistory As %String;

/// 临床诊断
Property Diagnosis As %String;

/// 输血目的
Property TransReason As %String;

/// 预定输血时间
Property PlanTransTime As %String;

/// 输血性质
Property TransNature As %String;

/// 输血成分
Property TransComponents As %String;

/// 输血量
Property TransVolume As %String;

/// 输血单位
Property TransUnit As %String;

/// 患者ABO血型
Property ABO As %String;

/// 患者RH血型
Property RH As %String;

/// HGB检验结果
Property HGB As %String;

/// HCT检验结果
Property HCT As %String;

/// PLT检验结果
Property PLT As %String;

/// ALT检验结果
Property ALT As %String;

/// HbsAg检验结果
Property HbsAg As %String;

/// Anti-HBs检验结果
Property AntiHBs As %String;

/// Auti-HCV检验结果
Property AntiHCV As %String;

/// Auti-HIV1/2检验结果
Property AntiHIV12 As %String;

/// HBeAg检验结果
Property HBeAg As %String;

/// AntiHBe检验结果
Property AntiHBe As %String;

/// 梅毒检验结果
Property SP As %String;

/// 标本采集者工号
Property SpecimenCollector As %String;

/// 申请医师工号
Property AppDoctor As %String;

/// 上级医师工号
Property SuperiorDoctor As %String;

/// 科主任工号
Property HeadDoctor As %String;

/// 医务科签字人工号
Property MedSignatory As %String;

/// 输血科签字人工号
Property TransSignatory As %String;

/// 血液品种
Property BloodSpecies As %String(MAXLEN = 200);

/// 血液成分码
Property ComponentCode As %String(MAXLEN = 100);

/// 采血时间
Property CollectedDT As %String;

/// 入库时间
Property RespInDT As %String;

/// 失效时间
Property ExpiredDT As %String;

/// 血液ABO
Property BloodABO As %String;

/// 血液RH
Property BloodRH As %String;

/// 输血申请ID
Property TransAppID As %String(MAXLEN = 200);

/// 输血申请条码号
Property TransBarCode As %String(MAXLEN = 100);

}
