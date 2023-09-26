Class EPRmeta.BindFieldGroup Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property QueryID As %String;

Property GroupFieldName As %String;

Property GroupFieldDesc As %String;

Property DefaultSelect As %String;

Property SelectMaxLimit As %String;

Property QueryCName As %String;

Property QueryQName As %String;

Property ReadOnlySetting As %String;

Index IdxQueryID On QueryID;

Index IdxQueryInfo On (QueryCName, QueryQName);

Storage Default
{
<Data name="BindFieldGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QueryID</Value>
</Value>
<Value name="3">
<Value>GroupFieldName</Value>
</Value>
<Value name="4">
<Value>GroupFieldDesc</Value>
</Value>
<Value name="5">
<Value>DefaultSelect</Value>
</Value>
<Value name="6">
<Value>SelectMaxLimit</Value>
</Value>
<Value name="7">
<Value>QueryCName</Value>
</Value>
<Value name="8">
<Value>QueryQName</Value>
</Value>
<Value name="9">
<Value>ReadOnlySetting</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.BindFieldGroupD</DataLocation>
<DefaultData>BindFieldGroupDefaultData</DefaultData>
<IdLocation>^DHCEPRM.BindFieldGroupD</IdLocation>
<IndexLocation>^DHCEPRM.BindFieldGroupI</IndexLocation>
<StreamLocation>^DHCEPRM.BindFieldGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
