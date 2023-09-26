/// 考核指标表
/// DHCWL_CheckFun.DHCWLCheckKPI d ##class(DHCWL.CheckFun.CheckKPI).%BuildIndices()
Class DHCWL.CheckFun.CheckKPI Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHCWLCheckKPI ]
{

/// 考核指标Code CheckKPI_Code
Property CheckKPICode As %String [ SqlColumnNumber = 2, SqlFieldName = CheckKPI_Code ];

/// 考核指标描述 CheckKPI_Desc
Property CheckKPIDesc As %String [ SqlColumnNumber = 3, SqlFieldName = CheckKPI_Desc ];

/// 有效标志 CheckKPI_Flag
Property CheckKPIFlag As %String [ SqlColumnNumber = 4, SqlFieldName = CheckKPI_Flag ];

/// 更新日期 CheckKPI_UpdateDate
Property CheckKPIUpdateDate As %Date [ SqlColumnNumber = 5, SqlFieldName = CheckKPI_UpdateDate ];

/// 更新用户 CheckKPI_UpdateUser	
Property CheckKPIUpdateUser As %String [ SqlColumnNumber = 6, SqlFieldName = CheckKPI_UpdateUser ];

Index Code On CheckKPICode As AlphaUp;

Index Desc On CheckKPIDesc;

Index Flag On CheckKPIFlag As AlphaUp;

Index UpdateDate On CheckKPIUpdateDate;

Index UpdateUser On CheckKPIUpdateUser;

Storage Default
{
<Data name="CheckKPIDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CheckKPICode</Value>
</Value>
<Value name="3">
<Value>CheckKPIDesc</Value>
</Value>
<Value name="4">
<Value>CheckKPIFlag</Value>
</Value>
<Value name="5">
<Value>CheckKPIUpdateDate</Value>
</Value>
<Value name="6">
<Value>CheckKPIUpdateUser</Value>
</Value>
</Data>
<DataLocation>^DHCWL.CheckFun.CheckKPID</DataLocation>
<DefaultData>CheckKPIDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.CheckFun.CheckKPID</IdLocation>
<IndexLocation>^DHCWL.CheckFun.CheckKPII</IndexLocation>
<StreamLocation>^DHCWL.CheckFun.CheckKPIS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
