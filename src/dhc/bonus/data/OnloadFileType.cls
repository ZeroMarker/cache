/// 导入文件类型
Class dhc.bonus.data.OnloadFileType Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = OnloadFileTypeID ]
{

Property FileTypeCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

Property FileTypeName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

Property FileTypeDesc As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

Property ConfigName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5 ];

Property IsValid As %Library.Integer [ Required, SqlColumnNumber = 6 ];

Property FileType As %Library.String(MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7 ];

Property TargetTable As %Library.String(MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 8 ];

Index Code On FileTypeCode As Exact;

Index ConfigName On ConfigName As Exact;

Storage Default
{
<Data name="OnloadFileTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FileTypeCode</Value>
</Value>
<Value name="3">
<Value>FileTypeDesc</Value>
</Value>
<Value name="4">
<Value>FileTypeName</Value>
</Value>
<Value name="5">
<Value>ConfigName</Value>
</Value>
<Value name="6">
<Value>IsValid</Value>
</Value>
<Value name="7">
<Value>FileType</Value>
</Value>
<Value name="8">
<Value>TargetTable</Value>
</Value>
</Data>
<DataLocation>^dhcbsOnloadFileTypeD</DataLocation>
<DefaultData>OnloadFileTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsOnloadFileTypeD</IdLocation>
<IndexLocation>^dhcbsOnloadFileTypeI</IndexLocation>
<StreamLocation>^dhcbsOnloadFileTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
