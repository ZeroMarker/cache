/// 指标计提系数设置
Class dhc.bonus.data.TargetCalculateRate Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = TargetCalculateRateID ]
{

Property BonusUnitID As dhc.bonus.data.BonusUnit [ SqlColumnNumber = 2 ];

Property BonusTargetID As dhc.bonus.data.BonusTarget [ SqlColumnNumber = 3 ];

Property RateType As %Library.Integer [ SqlColumnNumber = 4 ];

Property TargetUnit As dhc.bonus.data.CalUnit [ SqlColumnNumber = 5 ];

Property StartLimit As %Library.Float [ SqlColumnNumber = 6 ];

Property EndLimit As %Library.Float [ SqlColumnNumber = 7 ];

Property TargetDirection As %Library.Integer [ SqlColumnNumber = 8 ];

Property StepSize As %Library.Float [ SqlColumnNumber = 9 ];

Property AccountBase As %Library.Float [ SqlColumnNumber = 10 ];

Property TargetRate As %Library.Float [ SqlColumnNumber = 11 ];

Property IsValid As %Library.Integer [ SqlColumnNumber = 12 ];

Property AdjustPerson As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 13 ];

Property AdjustDate As %Library.Date [ SqlColumnNumber = 14 ];

Property AuditingPerson As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 15 ];

Property AuditingDate As %Library.TimeStamp [ SqlColumnNumber = 16 ];

Property AuditingState As %Library.Integer [ Required, SqlColumnNumber = 17 ];

Property UpdateDate As %Library.TimeStamp [ SqlColumnNumber = 18 ];

Property ParameterTarget As dhc.bonus.data.BonusTarget [ SqlColumnNumber = 19 ];

Property BonusSchemeID As dhc.bonus.data.BonusScheme [ SqlColumnNumber = 20 ];

Property TargetTrend As %Library.String [ SqlColumnNumber = 21 ];

Index TargetScheme On (BonusTargetID As Exact, BonusSchemeID As Exact);

Index TargetUnit On (BonusTargetID, BonusUnitID);

Index SchemeTargetUnit On (BonusSchemeID, BonusTargetID, BonusUnitID);

Storage Default
{
<Data name="TargetCalculateRateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusUnitID</Value>
</Value>
<Value name="3">
<Value>BonusTargetID</Value>
</Value>
<Value name="4">
<Value>RateType</Value>
</Value>
<Value name="5">
<Value>TargetUnit</Value>
</Value>
<Value name="6">
<Value>StartLimit</Value>
</Value>
<Value name="7">
<Value>EndLimit</Value>
</Value>
<Value name="8">
<Value>TargetDirection</Value>
</Value>
<Value name="9">
<Value>StepSize</Value>
</Value>
<Value name="10">
<Value>AccountBase</Value>
</Value>
<Value name="11">
<Value>TargetRate</Value>
</Value>
<Value name="12">
<Value>IsValid</Value>
</Value>
<Value name="13">
<Value>AdjustPerson</Value>
</Value>
<Value name="14">
<Value>AdjustDate</Value>
</Value>
<Value name="15">
<Value>AuditingPerson</Value>
</Value>
<Value name="16">
<Value>AuditingDate</Value>
</Value>
<Value name="17">
<Value>AuditingState</Value>
</Value>
<Value name="18">
<Value>UpdateDate</Value>
</Value>
<Value name="19">
<Value>ParameterTarget</Value>
</Value>
<Value name="20">
<Value>BonusSchemeID</Value>
</Value>
<Value name="21">
<Value>TargetTrend</Value>
</Value>
</Data>
<DataLocation>^dhcbsTargetCalculateRateD</DataLocation>
<DefaultData>TargetCalculateRateDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsTargetCalculateRateD</IdLocation>
<IndexLocation>^dhcbsTargetCalculateRateI</IndexLocation>
<StreamLocation>^dhcbsTargetCalculateRateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
