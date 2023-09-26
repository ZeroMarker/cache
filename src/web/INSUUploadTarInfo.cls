Class web.INSUUploadTarInfo Extends %Persistent
{

Property TarDr As %String(CONTENT = "收费项目ID");

Property TarCode As %String(CONTENT = "收费项目代码");

Property TarDesc As %String(CONTENT = "收费项目名称");

Storage Default
{
<Data name="INSUUploadTarInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TarDr</Value>
</Value>
<Value name="3">
<Value>TarCode</Value>
</Value>
<Value name="4">
<Value>TarDesc</Value>
</Value>
</Data>
<DataLocation>^web.INSUUploadTarInfoD</DataLocation>
<DefaultData>INSUUploadTarInfoDefaultData</DefaultData>
<IdLocation>^web.INSUUploadTarInfoD</IdLocation>
<IndexLocation>^web.INSUUploadTarInfoI</IndexLocation>
<StreamLocation>^web.INSUUploadTarInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
