Class web.DHCEQUpload Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

// Property UploadFile As %Stream (STORAGE="FILE",LOCATION="D:\restore") [ Collection = binarystream ];

Property UploadFile As %GlobalBinaryStream;

Storage Default
{
<Data name="DHCEQUploadDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QFile</Value>
</Value>
<Value name="3">
<Value>UploadFile</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQUploadD</DataLocation>
<DefaultData>DHCEQUploadDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCEQUploadD</IdLocation>
<IndexLocation>^web.DHCEQUploadI</IndexLocation>
<StreamLocation>^web.DHCEQUploadS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
