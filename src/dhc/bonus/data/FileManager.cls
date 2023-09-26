Class dhc.bonus.data.FileManager Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = UpLoadFileID, SqlTableName = FileManager ]
{

Property UpLoadUserID As User.SSUser [ SqlColumnNumber = 2, SqlFieldName = UpLoadUserID ];

Property FileName As %Library.String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = FileName ];

Property UpLoadDate As %Library.TimeStamp [ SqlColumnNumber = 4, SqlFieldName = UpLoadDate ];

Index FileName On FileName;

Storage Default
{
<Data name="FileManagerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FileName</Value>
</Value>
<Value name="3">
<Value>Remark</Value>
</Value>
<Value name="4">
<Value>UpLoadDate</Value>
</Value>
<Value name="5">
<Value>UpLoadUserID</Value>
</Value>
<Value name="6">
<Value>FileCode</Value>
</Value>
</Data>
<DataLocation>^dhc.bonus.data.FileManagerD</DataLocation>
<DefaultData>FileManagerDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.bonus.data.FileManagerD</IdLocation>
<IndexLocation>^dhc.bonus.data.FileManagerI</IndexLocation>
<StreamLocation>^dhc.bonus.data.FileManagerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
