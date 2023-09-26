Class CHSS.DictPhysicalSign Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = RowId, SqlTableName = DictPhysicalSign ]
{

/// 编码
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = Code ];

/// 描述
Property Description As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = Description ];

/// 开始日期
Property StartDate As %Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = StartDate ];

/// 结束日期
Property EndDate As %Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = EndDate ];

/// 有效
Property Active As %Library.String(MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = Active ];

/// 排序
Property Sort As %String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = Sort ];

/// 类别
Property Type As %Integer [ SqlColumnNumber = 8, SqlFieldName = Type ];

/// 对应表
Property TableName As %String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = TableName ];

Storage Default
{
<Data name="DictPhysicalSignDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Active</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>EndDate</Value>
</Value>
<Value name="6">
<Value>Sort</Value>
</Value>
<Value name="7">
<Value>StartDate</Value>
</Value>
<Value name="8">
<Value>Type</Value>
</Value>
<Value name="9">
<Value>TableName</Value>
</Value>
</Data>
<DataLocation>^CHSS.DictPhysicalSignD</DataLocation>
<DefaultData>DictPhysicalSignDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.DictPhysicalSignD</IdLocation>
<IndexLocation>^CHSS.DictPhysicalSignI</IndexLocation>
<StreamLocation>^CHSS.DictPhysicalSignS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
