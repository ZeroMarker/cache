Class CHSS.ReportLog Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = RowId, SqlTableName = ReportLog ]
{

/// 日期
Property ErrorDate As %Date(FORMAT = 1) [ Required, SqlColumnNumber = 2 ];

/// 表名
Property TableName As %String(MAXLEN = 30, TRUNCATE = 1) [ Required, SqlColumnNumber = 3 ];

/// 主键
Property DataRowId As %String(MAXLEN = 20, TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// 错误类型
Property ErrorType As %String(MAXLEN = 20, TRUNCATE = 1) [ SqlColumnNumber = 5 ];

/// 具体错误
Property ErrorMsg As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="ReportLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Error</Value>
</Value>
<Value name="3">
<Value>ErrorDate</Value>
</Value>
<Value name="4">
<Value>Type</Value>
</Value>
<Value name="5">
<Value>ErrorMsg</Value>
</Value>
<Value name="6">
<Value>DataRowId</Value>
</Value>
<Value name="7">
<Value>TableName</Value>
</Value>
<Value name="8">
<Value>ErrorType</Value>
</Value>
</Data>
<DataLocation>^CHSS.ReportLogD</DataLocation>
<DefaultData>ReportLogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.ReportLogD</IdLocation>
<IndexLocation>^CHSS.ReportLogI</IndexLocation>
<StreamLocation>^CHSS.ReportLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
