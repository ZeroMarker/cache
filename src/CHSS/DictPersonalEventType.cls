Class CHSS.DictPersonalEventType Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = RowId, SqlTableName = DictPersonalEventType ]
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

/// 父节点
Property RowIdParref As %Library.String(MAXLEN = 5, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = RowIdParref ];

Index CodeIndex On Code;

Storage Default
{
<Data name="DictPersonalEventTypeDefaultData">
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
<Value>RowIdParref</Value>
</Value>
<Value name="7">
<Value>Sort</Value>
</Value>
<Value name="8">
<Value>StartDate</Value>
</Value>
</Data>
<DataLocation>^CHSS.DictPersonalEventTypeD</DataLocation>
<DefaultData>DictPersonalEventTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.DictPersonalEventTypeD</IdLocation>
<IndexLocation>^CHSS.DictPersonalEventTypeI</IndexLocation>
<StreamLocation>^CHSS.DictPersonalEventTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
