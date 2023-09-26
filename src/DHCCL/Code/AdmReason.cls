Class DHCCL.Code.AdmReason Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = AdmReason ]
{

Property Code As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2 ];

Property Description As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3 ];

Property ActiveDate As %Date [ SqlColumnNumber = 4 ];

Property ExpireDate As %Date [ SqlColumnNumber = 5 ];

Property ExternalID As %String [ SqlColumnNumber = 6 ];

Index Code On Code [ Unique ];

Index Ext On ExternalID;

Storage Default
{
<Data name="AdmReasonDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>ActiveDate</Value>
</Value>
<Value name="4">
<Value>ExpireDate</Value>
</Value>
<Value name="5">
<Value>ExternalID</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Code.AdmReasonD</DataLocation>
<DefaultData>AdmReasonDefaultData</DefaultData>
<IdLocation>^DHCCL.Code.AdmReasonD</IdLocation>
<IndexLocation>^DHCCL.Code.AdmReasonI</IndexLocation>
<StreamLocation>^DHCCL.Code.AdmReasonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
