Class CHSS.DictRecordQualiIndex Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = RowId, SqlTableName = DictRecordQualiIndex ]
{

//备注

Property TableName As %Library.String(MAXLEN = 50, TRUNCATE = 1);

Property ColumnName As %Library.String(MAXLEN = 60, TRUNCATE = 1);

Property ColumnCode As %Library.String(MAXLEN = 30, TRUNCATE = 1);

Property bValid As %Library.String(MAXLEN = 5, TRUNCATE = 1);

Property IndexContent As %Library.String(MAXLEN = 100, TRUNCATE = 1);

Property IndexType As %Library.Integer;

Property Remark As %Library.String(MAXLEN = 100, TRUNCATE = 1);

Storage Default
{
<Data name="DictRecordQualiIndexDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ColumnCode</Value>
</Value>
<Value name="3">
<Value>ColumnName</Value>
</Value>
<Value name="4">
<Value>IndexContent</Value>
</Value>
<Value name="5">
<Value>IndexType</Value>
</Value>
<Value name="6">
<Value>Remark</Value>
</Value>
<Value name="7">
<Value>TableName</Value>
</Value>
<Value name="8">
<Value>bValid</Value>
</Value>
</Data>
<DataLocation>^CHSS.DictRecordQualiIndexD</DataLocation>
<DefaultData>DictRecordQualiIndexDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.DictRecordQualiIndexD</IdLocation>
<IndexLocation>^CHSS.DictRecordQualiIndexI</IndexLocation>
<StreamLocation>^CHSS.DictRecordQualiIndexS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
