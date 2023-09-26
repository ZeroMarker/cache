/// 医院
Class DHCCL.Config.Hospital Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = Hospital ]
{

/// 医院代码
Property Code As %String [ SqlColumnNumber = 2 ];

/// 医院名称
Property Description As %String [ SqlColumnNumber = 3 ];

/// 外部系统医院代码
Property ExtCode As %String [ SqlColumnNumber = 4 ];

/// 外部系统ID
Property ExternalID As %String [ SqlColumnNumber = 5 ];

Index Code On Code [ Unique ];

Index ExtID On ExternalID As Exact;

Storage Default
{
<Data name="HospitalDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>ExtCode</Value>
</Value>
<Value name="4">
<Value>ExternalID</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Config.HospitalD</DataLocation>
<DefaultData>HospitalDefaultData</DefaultData>
<IdLocation>^DHCCL.Config.HospitalD</IdLocation>
<IndexLocation>^DHCCL.Config.HospitalI</IndexLocation>
<StreamLocation>^DHCCL.Config.HospitalS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
