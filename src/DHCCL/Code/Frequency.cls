/// 医嘱频次
Class DHCCL.Code.Frequency Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = Frequency ]
{

Property Code As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2 ];

Property LocalDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3 ];

Property ForeignDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 4 ];

Property Days As %Float [ SqlColumnNumber = 5 ];

Property Factor As %Float [ SqlColumnNumber = 6 ];

Index Code On Code [ Unique ];

Storage Default
{
<Data name="FrequencyDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>LocalDesc</Value>
</Value>
<Value name="3">
<Value>ForeignDesc</Value>
</Value>
<Value name="4">
<Value>Days</Value>
</Value>
<Value name="5">
<Value>Factor</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Code.FrequencyD</DataLocation>
<DefaultData>FrequencyDefaultData</DefaultData>
<IdLocation>^DHCCL.Code.FrequencyD</IdLocation>
<IndexLocation>^DHCCL.Code.FrequencyI</IndexLocation>
<StreamLocation>^DHCCL.Code.FrequencyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
