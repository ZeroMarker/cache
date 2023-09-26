/// 诊断别名
Class DHCCL.Config.DiagAlias Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = DiagAlias ]
{

Property Diagnosis As DHCCL.Config.Diagnosis [ SqlColumnNumber = 2 ];

Property ShortText As %String [ SqlColumnNumber = 3 ];

Index Text On ShortText;

Storage Default
{
<Data name="DiagAliasDefaultData">
<Value name="1">
<Value>Diagnosis</Value>
</Value>
<Value name="2">
<Value>ShortText</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Config.DiagAliasD</DataLocation>
<DefaultData>DiagAliasDefaultData</DefaultData>
<IdLocation>^DHCCL.Config.DiagAliasD</IdLocation>
<IndexLocation>^DHCCL.Config.DiagAliasI</IndexLocation>
<StreamLocation>^DHCCL.Config.DiagAliasS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
