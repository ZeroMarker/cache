Class User.DHCPicTypeStat Extends (%Library.Persistent, %XML.Adaptor)
{

Property PicUrl As %Library.String(COLLATION = "Exact", MAXLEN = 200);

Property Type As %Library.String(COLLATION = "Exact");

Property vendor As %Library.String(COLLATION = "Exact");

Property regno As %Library.String(COLLATION = "Exact");

Property incicode As %Library.String(COLLATION = "Exact");

Property DHCPicUrl As %Library.String(COLLATION = "Exact", MAXLEN = 200);

Index TypePicUrl On (Type As Exact, PicUrl As Exact);

Storage Default
{
<Data name="DHCPicTypeStatDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PicUrl</Value>
</Value>
<Value name="3">
<Value>Type</Value>
</Value>
<Value name="4">
<Value>vendor</Value>
</Value>
<Value name="5">
<Value>regno</Value>
</Value>
<Value name="6">
<Value>incicode</Value>
</Value>
<Value name="7">
<Value>DHCPicUrl</Value>
</Value>
</Data>
<DataLocation>^User.DHCPicTypeStatD</DataLocation>
<DefaultData>DHCPicTypeStatDefaultData</DefaultData>
<IdLocation>^User.DHCPicTypeStatD</IdLocation>
<IndexLocation>^User.DHCPicTypeStatI</IndexLocation>
<StreamLocation>^User.DHCPicTypeStatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
