Class User.DHCANOPPACK Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlTableName = DHC_AN_OPPACK ]
{

Property PackCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = Pack_Code ];

Property PackDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = Pack_Desc ];

Storage Default
{
<Data name="DHCANOPPACKDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PackCode</Value>
</Value>
<Value name="3">
<Value>PackDesc</Value>
</Value>
</Data>
<DataLocation>^User.DHCANOPPACKD</DataLocation>
<DefaultData>DHCANOPPACKDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCANOPPACKD</IdLocation>
<IndexLocation>^User.DHCANOPPACKI</IndexLocation>
<StreamLocation>^User.DHCANOPPACKS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
