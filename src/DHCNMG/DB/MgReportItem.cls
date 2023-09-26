/// 
/// 护理月报类型
Class DHCNMG.DB.MgReportItem Extends %Persistent
{

Relationship ChildSub As DHCNMG.DB.MgReportItemSub [ Cardinality = children, Inverse = Parref ];

/// 类型
Property ReportType As %String [ SqlColumnNumber = 2, SqlFieldName = Report_Type ];

/// 序号
Property ReportSort As %Integer [ SqlColumnNumber = 3, SqlFieldName = Report_Sort ];

Property ReportUser As %Integer [ SqlColumnNumber = 4, SqlFieldName = Report_User ];

Property ReportWard As %String [ SqlColumnNumber = 5, SqlFieldName = Report_Ward ];

Index Type On ReportType;

Index Sort On ReportSort;

Storage Default
{
<Data name="MgReportItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReportType</Value>
</Value>
<Value name="3">
<Value>ReportSort</Value>
</Value>
<Value name="4">
<Value>ReportUser</Value>
</Value>
<Value name="5">
<Value>ReportWard</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.DB.MgReportItemD</DataLocation>
<DefaultData>MgReportItemDefaultData</DefaultData>
<IdLocation>^DHCNMG.DB.MgReportItemD</IdLocation>
<IndexLocation>^DHCNMG.DB.MgReportItemI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgReportItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
