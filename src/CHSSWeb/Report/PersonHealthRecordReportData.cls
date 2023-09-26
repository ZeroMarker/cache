Class CHSSWeb.Report.PersonHealthRecordReportData Extends (%Persistent, %Populate, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

Property PersonReportList As list Of CHSSWeb.Report.PersonHealthRecordReportObj(XMLPROJECTION = "ELEMENT", XMLTYPECONSTRAINT = "EXPLICIT");

Storage Default
{
<Data name="PersonHealthRecordReportDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PersonReportList</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.Rep4F9.PersonHealthB22D</DataLocation>
<DefaultData>PersonHealthRecordReportDataDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.Rep4F9.PersonHealthB22D</IdLocation>
<IndexLocation>^CHSSWeb.Rep4F9.PersonHealthB22I</IndexLocation>
<StreamLocation>^CHSSWeb.Rep4F9.PersonHealthB22S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
