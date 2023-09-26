Class dhc.bonus.data.BonusReportCell Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusReportCellID ]
{

Property BonusReportID As dhc.bonus.data.BonusReport [ SqlColumnNumber = 2 ];

Property BonusSchemeItemID As dhc.bonus.data.BonusSchemeItem [ SqlColumnNumber = 3 ];

Property ReportIndex As %Library.String [ SqlColumnNumber = 4 ];

Property IsValid As %Library.Integer [ SqlColumnNumber = 5 ];

Property BonusTargetID As dhc.bonus.data.BonusTarget [ SqlColumnNumber = 6 ];

Property CellType As %Library.String [ SqlColumnNumber = 7 ];

Property CellName As %Library.String [ SqlColumnNumber = 8 ];

Property DefineValue As %Library.String [ SqlColumnNumber = 9 ];

Property FontBold As %Library.String [ SqlColumnNumber = 10 ];

Property BackColor As %Library.String [ SqlColumnNumber = 11 ];

Index ReportItem On (BonusReportID, BonusSchemeItemID);

Storage Default
{
<Data name="BonusReportCellDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BonusReportID</Value>
</Value>
<Value name="3">
<Value>BonusSchemeItemID</Value>
</Value>
<Value name="4">
<Value>ReportIndex</Value>
</Value>
<Value name="5">
<Value>IsValid</Value>
</Value>
<Value name="6">
<Value>BonusTargetID</Value>
</Value>
<Value name="7">
<Value>CellType</Value>
</Value>
<Value name="8">
<Value>CellName</Value>
</Value>
<Value name="9">
<Value>DefineValue</Value>
</Value>
<Value name="10">
<Value>FontBold</Value>
</Value>
<Value name="11">
<Value>BackColor</Value>
</Value>
</Data>
<DataLocation>^dhcbsReportCellD</DataLocation>
<DefaultData>BonusReportCellDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsReportCellD</IdLocation>
<IndexLocation>^dhcbsReportCellI</IndexLocation>
<StreamLocation>^dhcbsReportCellS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
