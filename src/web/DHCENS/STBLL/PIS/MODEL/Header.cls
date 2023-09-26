Class web.DHCENS.STBLL.PIS.MODEL.Header Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Header";

Property SourceSystem As %String;

Property MessageID As %String;

Storage Default
{
<Data name="HeaderDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SourceSystem</Value>
</Value>
<Value name="3">
<Value>TargetSystem</Value>
</Value>
</Data>
<DataLocation>^web.DHCENS.STBLL.PIE57F.HeaderD</DataLocation>
<DefaultData>HeaderDefaultData</DefaultData>
<IdLocation>^web.DHCENS.STBLL.PIE57F.HeaderD</IdLocation>
<IndexLocation>^web.DHCENS.STBLL.PIE57F.HeaderI</IndexLocation>
<StreamLocation>^web.DHCENS.STBLL.PIE57F.HeaderS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
