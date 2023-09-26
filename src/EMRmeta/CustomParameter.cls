Class EMRmeta.CustomParameter Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property Description As %String(TRUNCATE = 1);

Property Name As %String(TRUNCATE = 1);

Property ParameterName As %String(TRUNCATE = 1);

Property ParameterType As %String(TRUNCATE = 1);

Property QueryID As %String(TRUNCATE = 1);

ClassMethod DelParameterByQueryId(AQueryID As %String)
{
 &sql(
 Delete 
 from EMRmeta.CustomParameter
 Where QueryID =:AQueryID )
}

Query SelectAllQuery() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Name:%String,Description:%String,ParameterName:%String,ParameterType:%String,QueryID:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_CustomParameter_SELECTALLQuery, SqlProc ]
{
 SELECT ID, Name, Description, ParameterName,ParameterType,QueryID
 FROM EMRmeta.CustomParameter
 ORDER BY ID
}

Query SelectParameterByQueryID(AQuetyID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,Name:%String,Description:%String,ParameterName:%String,ParameterType:%String,QueryID:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_CustomParameter_SelectParameterByQueryID, SqlProc ]
{
 SELECT ID, Name, Description, ParameterName,ParameterType,QueryID
 FROM EMRmeta.CustomParameter
 Where QueryID= :AQuetyID
 ORDER BY ID
}

Storage Default
{
<Data name="CustomParameterDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>ParameterName</Value>
</Value>
<Value name="5">
<Value>ParameterType</Value>
</Value>
<Value name="6">
<Value>QueryID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.CustomParameterD</DataLocation>
<DefaultData>CustomParameterDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.CustomParameterD</IdLocation>
<IndexLocation>^DHCEMRM.CustomParameterI</IndexLocation>
<StreamLocation>^DHCEMRM.CustomParameterS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
