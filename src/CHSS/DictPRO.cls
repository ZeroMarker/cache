/// 尿蛋白定性检测结果
Class CHSS.DictPRO Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = RowId, SqlTableName = DictPRO ]
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

Storage Default
{
<Data name="DictPRODefaultData">
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
</Data>
<DataLocation>^CHSS.DictPROD</DataLocation>
<DefaultData>DictPRODefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.DictPROD</IdLocation>
<IndexLocation>^CHSS.DictPROI</IndexLocation>
<StreamLocation>^CHSS.DictPROS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
