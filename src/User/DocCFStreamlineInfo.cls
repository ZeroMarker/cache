Class User.DocCFStreamlineInfo Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = DocCFStreamlineInfo ]
{

Index ConditionalExpre On ConditionalExpre;

Index DisplayNum On DisplayNum;

Property ItemID As %String(TRUNCATE = 1);

Property ItemName As %String(TRUNCATE = 1);

Property ItemClick As %String(MAXLEN = 10000, TRUNCATE = 1);

Property ConditionalExpre As %String(MAXLEN = 10000, TRUNCATE = 1);

Property StrLink As %String(MAXLEN = 10000, TRUNCATE = 1);

Property DisplayNum As %Integer;

Property Operator As %String(TRUNCATE = 1);

Property OprDate As %String(TRUNCATE = 1);

Property IsActive As %String(TRUNCATE = 1);

Property isRefresh As %String(TRUNCATE = 1);

Property PreLineClass As %String(TRUNCATE = 1);

Property HospDr As User.CTHospital;

Storage Default
{
<Data name="DocCFStreamlineInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ConditionalExpre</Value>
</Value>
<Value name="3">
<Value>StrLink</Value>
</Value>
<Value name="4">
<Value>DisplayNum</Value>
</Value>
<Value name="5">
<Value>Operator</Value>
</Value>
<Value name="6">
<Value>OprDate</Value>
</Value>
<Value name="7">
<Value>IsActive</Value>
</Value>
<Value name="8">
<Value>ItemID</Value>
</Value>
<Value name="9">
<Value>ItemName</Value>
</Value>
<Value name="10">
<Value>ItemClick</Value>
</Value>
<Value name="11">
<Value>isRefresh</Value>
</Value>
<Value name="12">
<Value>PreLineClass</Value>
</Value>
<Value name="13">
<Value>HospDr</Value>
</Value>
</Data>
<DataLocation>^User.DocCFStreamlineInfoD</DataLocation>
<DefaultData>DocCFStreamlineInfoDefaultData</DefaultData>
<IdLocation>^User.DocCFStreamlineInfoD</IdLocation>
<IndexLocation>^User.DocCFStreamlineInfoI</IndexLocation>
<StreamLocation>^User.DocCFStreamlineInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
