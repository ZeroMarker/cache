Class DWR.MSG.TempImageFile Extends (%Persistent, %XML.Adaptor)
{

Property weekNo As %String;

Property filePath As %String;

Storage Default
{
<Data name="TempImageFileDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>weekNo</Value>
</Value>
<Value name="3">
<Value>filePath</Value>
</Value>
</Data>
<DataLocation>^DWR.MSG.TempImageFileD</DataLocation>
<DefaultData>TempImageFileDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DWR.MSG.TempImageFileD</IdLocation>
<IndexLocation>^DWR.MSG.TempImageFileI</IndexLocation>
<StreamLocation>^DWR.MSG.TempImageFileS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
