Class web.DHCST.SoapModel.AdrRepRetModel Extends %Persistent
{

Parameter XMLNAME = "result";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property statusCode As %String(TRUNCATE = 1);

Property statusDesc As %String(TRUNCATE = 1);

Property businessId As %String(TRUNCATE = 1);

Property modifyData As %String(TRUNCATE = 1);

Storage Default
{
<Data name="AdrRepRetModelDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>statusCode</Value>
</Value>
<Value name="3">
<Value>statusDesc</Value>
</Value>
<Value name="4">
<Value>businessId</Value>
</Value>
<Value name="5">
<Value>modifyData</Value>
</Value>
</Data>
<DataLocation>^web.DHCST.S693C.AdrRepRetModelD</DataLocation>
<DefaultData>AdrRepRetModelDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCST.S693C.AdrRepRetModelD</IdLocation>
<IndexLocation>^web.DHCST.S693C.AdrRepRetModelI</IndexLocation>
<StreamLocation>^web.DHCST.S693C.AdrRepRetModelS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
