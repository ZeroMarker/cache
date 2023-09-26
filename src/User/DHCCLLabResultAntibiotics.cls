Class User.DHCCLLabResultAntibiotics Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = CLLRA_RowId, SqlTableName = DHC_CL_LabResultAntibiotics, StorageStrategy = CacheStorage ]
{

Property CLLRACLLRADr As %String [ SqlColumnNumber = 2, SqlFieldName = CLLRA_CLLRA_Dr ];

Property CLLRAWhoNetCode As %String [ SqlColumnNumber = 3, SqlFieldName = CLLRA_WhoNetCode ];

Property CLLRAAntibioticsDesc As %String [ SqlColumnNumber = 4, SqlFieldName = CLLRA_AntibioticsDesc ];

Property CLLRASensitivityResult As %String [ SqlColumnNumber = 5, SqlFieldName = CLLRA_SensitivityResult ];

Property CLLRASensitivityMethod As %String(DISPLAYLIST = ",KB,MIC", VALUELIST = ",KB,MIC") [ SqlColumnNumber = 6, SqlFieldName = CLLRA_SensitivityMethod ];

Property CLLRASensitivityValue As %String [ SqlColumnNumber = 7, SqlFieldName = CLLRA_SensitivityValue ];

Index LabResult On CLLRACLLRADr As Exact;

Storage CacheStorage
{
<Data name="DHCCLLabResultAntibioticsClass">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCCLLabResultAntibioticsData">
<Value name="1">
<Value>CLLRACLLRADr</Value>
</Value>
<Value name="2">
<Value>CLLRAWhoNetCode</Value>
</Value>
<Value name="3">
<Value>CLLRAAntibioticsDesc</Value>
</Value>
<Value name="4">
<Value>CLLRASensitivityResult</Value>
</Value>
<Value name="5">
<Value>CLLRASensitivityMethod</Value>
</Value>
<Value name="6">
<Value>CLLRASensitivityValue</Value>
</Value>
</Data>
<DataLocation>^DHCCLLabResultAntibiotics</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCLLabResultAntibiotics</IdLocation>
<IndexLocation>^DHCCLLabResultAntibiotics(0)</IndexLocation>
<StreamLocation>^User.DHCCLLabRes1D8ES</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
