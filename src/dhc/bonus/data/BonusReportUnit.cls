Class dhc.bonus.data.BonusReportUnit Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusReportUnitID ]
{

Property BonusReportID As dhc.bonus.data.BonusReport [ SqlColumnNumber = 2 ];

Property BonusUnitID As dhc.bonus.data.BonusUnit [ SqlColumnNumber = 3 ];

Index BonusReporUnit On (BonusReportID, BonusUnitID);

Storage Default
{
<Data name="BonusReportUnitDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusReportID</Value>
</Value>
<Value name="3">
<Value>BonusUnitID</Value>
</Value>
</Data>
<DataLocation>^dhcbsBonusReportUnitD</DataLocation>
<DefaultData>BonusReportUnitDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsBonusReportUnitD</IdLocation>
<IndexLocation>^dhcbsBonusReportUnitI</IndexLocation>
<StreamLocation>^dhcbsBonusReportUnitS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
