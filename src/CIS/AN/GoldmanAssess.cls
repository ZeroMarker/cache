Class CIS.AN.GoldmanAssess Extends %Persistent [ SqlRowIdName = RowId, SqlTableName = GoldmanAssess ]
{

/// 手术计划
Property OperSchedule As CIS.AN.OperSchedule [ Required, SqlColumnNumber = 2 ];

/// 病史，心肌梗塞
Property MedHistory As %String [ SqlColumnNumber = 3 ];

/// 病史分数
Property MedHistoryScore As %String [ SqlColumnNumber = 4 ];

/// 年龄
Property Age As %String [ SqlColumnNumber = 5 ];

/// 年龄分数
Property AgeScore As %String [ SqlColumnNumber = 6 ];

/// 体检，心衰
Property PECardiacFailure As %String [ SqlColumnNumber = 7 ];

/// 体检，心衰分数
Property PECardiacFailureScore As %String [ SqlColumnNumber = 8 ];

/// 体检，主动脉瓣狭窄
Property PENarrowArtery As %String [ SqlColumnNumber = 9 ];

/// 体检，主动脉瓣狭窄分数
Property PENarrowArteryScore As %String [ SqlColumnNumber = 10 ];

/// 心电图
Property ECG As %String [ SqlColumnNumber = 11 ];

/// 心电图分数
Property ECGScore As %String [ SqlColumnNumber = 12 ];

/// 室性早搏
Property VPB As %String [ SqlColumnNumber = 13 ];

/// 室性早搏分数
Property VPBScore As %String [ SqlColumnNumber = 14 ];

/// 全身情况
Property GeneralCondition As %String(MAXLEN = 200) [ SqlColumnNumber = 15 ];

/// 全身情况分数
Property GeneralConditionScore As %String [ SqlColumnNumber = 16 ];

/// 胸腹腔或主动脉手术
Property ArteryOper As %String [ SqlColumnNumber = 17 ];

/// 胸腹腔或主动脉手术分数
Property ArteryOperScore As %String [ SqlColumnNumber = 18 ];

/// 急诊
Property Emergency As %String [ SqlColumnNumber = 19 ];

/// 急诊分数
Property EmergencyScore As %String [ SqlColumnNumber = 20 ];

/// 总分
Property TotalScore As %String [ SqlColumnNumber = 21 ];

/// 结果
Property Result As %String [ SqlColumnNumber = 22 ];

/// 死亡率
Property MortalityRate As %String [ SqlColumnNumber = 23 ];

/// 病情描述
Property Note As %String [ SqlColumnNumber = 24 ];

/// 评估结果扩展描述
Property ResultDesc As %String [ SqlColumnNumber = 25 ];

Property AssessUser As %String [ SqlColumnNumber = 26 ];

Property AssessDate As %Date [ SqlColumnNumber = 27 ];

Property AssessTime As %Time [ SqlColumnNumber = 28 ];

Index IOPS On OperSchedule;

/// 手术申请外键约束
ForeignKey FKOperSchedule(OperSchedule) References CIS.AN.OperSchedule() [ OnDelete = cascade ];

Storage Default
{
<Data name="GoldmanAssessDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OperSchedule</Value>
</Value>
<Value name="3">
<Value>MedHistory</Value>
</Value>
<Value name="4">
<Value>MedHistoryScore</Value>
</Value>
<Value name="5">
<Value>Age</Value>
</Value>
<Value name="6">
<Value>AgeScore</Value>
</Value>
<Value name="7">
<Value>PECardiacFailure</Value>
</Value>
<Value name="8">
<Value>PECardiacFailureScore</Value>
</Value>
<Value name="9">
<Value>PENarrowArtery</Value>
</Value>
<Value name="10">
<Value>PENarrowArteryScore</Value>
</Value>
<Value name="11">
<Value>ECG</Value>
</Value>
<Value name="12">
<Value>ECGScore</Value>
</Value>
<Value name="13">
<Value>VPB</Value>
</Value>
<Value name="14">
<Value>VPBScore</Value>
</Value>
<Value name="15">
<Value>GeneralCondition</Value>
</Value>
<Value name="16">
<Value>GeneralConditionScore</Value>
</Value>
<Value name="17">
<Value>ArteryOper</Value>
</Value>
<Value name="18">
<Value>ArteryOperScore</Value>
</Value>
<Value name="19">
<Value>Emergency</Value>
</Value>
<Value name="20">
<Value>EmergencyScore</Value>
</Value>
<Value name="21">
<Value>TotalScore</Value>
</Value>
<Value name="22">
<Value>Result</Value>
</Value>
<Value name="23">
<Value>MortalityRate</Value>
</Value>
<Value name="24">
<Value>Note</Value>
</Value>
<Value name="25">
<Value>ResultDesc</Value>
</Value>
<Value name="26">
<Value>AssessUser</Value>
</Value>
<Value name="27">
<Value>AssessDate</Value>
</Value>
<Value name="28">
<Value>AssessTime</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.GoldmanAssessD</DataLocation>
<DefaultData>GoldmanAssessDefaultData</DefaultData>
<IdLocation>^CIS.AN.GoldmanAssessD</IdLocation>
<IndexLocation>^CIS.AN.GoldmanAssessI</IndexLocation>
<StreamLocation>^CIS.AN.GoldmanAssessS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
