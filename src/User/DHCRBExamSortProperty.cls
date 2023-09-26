Class User.DHCRBExamSortProperty Extends (%Persistent, %XML.Adaptor) [ Inheritance = right, SqlTableName = DHCRB_ExamSortProperty ]
{

Property SortGroupId As DHCRBExamSortGroup [ SqlFieldName = ExamSortGroupId ];

Property ItmMastDr As ARCItmMast [ Required ];

Property IsSort As %String;

Property StartDate As %Date;

Property EndDate As %Date;

Property ExamTime As %String;

Index ItmMastIndex On ItmMastDr;

Index SortGroupIndex On SortGroupId As AlphaUp;

Property IsAutoSendAppBill As %String;

Storage Default
{
<Data name="DHCRBExamSortPropertyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EndDate</Value>
</Value>
<Value name="3">
<Value>ExamTime</Value>
</Value>
<Value name="4">
<Value>IsSort</Value>
</Value>
<Value name="5">
<Value>ItmMastDr</Value>
</Value>
<Value name="6">
<Value>SortGroupId</Value>
</Value>
<Value name="7">
<Value>StartDate</Value>
</Value>
<Value name="8">
<Value>IsAutoSendAppBill</Value>
</Value>
</Data>
<DataLocation>^User.DHCRBExamSortPropertyD</DataLocation>
<DefaultData>DHCRBExamSortPropertyDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCRBExamSortPropertyD</IdLocation>
<IndexLocation>^User.DHCRBExamSortPropertyI</IndexLocation>
<StreamLocation>^User.DHCRBExamSortPropertyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
