Class User.DocCFEMRShowInfo Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DocCFEMRShowInfo, StorageStrategy = NewStorage1 ]
{

Index DisplayItem On DisplayItem;

Index DisplayNum On DisplayNum;

Property DisplayItem As %String(TRUNCATE = 1);

Property ExecuteCode As %String(MAXLEN = 10000, TRUNCATE = 1);

Property DisplayNum As %Integer;

Property IsActive As %String(TRUNCATE = 1);

Storage NewStorage1
{
<Data name="DocCFShowInfoDefaultData">
<Value name="1">
<Value>DisplayItem</Value>
</Value>
<Value name="2">
<Value>ExecuteCode</Value>
</Value>
<Value name="3">
<Value>DisplayNum</Value>
</Value>
<Value name="4">
<Value>IsActive</Value>
</Value>
<Value name="5">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^User.DocCFEMRShowInfoD</DataLocation>
<DefaultData>DocCFShowInfoDefaultData</DefaultData>
<IdLocation>^User.DocCFEMRShowInfoD</IdLocation>
<IndexLocation>^User.DocCFEMRShowInfoI</IndexLocation>
<StreamLocation>^User.DocCFEMRShowInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
<VersionLocation>%Library.CacheStorage</VersionLocation>
}

}
