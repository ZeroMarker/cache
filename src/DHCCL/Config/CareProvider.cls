/// 医护人员
Class DHCCL.Config.CareProvider Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = CareProvider ]
{

/// 医护人员代码
Property Code As %String [ Required, SqlColumnNumber = 2 ];

/// 医护人员名称
Property Description As %String [ Required, SqlColumnNumber = 3 ];

/// 医护人员简称
Property ShortName As %String [ SqlColumnNumber = 4 ];

/// 医护人员激活日期
Property ActiveDate As %Date [ SqlColumnNumber = 5 ];

/// 医护人员失效日期
Property ExpireDate As %Date [ SqlColumnNumber = 6 ];

/// 医护人员类型
Property ProvType As DHCCL.Code.CareProvType [ SqlColumnNumber = 7 ];

/// 外部系统医护人员ID
Property ExternalID As %String [ SqlColumnNumber = 8 ];

Index Type On ProvType;

Index Ext On ExternalID;

Index Code On Code [ Unique ];

Storage Default
{
<Data name="CareProviderDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>ShortName</Value>
</Value>
<Value name="4">
<Value>ActiveDate</Value>
</Value>
<Value name="5">
<Value>ExpireDate</Value>
</Value>
<Value name="6">
<Value>ProvType</Value>
</Value>
<Value name="7">
<Value>ExternalID</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Config.CareProviderD</DataLocation>
<DefaultData>CareProviderDefaultData</DefaultData>
<IdLocation>^DHCCL.Config.CareProviderD</IdLocation>
<IndexLocation>^DHCCL.Config.CareProviderI</IndexLocation>
<StreamLocation>^DHCCL.Config.CareProviderS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
