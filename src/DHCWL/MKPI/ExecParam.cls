Class DHCWL.MKPI.ExecParam Extends %Persistent [ SqlTableName = ExecParam ]
{

Property KPICode As %String(COLLATION = "Exact") [ SqlColumnNumber = 2, SqlFieldName = Param_KPICode ];

Index ParamKPICodeIndex On KPICode;

Property Name As %String [ SqlColumnNumber = 3, SqlFieldName = Param_Name ];

Property Desc As %String [ SqlColumnNumber = 4, SqlFieldName = Param_Desc ];

Storage Default
{
<Data name="ExecParamDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RptCode</Value>
</Value>
<Value name="3">
<Value>RptDesc</Value>
</Value>
<Value name="4">
<Value>RptMMgrCode</Value>
</Value>
<Value name="5">
<Value>RptMMgrDR</Value>
</Value>
<Value name="6">
<Value>RptType</Value>
</Value>
<Value name="7">
<Value>RptDimProIDs</Value>
</Value>
<Value name="8">
<Value>RptDimProCodes</Value>
</Value>
<Value name="9">
<Value>Name</Value>
</Value>
<Value name="10">
<Value>Desc</Value>
</Value>
<Value name="11">
<Value>KPICode</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MKPI.ExecParamD</DataLocation>
<DefaultData>ExecParamDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.MKPI.ExecParamD</IdLocation>
<IndexLocation>^DHCWL.MKPI.ExecParamI</IndexLocation>
<StreamLocation>^DHCWL.MKPI.ExecParamS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
