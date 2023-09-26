Class DWR.MSG.TimeLineCategory Extends (%Persistent, %XML.Adaptor)
{

Property categoryCode As %String;

Property categoryDesc As %String;

Property dataTypeCode As %String;

Property dataTypeDesc As %String;

Property viewType As %String;

Storage Default
{
<Data name="TimeLineCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>categoryCode</Value>
</Value>
<Value name="3">
<Value>categoryDesc</Value>
</Value>
<Value name="4">
<Value>dataTypeCode</Value>
</Value>
<Value name="5">
<Value>dataTypeDesc</Value>
</Value>
<Value name="6">
<Value>viewType</Value>
</Value>
</Data>
<DataLocation>^DWR.MSG.TimeLineCategoryD</DataLocation>
<DefaultData>TimeLineCategoryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DWR.MSG.TimeLineCategoryD</IdLocation>
<IndexLocation>^DWR.MSG.TimeLineCategoryI</IndexLocation>
<StreamLocation>^DWR.MSG.TimeLineCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
