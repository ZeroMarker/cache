Class dhc.bonus.data.BonusReport Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = BonusReportID ]
{

Property ReportCode As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

Property ReportName As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property IsValid As %Library.Integer [ SqlColumnNumber = 4 ];

Property ReportType As %Library.String [ SqlColumnNumber = 5 ];

Property IsPub As %Library.String [ SqlColumnNumber = 6 ];

Index RpCode On ReportCode As Exact;

Index RpName On ReportName As Exact;

Storage Default
{
<Data name="BonusReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReportCode</Value>
</Value>
<Value name="3">
<Value>ReportName</Value>
</Value>
<Value name="4">
<Value>IsValid</Value>
</Value>
<Value name="5">
<Value>ReportType</Value>
</Value>
<Value name="6">
<Value>IsPub</Value>
</Value>
</Data>
<DataLocation>^dhcbsReportD</DataLocation>
<DefaultData>BonusReportDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsReportD</IdLocation>
<IndexLocation>^dhcbsReportI</IndexLocation>
<StreamLocation>^dhcbsReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
