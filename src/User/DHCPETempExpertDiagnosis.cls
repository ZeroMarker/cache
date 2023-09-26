Class User.DHCPETempExpertDiagnosis Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = TED_RowId, SqlTableName = DHC_PE_TempExpertDiagnosis ]
{

Parameter ClassName = "User.DHCPETempExpertDiagnosis";

Property TEDDisplayName As %String [ SqlFieldName = TED_DisplayName ];

Property TEDResult As %String [ SqlFieldName = TED_Result ];

Property TEDAddUserDR As SSUser [ SqlFieldName = TED_AddUser_DR ];

Property TEDAddDate As %Library.Date [ SqlFieldName = TED_AddDate ];

Property TEDAddTime As %Library.Time [ SqlFieldName = TED_AddTime ];

Index DisplayNameIndex On TEDDisplayName As AlphaUp;

Storage Default
{
<Data name="DHCPETempExpertDiagnosisDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TEDDisplayName</Value>
</Value>
<Value name="3">
<Value>TEDResult</Value>
</Value>
<Value name="4">
<Value>TEDAddUserDR</Value>
</Value>
<Value name="5">
<Value>TEDAddDate</Value>
</Value>
<Value name="6">
<Value>TEDAddTime</Value>
</Value>
</Data>
<DataLocation>^User.DHCPETempExpertDiagnosisD</DataLocation>
<DefaultData>DHCPETempExpertDiagnosisDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPETempExpertDiagnosisD</IdLocation>
<IndexLocation>^User.DHCPETempExpertDiagnosisI</IndexLocation>
<StreamLocation>^User.DHCPETempExpertDiagnosisS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
