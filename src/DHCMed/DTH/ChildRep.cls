/// 名称:DHCMed.DTH.ChildRep
/// 描述: 5岁以下儿童死亡报告表
/// 编写者：wangCS
/// 编写日期: 2011-07-18
Class DHCMed.DTH.ChildRep Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 死亡报告
Property MainReportDR As DHCMed.DTH.Report;

/// 基本信息ID
Property PatientID As %String(TRUNCATE = 1);

/// 死亡证明编号
Property DeathNo As %String(TRUNCATE = 1);

/// 出生信息登记卡号
Property BirthRegNo As %String(TRUNCATE = 1);

/// 出生医学证明编号
Property BirthCerNo As %String(TRUNCATE = 1);

/// 儿童免疫接种卡号
Property ImmuneNo As %String(TRUNCATE = 1);

/// 户口地址
Property RegAddress As %String(TRUNCATE = 1);

/// 现住址
Property CurrAddress As %String(TRUNCATE = 1);

/// 户籍性质
Property Household As DHCMed.SS.Dictionary;

/// 患儿姓名
Property Name As %String(TRUNCATE = 1);

/// 父亲姓名
Property FatherName As %String(TRUNCATE = 1);

/// 母亲姓名
Property MotherName As %String(TRUNCATE = 1);

/// 出生体重 *克
Property Weight As %Numeric;

/// 称重方式
Property WeighedType As DHCMed.SS.Dictionary;

/// 孕周 *周
Property GestationalWeeks As %Numeric;

/// 出生地点
Property BirthPlace As %String(TRUNCATE = 1);

/// 死亡日期
Property DeathDate As %Date;

/// 死亡年龄 *岁*月*天
Property DeathAge As %String(TRUNCATE = 1);

/// A_直接导致死亡的疾病或情况
Property AReason As %String(TRUNCATE = 1);

/// B_引起A的疾病或情况
Property BReason As %String(TRUNCATE = 1);

/// C_引起B的疾病或情况
Property CReason As %String(TRUNCATE = 1);

/// 根本死因
Property BaseReason As %String(TRUNCATE = 1);

/// 根本死因ICD编码
Property BaseReasonICD As %String(TRUNCATE = 1);

/// 死因分类
Property DeathClassify As %String(TRUNCATE = 1);

/// 死亡地点 医院病房、急诊室、家中、赴医院途中、外地及其它、不详
Property DeathPlace As DHCMed.SS.Dictionary;

/// 死前治疗 住院、门诊、未治疗
Property AdmitType As DHCMed.SS.Dictionary;

/// 未治疗或未就医主要原因 经济困难、交通不便、来不及送医院、家长认为病情不严重、风俗习惯、其他（请注明）
Property NotCureReason As DHCMed.SS.Dictionary;

/// 诊断单位/诊断级别 省级医院、地市级医院、县区级医院、卫生院、村卫生室、未就诊、其它及不详
Property DiagnoseUnit As DHCMed.SS.Dictionary;

/// 死因诊断依据 尸检、病理、手术、临床+理化、临床、死后推断、不详
Property DiagnoseBasis As DHCMed.SS.Dictionary;

/// 报告编号
Property RepNo As %String(TRUNCATE = 1);

/// 报告科室
Property RepLocDR As User.CTLoc;

/// 报告人
Property RepUsrDR As User.SSUser;

/// 报告日期
Property RepDate As %Date;

/// 报告时间
Property RepTime As %Time;

/// 报告状态
Property RepStatusDR As DHCMed.SS.Dictionary;

Relationship ChildCDRReportStatus As DHCMed.DTH.ChildRepStatus [ Cardinality = children, Inverse = ParRef ];

Method ToString(separate As %String) As %String
{
	if ($g(separate)="")
	{
		set separate=..#SEPARATE
	}
	set return=..%Id()_separate
	
	
	
	quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AReason</Value>
</Value>
<Value name="3">
<Value>AdmitType</Value>
</Value>
<Value name="4">
<Value>BReason</Value>
</Value>
<Value name="5">
<Value>BaseReason</Value>
</Value>
<Value name="6">
<Value>BaseReasonICD</Value>
</Value>
<Value name="7">
<Value>BirthCerNo</Value>
</Value>
<Value name="8">
<Value>BirthPlace</Value>
</Value>
<Value name="9">
<Value>BirthRegNo</Value>
</Value>
<Value name="10">
<Value>CReason</Value>
</Value>
<Value name="11">
<Value>CurrAddress</Value>
</Value>
<Value name="12">
<Value>DeathAge</Value>
</Value>
<Value name="13">
<Value>DeathClassify</Value>
</Value>
<Value name="14">
<Value>DeathDate</Value>
</Value>
<Value name="15">
<Value>DeathNo</Value>
</Value>
<Value name="16">
<Value>DeathPlace</Value>
</Value>
<Value name="17">
<Value>DiagnoseBasis</Value>
</Value>
<Value name="18">
<Value>DiagnoseUnit</Value>
</Value>
<Value name="19">
<Value>FatherName</Value>
</Value>
<Value name="20">
<Value>GestationalWeeks</Value>
</Value>
<Value name="21">
<Value>Household</Value>
</Value>
<Value name="22">
<Value>ImmuneNo</Value>
</Value>
<Value name="23">
<Value>MainReportDR</Value>
</Value>
<Value name="24">
<Value>MotherName</Value>
</Value>
<Value name="25">
<Value>Name</Value>
</Value>
<Value name="26">
<Value>NotCureReason</Value>
</Value>
<Value name="27">
<Value>PatientID</Value>
</Value>
<Value name="28">
<Value>RegAddress</Value>
</Value>
<Value name="29">
<Value>RepDate</Value>
</Value>
<Value name="30">
<Value>RepLocDR</Value>
</Value>
<Value name="31">
<Value>RepNo</Value>
</Value>
<Value name="32">
<Value>RepStatusDR</Value>
</Value>
<Value name="33">
<Value>RepTime</Value>
</Value>
<Value name="34">
<Value>RepUsrDR</Value>
</Value>
<Value name="35">
<Value>WeighedType</Value>
</Value>
<Value name="36">
<Value>Weight</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DTH("CREP")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DTH("CREP")</IdLocation>
<IndexLocation>^DHCMed.DTHi("CREP")</IndexLocation>
<StreamLocation>^DHCMed.DTH.ChildRepS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
