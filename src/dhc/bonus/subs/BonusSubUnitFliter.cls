/// SH奖金辅助科室过滤BonusUnitFliter
/// 
/// 1：开单科室
/// 2：执行科室
/// 3：病人科室
/// 4：开单医生
/// 5：执行医生
Class dhc.bonus.subs.BonusSubUnitFliter Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusSubUnitFliterID ]
{

Property BonusTargetID As dhc.bonus.data.BonusTarget [ SqlColumnNumber = 2 ];

Property BonusUnitFlagCode As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property BonusUnitFlagName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

Index BonusTargetIDIndex On BonusTargetID As exact;

Index TargetUnit On (BonusTargetID, BonusUnitFlagCode);

Storage Default
{
<Data name="BonusSubUnitFliterDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusTargetID</Value>
</Value>
<Value name="3">
<Value>BonusUnitFlagCode</Value>
</Value>
<Value name="4">
<Value>BonusUnitFlagName</Value>
</Value>
</Data>
<DataLocation>^dhcbsSubUnitFliterD</DataLocation>
<DefaultData>BonusSubUnitFliterDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsSubUnitFliterD</IdLocation>
<IndexLocation>^dhcbsSubUnitFliterI</IndexLocation>
<StreamLocation>^dhcbsSubUnitFliterS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
