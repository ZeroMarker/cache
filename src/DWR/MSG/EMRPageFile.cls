Class DWR.MSG.EMRPageFile Extends (%Persistent, %XML.Adaptor)
{

Parameter XMLNAME = "PageFile";

/// 文件地址
Property fileLocation As %String(MAXLEN = 500, TRUNCATE = 1);

Storage Default
{
<Data name="EMRPageFileDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>fileLocation</Value>
</Value>
</Data>
<DataLocation>^DWR.MSG.EMRPageFileD</DataLocation>
<DefaultData>EMRPageFileDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DWR.MSG.EMRPageFileD</IdLocation>
<IndexLocation>^DWR.MSG.EMRPageFileI</IndexLocation>
<StreamLocation>^DWR.MSG.EMRPageFileS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
