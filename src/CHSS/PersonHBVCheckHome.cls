Class CHSS.PersonHBVCheckHome Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = HBVRowId, SqlTableName = PersonHBVCheckHome ]
{

/// 个人档案外键
Property PersonRowIdDR As CHSS.PersonHealthRecordMain [ Required ];

/// 乙肝档案外键--个体卫生事件明细(诊断)
/// Property DetailRowIdParref As %Numeric [ Required ];
/// 是否有乙肝病史
Property bHaveHBV As %String(MAXLEN = 5, TRUNCATE = 1);

/// 首次发现时间
Property DateOfFirstCheck As %Date;

/// 首次发现方式
Property TypeOfFirstCheck As CHSS.DictTypeOfFirstCheck;

/// 症状--另一张表中
/// 当时诊断--D
Property DiagnoseThen As CHSS.DictDiagnoseResult;

/// 肝功能是否异常
Property GOT As %String(MAXLEN = 5, TRUNCATE = 1);

/// 肝功能异常情况指标
/// ALT
Property ALT As %String(MAXLEN = 10, TRUNCATE = 1);

/// AST
Property AST As %String(MAXLEN = 10, TRUNCATE = 1);

/// ALB
Property ALB As %String(MAXLEN = 10, TRUNCATE = 1);

/// GLOB
Property GLOB As %String(MAXLEN = 10, TRUNCATE = 1);

/// AG
Property AG As %String(MAXLEN = 10, TRUNCATE = 1);

/// TB
Property TB As %String(MAXLEN = 10, TRUNCATE = 1);

/// DB
Property DB As %String(MAXLEN = 10, TRUNCATE = 1);

/// 是否有并发症
Property bHaveComplication As %String(MAXLEN = 5, TRUNCATE = 1);

/// 并发症情况--另一张表中
/// Property ComplicationInfo As %String(MAXLEN = 100);
/// 当时是否治疗
Property bTreatThen As %String(MAXLEN = 5, TRUNCATE = 1);

/// 药物--另一张表中
/// 此后是否随访
Property bFollowUp As %String(MAXLEN = 5, TRUNCATE = 1);

/// 是否反复发作
Property bRelapse As %String(MAXLEN = 5, TRUNCATE = 1);

/// 治疗方式--另一张表中
/// Property TreatInfo As CHSS.DictTreatInfo;
/// 药物--另一张表中
/// 治疗效果
Property TreatEffection As CHSS.DictTreatEffection;

/// 是否接种乙肝疫苗
Property bVaccination As %String(MAXLEN = 5, TRUNCATE = 1);

/// 疫苗产地
Property VaccinationPlace As CHSS.DictVaccinationPlace;

/// 疫苗产地类别--暂时忽略
/// Property TypeOfVaccinationPlace As %String(MAXLEN = 100);
/// 疫苗剂量
Property DosageOfVaccination As CHSS.DictVaccinationDosage;

/// 接种针数
Property Needles As %Numeric;

/// 第一针日期
Property FirstVaccination As %Date;

/// 第二针日期
Property SecondVaccination As %Date;

/// 第三针日期
Property ThirdVaccination As %Date;

/// 接种次数
Property TimesOfVaccination As %Numeric;

/// 接种后是否监测
Property bMonitor As %String(MAXLEN = 5, TRUNCATE = 1);

/// 抗体滴度
Property Titer As CHSS.DictTiter;

/// 监测频率
Property FrequencyOfMonitor As CHSS.DictMonitorFrequency;

/// 是否加强或补种
Property bReplant As %String(MAXLEN = 5, TRUNCATE = 1);

/// 父亲感染情况
Property bFatherInfection As %String(MAXLEN = 5, TRUNCATE = 1);

/// 父亲感染日期
Property DateOfFatherInfection As %Date;

/// 母亲感染情况
Property bMomInfection As %String(MAXLEN = 5, TRUNCATE = 1);

/// 母亲感染日期
Property DateOfMomInfection As %Date;

/// 子女感染情况
Property bSonInfection As %String(MAXLEN = 5, TRUNCATE = 1);

/// 子女感染日期
Property DateOfSonInfection As %Date;

/// 乙肝家族史
Property bFamilyHBV As %String(MAXLEN = 5, TRUNCATE = 1);

/// 肝硬化家族史
Property bFamilyCirrhosis As %String(MAXLEN = 5, TRUNCATE = 1);

/// 肝癌家族史
Property bLiverCancer As %String(MAXLEN = 5, TRUNCATE = 1);

/// 输血及血制品史
Property bBloodTransfusion As %String(MAXLEN = 5, TRUNCATE = 1);

/// 输血种类
Property TypOfBlood As CHSS.DictTypOfBlood;

/// 血制品种类
Property KindOfBlood As CHSS.DictKindOfBlood;

/// 静脉吸毒
Property bIVDrug As %String(MAXLEN = 5, TRUNCATE = 1);

/// 是否共用注射器 
Property bUseOneInjector As %String(MAXLEN = 5, TRUNCATE = 1);

/// 注射器使用情况
Property UseInjector As CHSS.DictUseInjectorInfo;

/// 非一次性
Property bNotOneTIme As %String(MAXLEN = 5, TRUNCATE = 1);

/// 配偶感染情况
Property bSpouseInfection As %String(MAXLEN = 5, TRUNCATE = 1);

/// 配偶感染日期
Property DateOfspouseInfection As %Date;

/// 乙肝接触史
Property HBVContactHistory As %String(MAXLEN = 5, TRUNCATE = 1);

/// 美容
Property bHairdressing As %String(MAXLEN = 5, TRUNCATE = 1);

/// 纹身
Property bTattoo As %String(MAXLEN = 5, TRUNCATE = 1);

/// 修足
Property bFoottMassage As %String(MAXLEN = 5, TRUNCATE = 1);

/// 婚外性伙伴
Property bSexPartner As %String(MAXLEN = 5, TRUNCATE = 1);

/// 婚外性伙伴数量
Property SexPartnerNum As %Numeric;

/// 职业暴露乙肝
Property bExposureHBV As %String(MAXLEN = 5, TRUNCATE = 1);

/// 发现时症状
Property StatusOfFirstCheckValue As %String(MAXLEN = 100, TRUNCATE = 1);

/// 并发症情况
Property ComplicationInfoValue As %String(MAXLEN = 100, TRUNCATE = 1);

/// HBV-DNA定量
Property HBVDNA As %Float;

/// 同胞兄弟感染日期
Property DateOfBroInfection As %Date;

/// 同胞兄弟感染情况
Property bBroInfection As %String(MAXLEN = 5, TRUNCATE = 1);

/// 一次性注射器
Property bOneUseInje As %String(MAXLEN = 5, TRUNCATE = 1);

/// 重复使用注射器
Property bReUseInje As %String(MAXLEN = 5, TRUNCATE = 1);

/// 其它途径
Property OtherPass As %String(MAXLEN = 5, TRUNCATE = 1);

/// 发病时间
Property DateOfStart As %Date;

/// 乙肝两对半
Property HBVM As CHSS.DictHBVM;

/// 既往肝功能异常
Property bGOT As %String(MAXLEN = 5, TRUNCATE = 1);

Index PersonRowIdDRIndex On PersonRowIdDR [ Unique ];

Storage Default
{
<Data name="PersonHBVCheckHomeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DateOfFatherInfection</Value>
</Value>
<Value name="3">
<Value>DateOfFirstCheck</Value>
</Value>
<Value name="4">
<Value>DateOfMomInfection</Value>
</Value>
<Value name="5">
<Value>DateOfSonInfection</Value>
</Value>
<Value name="6">
<Value>DateOfVaccination</Value>
</Value>
<Value name="7">
<Value>DateOfspouseInfection</Value>
</Value>
<Value name="8">
<Value>DetailRowIdParref</Value>
</Value>
<Value name="9">
<Value>DiagnoseThen</Value>
</Value>
<Value name="10">
<Value>DosageOfVaccination</Value>
</Value>
<Value name="11">
<Value>FirstVaccination</Value>
</Value>
<Value name="12">
<Value>FrequencyOfMonitor</Value>
</Value>
<Value name="13">
<Value>GOT</Value>
</Value>
<Value name="14">
<Value>HBVContactHistory</Value>
</Value>
<Value name="15">
<Value>KindOfBlood</Value>
</Value>
<Value name="16">
<Value>Needles</Value>
</Value>
<Value name="17">
<Value>PersonRowIdDR</Value>
</Value>
<Value name="18">
<Value>SecondVaccination</Value>
</Value>
<Value name="19">
<Value>SexPartnerNum</Value>
</Value>
<Value name="20">
<Value>ThirdVaccination</Value>
</Value>
<Value name="21">
<Value>TimesOfVaccination</Value>
</Value>
<Value name="22">
<Value>Titer</Value>
</Value>
<Value name="23">
<Value>TreatEffection</Value>
</Value>
<Value name="24">
<Value>TreatInfo</Value>
</Value>
<Value name="25">
<Value>TypOfBlood</Value>
</Value>
<Value name="26">
<Value>TypeOfFirstCheck</Value>
</Value>
<Value name="27">
<Value>VaccinationPlace</Value>
</Value>
<Value name="28">
<Value>bBloodTransfusion</Value>
</Value>
<Value name="29">
<Value>bExposureHBV</Value>
</Value>
<Value name="30">
<Value>bFamilyCirrhosis</Value>
</Value>
<Value name="31">
<Value>bFamilyHBV</Value>
</Value>
<Value name="32">
<Value>bFatherInfection</Value>
</Value>
<Value name="33">
<Value>bFollowUp</Value>
</Value>
<Value name="34">
<Value>bFoottMassage</Value>
</Value>
<Value name="35">
<Value>bHairdressing</Value>
</Value>
<Value name="36">
<Value>bHaveComplication</Value>
</Value>
<Value name="37">
<Value>bHaveHBV</Value>
</Value>
<Value name="38">
<Value>bLiverCancer</Value>
</Value>
<Value name="39">
<Value>bMomInfection</Value>
</Value>
<Value name="40">
<Value>bMonitor</Value>
</Value>
<Value name="41">
<Value>bRelapse</Value>
</Value>
<Value name="42">
<Value>bReplant</Value>
</Value>
<Value name="43">
<Value>bSexPartner</Value>
</Value>
<Value name="44">
<Value>bSonInfection</Value>
</Value>
<Value name="45">
<Value>bSpouseInfection</Value>
</Value>
<Value name="46">
<Value>bTattoo</Value>
</Value>
<Value name="47">
<Value>bTreatThen</Value>
</Value>
<Value name="48">
<Value>bVaccination</Value>
</Value>
<Value name="49">
<Value>UseInjector</Value>
</Value>
<Value name="50">
<Value>bIVDrug</Value>
</Value>
<Value name="51">
<Value>bNotOneTIme</Value>
</Value>
<Value name="52">
<Value>bUseOneInjector</Value>
</Value>
<Value name="53">
<Value>AG</Value>
</Value>
<Value name="54">
<Value>ALB</Value>
</Value>
<Value name="55">
<Value>ALT</Value>
</Value>
<Value name="56">
<Value>AST</Value>
</Value>
<Value name="57">
<Value>DB</Value>
</Value>
<Value name="58">
<Value>GLOB</Value>
</Value>
<Value name="59">
<Value>TB</Value>
</Value>
<Value name="60">
<Value>ComplicationInfoValue</Value>
</Value>
<Value name="61">
<Value>StatusOfFirstCheckValue</Value>
</Value>
<Value name="62">
<Value>DateOfBroInfection</Value>
</Value>
<Value name="63">
<Value>DateOfStart</Value>
</Value>
<Value name="64">
<Value>HBVDNA</Value>
</Value>
<Value name="65">
<Value>HBVM</Value>
</Value>
<Value name="66">
<Value>OtherPass</Value>
</Value>
<Value name="67">
<Value>bBroInfection</Value>
</Value>
<Value name="68">
<Value>bOneUseInje</Value>
</Value>
<Value name="69">
<Value>bReUseInje</Value>
</Value>
<Value name="70">
<Value>bGOT</Value>
</Value>
</Data>
<DataLocation>^CHSS.PersonHBVCheckHomeD</DataLocation>
<DefaultData>PersonHBVCheckHomeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.PersonHBVCheckHomeD</IdLocation>
<IndexLocation>^CHSS.PersonHBVCheckHomeI</IndexLocation>
<StreamLocation>^CHSS.PersonHBVCheckHomeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
