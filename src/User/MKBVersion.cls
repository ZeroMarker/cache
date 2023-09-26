/// Creator:谷雪萍
/// CreateDate:20190823
/// Desc:医用知识库版本表
Class User.MKBVersion Extends (%Persistent, User.Abstract) [ SqlRowIdName = MKBV_RowId, SqlTableName = MKB_Version ]
{

/// 数据标识
Property MKBVDataFlag As %String [ Required, SqlColumnNumber = 2, SqlFieldName = MKBV_DataFlag ];

/// 数据ID
Property MKBVDataID As %String [ Required, SqlColumnNumber = 3, SqlFieldName = MKBV_DataID ];

/// 版本
Property MKBVVersion As User.MKBTerm [ Required, SqlColumnNumber = 4, SqlFieldName = MKBV_Version ];

/// 表名
Property MKBVTableName As %String [ Required, SqlColumnNumber = 5, SqlFieldName = MKBV_TableName ];

/// 根据数据标识和数据id 找到标识的索引
Index DataVersionIdx On (MKBVDataFlag As Exact, MKBVDataID As Exact, MKBVVersion As Exact);

/// 根据版本和数据标识，找数据id的索引
Index VersionDataIdx On (MKBVVersion As Exact, MKBVDataFlag As Exact, MKBVDataID As Exact);

Storage Default
{
<Data name="MKBVersionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKBVDataFlag</Value>
</Value>
<Value name="3">
<Value>MKBVDataID</Value>
</Value>
<Value name="4">
<Value>MKBVVersion</Value>
</Value>
<Value name="5">
<Value>MKBVTableName</Value>
</Value>
</Data>
<DataLocation>^User.MKBVersionD</DataLocation>
<DefaultData>MKBVersionDefaultData</DefaultData>
<IdLocation>^User.MKBVersionD</IdLocation>
<IndexLocation>^User.MKBVersionI</IndexLocation>
<StreamLocation>^User.MKBVersionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
