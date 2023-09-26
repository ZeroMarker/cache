Class CHSS.PersonYearCheckTB Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = TBRowId, SqlTableName = PersonYearCheckTB ]
{

//Relationship YearCheckRowIdParref As CHSS.PersonYearCheckRecord [ Cardinality = parent, Inverse = ChildPersonYearCheckTB, Required, SqlFieldName = YearCheckRowIdParref ];

Property YearCheckRowIdParref As CHSS.PersonYearCheckRecord [ Required ];

/// 结素试验（PPD）结果
Property PPDResult As %String(MAXLEN = 5, TRUNCATE = 1);

/// PPD实验日期
Property DateOfPPD As %Date(FORMAT = 1);

/// 空洞
Property Inanition As %String(MAXLEN = 5, TRUNCATE = 1);

/// X线号
Property XRayNum As %String(MAXLEN = 100, TRUNCATE = 1);

/// 痰涂片检查结果
Property SputumSmearResult As CHSS.DictSputumSmearResult;

/// 痰涂片阳性
Property SputumSmearResultR As %String(MAXLEN = 100, TRUNCATE = 1);

/// 痰涂片未检查原因
Property ReasonOfNotCheckSS As %String(MAXLEN = 60, TRUNCATE = 1);

/// 痰涂片检查日期
Property DateOfSputumSmear As %Date(FORMAT = 1);

/// 痰培养检查结果
Property SputumCultureResult As CHSS.DictSputumCultureResult;

///  痰培养阳性
Property SputumCultureResultR As %String(MAXLEN = 100, TRUNCATE = 1);

/// 痰培养未检查原因
Property ReasonOfNotCheckSC As %String(MAXLEN = 60, TRUNCATE = 1);

/// 痰培养检查日期
Property DateOfCheckSC As %Date(FORMAT = 1);

/// 药敏试验-H
Property DrugSensitiveTestH As CHSS.DictDrugSensitiveTest;

/// 药敏试验-R
Property DrugSensitiveTestR As CHSS.DictDrugSensitiveTest;

/// 药敏试验-E
Property DrugSensitiveTestE As CHSS.DictDrugSensitiveTest;

/// 药敏试验-S
Property DrugSensitiveTestS As CHSS.DictDrugSensitiveTest;

/// HIV抗体检测
Property HIVTest As CHSS.DictHIVTest;

/// CD4细胞检测值
Property CD4 As %String(MAXLEN = 10, TRUNCATE = 1);

/// HIV抗体检测日期
Property DateOfHIVTest As %Date(FORMAT = 1);

/// 本次治疗日期
Property DateOfCheck As %Date(FORMAT = 1);

/// 治疗分类
Property CureType As CHSS.DictCureType;

/// 治疗方案
Property CurePlan As %String(MAXLEN = 100, TRUNCATE = 1);

/// 抗结核药物费用支付方式
Property PayType As CHSS.DictPayType;

/// 治疗管理方式
Property CureManageType As CHSS.DictCureManageType;

/// 变更方案
Property CurePlanChange As %String(MAXLEN = 100, TRUNCATE = 1);

/// 变更日期
Property DateOfPlanChange As %Date(FORMAT = 1);

/// 药敏试验结果报告时间
Property DateOfDrugSensitiveTest As %Date(FORMAT = 1);

Index YearCheckRowIdParrefIndex On YearCheckRowIdParref [ Unique ];

Storage Default
{
<Data name="PersonYearCheckTBDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CD4</Value>
</Value>
<Value name="3">
<Value>CureManageType</Value>
</Value>
<Value name="4">
<Value>CurePlan</Value>
</Value>
<Value name="5">
<Value>CurePlanChange</Value>
</Value>
<Value name="6">
<Value>CureType</Value>
</Value>
<Value name="7">
<Value>DateOfCheck</Value>
</Value>
<Value name="8">
<Value>DateOfCheckSC</Value>
</Value>
<Value name="9">
<Value>DateOfHIVTest</Value>
</Value>
<Value name="10">
<Value>DateOfPPD</Value>
</Value>
<Value name="11">
<Value>DateOfPlanChange</Value>
</Value>
<Value name="12">
<Value>DateOfSputumSmear</Value>
</Value>
<Value name="13">
<Value>DrugSensitiveTestE</Value>
</Value>
<Value name="14">
<Value>DrugSensitiveTestH</Value>
</Value>
<Value name="15">
<Value>DrugSensitiveTestR</Value>
</Value>
<Value name="16">
<Value>DrugSensitiveTestS</Value>
</Value>
<Value name="17">
<Value>HIVTest</Value>
</Value>
<Value name="18">
<Value>Inanition</Value>
</Value>
<Value name="19">
<Value>PPDResult</Value>
</Value>
<Value name="20">
<Value>PayType</Value>
</Value>
<Value name="21">
<Value>ReasonOfNotCheckSC</Value>
</Value>
<Value name="22">
<Value>ReasonOfNotCheckSS</Value>
</Value>
<Value name="23">
<Value>SputumCultureResult</Value>
</Value>
<Value name="24">
<Value>SputumSmearResult</Value>
</Value>
<Value name="25">
<Value>XRayNum</Value>
</Value>
<Value name="26">
<Value>XRayResult</Value>
</Value>
<Value name="27">
<Value>YearCheckRowIdParref</Value>
</Value>
<Value name="28">
<Value>SputumSmearResultR</Value>
</Value>
<Value name="29">
<Value>SputumCultureResultR</Value>
</Value>
<Value name="30">
<Value>DateOfDrugSensitiveTest</Value>
</Value>
</Data>
<DataLocation>^CHSS.PersonYearCheckTBD</DataLocation>
<DefaultData>PersonYearCheckTBDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.PersonYearCheckTBD</IdLocation>
<IndexLocation>^CHSS.PersonYearCheckTBI</IndexLocation>
<StreamLocation>^CHSS.PersonYearCheckTBS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
