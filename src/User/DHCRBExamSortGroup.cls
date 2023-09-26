Class User.DHCRBExamSortGroup Extends (%Persistent, %XML.Adaptor) [ Inheritance = right, SqlTableName = DHCRB_ExamSortGroup ]
{

Property GroupName As %String;

Property GroupCode As %String;

Property GroupDesc As %String;

Index CodeIndex On GroupCode As AlphaUp;

Storage Default
{
<Data name="DHCRBExamSortGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GroupCode</Value>
</Value>
<Value name="3">
<Value>GroupDesc</Value>
</Value>
<Value name="4">
<Value>GroupName</Value>
</Value>
</Data>
<DataLocation>^User.DHCRBExamSortGroupD</DataLocation>
<DefaultData>DHCRBExamSortGroupDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCRBExamSortGroupD</IdLocation>
<IndexLocation>^User.DHCRBExamSortGroupI</IndexLocation>
<StreamLocation>^User.DHCRBExamSortGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
