/// ZB奖金指标采集
Class dhc.bonus.data.BonusTargetCollect Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusTargetCollectID ]
{

//Index TC On (BonusUnitID As Exact, BonusTargetID As Exact, BonusYear As Exact);

Index BsTarget On (BonusUnitID, BonusTargetID, BonusYear, BonusPeriod);

Property BonusTargetID As dhc.bonus.data.BonusTarget [ SqlColumnNumber = 2 ];

Property BonusUnitID As dhc.bonus.data.BonusUnit [ SqlColumnNumber = 3 ];

Property InterLocMethodID As dhc.bonus.inter.InterLocMethod [ SqlColumnNumber = 4 ];

Property BonusYear As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

Property BonusPeriod As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

Property DataSource As %Library.Integer [ SqlColumnNumber = 7 ];

Property TargetValue As %Library.Float [ SqlColumnNumber = 8 ];

Property AuditingState As %Library.Date [ SqlColumnNumber = 9 ];

Property AuditingDate As %Library.Date [ SqlColumnNumber = 10 ];

Property UpdateDate As %Library.TimeStamp [ SqlColumnNumber = 11 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 600, TRUNCATE = 0) [ SqlColumnNumber = 12 ];

Property UnitPrice As %Library.Float [ SqlColumnNumber = 13 ];

Storage Default
{
<Data name="BonusTargetCollectDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusTargetID</Value>
</Value>
<Value name="3">
<Value>BonusUnitID</Value>
</Value>
<Value name="4">
<Value>InterLocMethodID</Value>
</Value>
<Value name="5">
<Value>BonusYear</Value>
</Value>
<Value name="6">
<Value>BonusPeriod</Value>
</Value>
<Value name="7">
<Value>DataSource</Value>
</Value>
<Value name="8">
<Value>TargetValue</Value>
</Value>
<Value name="9">
<Value>AuditingState</Value>
</Value>
<Value name="10">
<Value>AuditingDate</Value>
</Value>
<Value name="11">
<Value>UpdateDate</Value>
</Value>
<Value name="12">
<Value>Remark</Value>
</Value>
<Value name="13">
<Value>UnitPrice</Value>
</Value>
</Data>
<DataLocation>^dhcbsBonusTargetCollectD</DataLocation>
<DefaultData>BonusTargetCollectDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsBonusTargetCollectD</IdLocation>
<IndexLocation>^dhcbsBonusTargetCollectI</IndexLocation>
<StreamLocation>^dhcbsBonusTargetCollectS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
