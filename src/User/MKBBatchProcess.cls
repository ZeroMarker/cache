Class User.MKBBatchProcess Extends (%Persistent, User.Abstract) [ SqlTableName = MKB_BatchProcess, StorageStrategy = NewStorage1 ]
{

/// 方法描述
Property MethodDesc As %String(MAXLEN = "") [ Required, SqlColumnNumber = 2, SqlFieldName = Method_Desc ];

/// 方法命令
Property MethodName As %String(MAXLEN = "") [ Required, SqlColumnNumber = 3, SqlFieldName = Method_Name ];

/// 参数说明
Property ArgDesc As %String(MAXLEN = "") [ SqlColumnNumber = 4, SqlFieldName = Arg_Desc ];

/// 修改参数值
Property ArgValue As %String [ SqlColumnNumber = 5, SqlFieldName = Arg_Value ];

/// 标志(I导入,E导出,O为其他)
Property Flag As %String(DISPLAYLIST = ",Import,Export,Others", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",导入,导出,其他 ") [ SqlColumnNumber = 6 ];

/// Property Flag As %String(DISPLAYLIST = ",Import,Export,Others", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",I,E,O") [ SqlColumnNumber = 6 ];
/// 导入标志(Y导入,N导出,空为其他)
/// Property IFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6 ];
/// 导出标志
/// Property EFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7 ];
Index DescIndex On MethodDesc As Exact;

Index NameIndex On MethodName As Exact;

/*
<Data name="MKBBatchProcessDefaultData">
<Subscript>"1"</Subscript>
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
*/
Storage NewStorage1
{
<Data name="MKBBatchProcessDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MethodDesc</Value>
</Value>
<Value name="3">
<Value>MethodName</Value>
</Value>
<Value name="4">
<Value>ArgDesc</Value>
</Value>
<Value name="5">
<Value>ArgValue</Value>
</Value>
<Value name="6">
<Value>Flag</Value>
</Value>
</Data>
<DataLocation>^User.MKBBatchProcessD</DataLocation>
<DefaultData>MKBBatchProcessDefaultData</DefaultData>
<IdLocation>^User.MKBBatchProcessD</IdLocation>
<IndexLocation>^User.MKBBatchProcessI</IndexLocation>
<StreamLocation>^User.MKBBatchProcessS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
