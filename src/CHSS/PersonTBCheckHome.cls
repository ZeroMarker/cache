Class CHSS.PersonTBCheckHome Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = TBHomeRowId, SqlTableName = PersonTBCheckHome ]
{

/// 外键
Property PersonRowIdDR As CHSS.PersonHealthRecordMain [ Required ];

/// 咳嗽、咳痰
Property bCough As %String(MAXLEN = 5, TRUNCATE = 1);

/// 咳嗽开始时间
Property CoughStartDate As %Date(FORMAT = 1);

/// 咳嗽结束时间
Property CoughEndDate As %Date(FORMAT = 1);

/// 咳血
Property bEmptysis As %String(MAXLEN = 5, TRUNCATE = 1);

/// 咳血开始时间
Property EmptysisStartDate As %Date(FORMAT = 1);

/// 咳血结束时间
Property EmptysisEndDate As %Date(FORMAT = 1);

/// 卡介苗接种史
Property bBCG As %String(MAXLEN = 5, TRUNCATE = 1);

/// 肝病史
Property bCirrhosis As %String(MAXLEN = 5, TRUNCATE = 1);

/// 肾病史
Property bNephrotic As %String(MAXLEN = 5, TRUNCATE = 1);

/// 与结核患者密切接触史
Property bContact As %String(MAXLEN = 5, TRUNCATE = 1);

/// 药物过敏史
Property DrugAllergy As %String(MAXLEN = 5, TRUNCATE = 1);

/// 进入城市谋业的流动人口
Property bShiftingPopulation As %String(MAXLEN = 5, TRUNCATE = 1);

/// 托幼机构职工及中小学教职工
Property bTeacher As %String(MAXLEN = 5, TRUNCATE = 1);

/// 卫生服务行业职工
Property bHealthServiceIndustry As %String(MAXLEN = 5, TRUNCATE = 1);

/// 接触职业性有害物质的厂矿、企业职工
Property bContactHarmfulSubstance As %String(MAXLEN = 5, TRUNCATE = 1);

/// 糖尿病
Property bDiabetes As %String(MAXLEN = 5, TRUNCATE = 1);

/// 免疫抑制剂治疗
Property bInfectionCure As %String(MAXLEN = 5, TRUNCATE = 1);

/// 矽肺
Property bSilicosis As %String(MAXLEN = 5, TRUNCATE = 1);

/// 艾滋病
Property bAIDS As %String(MAXLEN = 5, TRUNCATE = 1);

/// 首次确诊时间
Property DateOfFirtCheck As %Date(FORMAT = 1);

/// 抗结核治疗史
Property bCureHistory As %String(MAXLEN = 5, TRUNCATE = 1);

/// 首次治疗日期
Property DateOfFirstCure As %Date(FORMAT = 1);

/// 是否规则用药
Property bEatDrugRegular As %String(MAXLEN = 5, TRUNCATE = 1);

/// 其他药物
Property OtherDrug As %String(MAXLEN = 60, TRUNCATE = 1);

/// 其他药物开始时间
Property DateOfOther As %Date(FORMAT = 1);

/// 实际治疗管理方式
Property CureMangeType As CHSS.DictCureManageType;

/// HIV已开始抗病毒治疗
Property bHIVCure As %String(MAXLEN = 5, TRUNCATE = 1);

/// HIV开始治疗日期
Property DateOfCure As %Date(FORMAT = 1);

/// CPT治疗
Property bCPTCure As %String(MAXLEN = 5, TRUNCATE = 1);

/// CPT治疗开始日期
Property DateOfCPTCure As %Date(FORMAT = 1);

/// 停止治疗日期
Property DateOfStopCure As %Date(FORMAT = 1);

/// 其他病史
Property other As %String(MAXLEN = 100, TRUNCATE = 1);

/// 停止治疗原因
Property ReasonOfStopCure As CHSS.DictReasonOfStopCure;

Index PersonRowIdDRIndex On PersonRowIdDR [ Unique ];

Storage Default
{
<Data name="PersonTBCheckHomeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CoughTime</Value>
</Value>
<Value name="3">
<Value>CureMangeType</Value>
</Value>
<Value name="4">
<Value>DateOfCPTCure</Value>
</Value>
<Value name="5">
<Value>DateOfCure</Value>
</Value>
<Value name="6">
<Value>DateOfFirstCure</Value>
</Value>
<Value name="7">
<Value>DateOfFirtCheck</Value>
</Value>
<Value name="8">
<Value>DateOfLFP</Value>
</Value>
<Value name="9">
<Value>DateOfLFPD</Value>
</Value>
<Value name="10">
<Value>DateOfLMS</Value>
</Value>
<Value name="11">
<Value>DateOfOther</Value>
</Value>
<Value name="12">
<Value>DateOfPQXA</Value>
</Value>
<Value name="13">
<Value>DateOfStopCure</Value>
</Value>
<Value name="14">
<Value>DateOfYADC</Value>
</Value>
<Value name="15">
<Value>DateOfYYJ</Value>
</Value>
<Value name="16">
<Value>DrugAllergy</Value>
</Value>
<Value name="17">
<Value>EmptysisTime</Value>
</Value>
<Value name="18">
<Value>OtherDrug</Value>
</Value>
<Value name="19">
<Value>ReasonOfStopCure</Value>
</Value>
<Value name="20">
<Value>bAIDS</Value>
</Value>
<Value name="21">
<Value>bBCG</Value>
</Value>
<Value name="22">
<Value>bCPTCure</Value>
</Value>
<Value name="23">
<Value>bCirrhosis</Value>
</Value>
<Value name="24">
<Value>bContact</Value>
</Value>
<Value name="25">
<Value>bContactHarmfulSubstance</Value>
</Value>
<Value name="26">
<Value>bCough</Value>
</Value>
<Value name="27">
<Value>bCureHistory</Value>
</Value>
<Value name="28">
<Value>bDiabetes</Value>
</Value>
<Value name="29">
<Value>bEatDrugRegular</Value>
</Value>
<Value name="30">
<Value>bEmptysis</Value>
</Value>
<Value name="31">
<Value>bHIVCure</Value>
</Value>
<Value name="32">
<Value>bHealthServiceIndustry</Value>
</Value>
<Value name="33">
<Value>bInfectionCure</Value>
</Value>
<Value name="34">
<Value>bNephrotic</Value>
</Value>
<Value name="35">
<Value>bShiftingPopulation</Value>
</Value>
<Value name="36">
<Value>bSilicosis</Value>
</Value>
<Value name="37">
<Value>bTeacher</Value>
</Value>
<Value name="38">
<Value>CoughEndDate</Value>
</Value>
<Value name="39">
<Value>CoughStartDate</Value>
</Value>
<Value name="40">
<Value>EmptysisEndDate</Value>
</Value>
<Value name="41">
<Value>EmptysisStartDate</Value>
</Value>
<Value name="42">
<Value>PersonRowIdParref</Value>
</Value>
<Value name="43">
<Value>PersonRowIdDR</Value>
</Value>
<Value name="44">
<Value>other</Value>
</Value>
</Data>
<DataLocation>^CHSS.PersonTBCheckHomeD</DataLocation>
<DefaultData>PersonTBCheckHomeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.PersonTBCheckHomeD</IdLocation>
<IndexLocation>^CHSS.PersonTBCheckHomeI</IndexLocation>
<StreamLocation>^CHSS.PersonTBCheckHomeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
