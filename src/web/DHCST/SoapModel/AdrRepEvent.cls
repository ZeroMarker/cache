Class web.DHCST.SoapModel.AdrRepEvent Extends %Persistent
{

Parameter XMLNAME = "child";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property ADDREVENT As %String(TRUNCATE = 1);

Property ADDREVENTCODE As %String(TRUNCATE = 1);

Property ADDREVENTElse As %String(TRUNCATE = 1);

Storage Default
{
<Data name="AdrRepEventDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ADDREvent</Value>
</Value>
<Value name="3">
<Value>ADDREventCODE</Value>
</Value>
<Value name="4">
<Value>ADDREventElse</Value>
</Value>
<Value name="5">
<Value>ADDREVENT</Value>
</Value>
<Value name="6">
<Value>ADDREVENTCODE</Value>
</Value>
<Value name="7">
<Value>ADDREVENTElse</Value>
</Value>
</Data>
<DataLocation>^web.DHCST.Soap693C.AdrRepEventD</DataLocation>
<DefaultData>AdrRepEventDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCST.Soap693C.AdrRepEventD</IdLocation>
<IndexLocation>^web.DHCST.Soap693C.AdrRepEventI</IndexLocation>
<StreamLocation>^web.DHCST.Soap693C.AdrRepEventS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
